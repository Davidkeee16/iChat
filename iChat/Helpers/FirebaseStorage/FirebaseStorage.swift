//
//  FirebaseStorage.swift
//  iChat
//
//  Created by David Puksanskis on 11/08/2025.
//
import FirebaseAuth
import FirebaseFirestore

class FirebaseStorage {
    static let shared = FirebaseStorage()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    func saveProfileWith(id: String, email: String, fullName: String?, avatarImage: String?, description: String?, sex: String?, completion: @escaping(Result<MUser, Error>) -> Void) {
        
        guard Validator.isFilledProfile(fullName: fullName, userInfo: description, sex: sex) else { completion(.failure(UserError.notFilled))
        return }
        
        let muser = MUser(username: fullName ?? "",
                          email: email,
                          avatarStringURL: "not exist",
                          userInfo: description ?? "",
                          sex: sex ?? "",
                          id: id)
        self.usersRef.document(muser.id).setData(muser.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(muser))
            }
        }
        
    }
    func checkIfUserHaveRequiedInfo(currentUser: User, completion: @escaping(Bool)-> Void) {
        
        let db = Firestore.firestore()
        let userUID = currentUser.uid
        let userDocRef = db.collection("users").document(userUID)
        
        userDocRef.getDocument { (document, error) in
            if let error = error {
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
}
