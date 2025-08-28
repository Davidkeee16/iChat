//
//  FirebaseStorage.swift
//  iChat
//
//  Created by David Puksanskis on 11/08/2025.
//
import FirebaseAuth
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    private var waitingChatsRef: CollectionReference {
        guard let id = currentUser?.id else {
            fatalError("No current user")
        }
        return db.collection("users").document(id).collection("waitingChats")
    }
    private var activeChatsRef: CollectionReference {
        guard let id = currentUser?.id else {
            fatalError("No current User id")
        }
        return db.collection("users").document(id).collection("activeChats")
    }
    private(set) var currentUser: MUser?
    
    func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let muser = MUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToMUser))
                    return
                }
                self.currentUser = muser
                completion(.success(muser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
                
            }
        }
    }
    
    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, userInfo: String?, sex: String?, completion: @escaping(Result<MUser, Error>) -> Void) {
        
        guard Validator.isFilledProfile(username: username, userInfo: userInfo, sex: sex) else { completion(.failure(UserError.notFilled))
            return }
        
        guard avatarImage != #imageLiteral(resourceName: "ProfileImageAdd") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        StorageService.shared.upload(photo: avatarImage!) { result in
            switch result {
            case .success(let url):
                let avatarURL = url.absoluteString
                let muser = MUser(username: username ?? "",
                                  email: email,
                                  avatarStringURL: avatarURL,
                                  userInfo: userInfo ?? "",
                                  sex: sex ?? "",
                                  id: id)
                self.usersRef.document(muser.id).setData(muser.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        self.currentUser = muser
                        completion(.success(muser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
    /*
    func checkIfUserHaveRequiedInfo(currentUser: User, completion: @escaping(Bool)-> Void) {
        
        
        let userUID = currentUser.uid
        let userDocRef = db.collection("users").document(userUID)
        
        userDocRef.getDocument { (document, error) in
            if error != nil {
                print("Error fetching user document")
                return
            }
            guard let document = document, document.exists else { print("User document does NOT exist. Required info not filled.")
                completion(false)
                return
            }
            let data = document.data()
            
            let hasFullName = data?["username"] as? String != nil
            let hasAboutUserInfo = data?["userInfo"] as? String != nil
            let choosenGender = data?["sex"] as? String != nil
            
            let reqiredInfo =  hasFullName && hasAboutUserInfo && choosenGender
            
            
            if reqiredInfo {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
     
    */
       func getWaitingChatMessages(chat: MChat, completion: @escaping (Result<[MMessage], Error>) -> Void) {
        guard let currentUserId = currentUser?.id else {
            completion(.failure(UserError.cannotGetUserInfo))
            return
        }

        let reference = db.collection("users")
            .document(currentUserId)
            .collection("waitingChats")
            .document(chat.friendId)
            .collection("messages")

        var messages = [MMessage]()
        
        reference.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                guard let message = MMessage(document: document) else { continue }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    func createWaitingChats(message: String, receiver: MUser, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let sender = self.currentUser, !sender.id.isEmpty else {
            completion(.failure(UserError.cannotGetUserInfo))
            return
        }

        let chatRef = db.collection("users")
            .document(receiver.id)
            .collection("waitingChats")
            .document(sender.id)

        let messageRef = chatRef.collection("messages")
        
        let message = MMessage(user: sender, content: message)
        let chat = MChat(friendUsername: sender.username,
                         friendAvatarStringURL: sender.avatarStringURL,
                         friendId: sender.id,
                         lastMessageContent: message.content
                         )

        chatRef.setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        }
    }

    func deleteWaitingChat(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        getWaitingChatMessages(chat: chat) { result in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentId = message.id else { return }
                    let messageRef = reference.document(documentId)
                    messageRef.delete { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func changeToActive(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        getWaitingChatMessages(chat: chat) { result in
            print("Im here")
            switch result {
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { result in
                    switch result {
                    case .success:
                        self.createActiveChat(chat: chat, messages: messages) { result in
                            switch result {
                            case .success:
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func createActiveChat(chat: MChat, messages: [MMessage], completion: @escaping (Result<Void, Error>) -> Void) {
        let chatRef = activeChatsRef.document(chat.friendId)
        
        chatRef.setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let messageRef = chatRef.collection("messages")
            let dispatchGroup = DispatchGroup()
            var saveError: Error?
            
            for message in messages {
                dispatchGroup.enter()
                let messageData = message.representation
                
                messageRef.addDocument(data: messageData) { error in
                    if let error = error {
                        saveError = error
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) {
                if let error = saveError {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    func sendMessage(chat: MChat, message: MMessage, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let currentUser = currentUser else { return }
        let friendRef = usersRef.document(chat.friendId).collection("activeChats").document(currentUser.id)
        let friendMessageRef = friendRef.collection("messages")
        let myMessagingRef = usersRef.document(currentUser.id).collection("activeChats").document(chat.friendId).collection("messages")
        
        let chatForFriend = MChat(friendUsername: currentUser.username, friendAvatarStringURL: currentUser.avatarStringURL, friendId: currentUser.id, lastMessageContent: message.content)
        
        friendRef.setData(chatForFriend.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            friendMessageRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                myMessagingRef.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
}
