//
//  AuthServiceFirebase.swift
//  iChat
//
//  Created by David Puksanskis on 30/07/2025.
//


import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    static let shared = AuthService()
    
    
    private init() {}
    
    
    func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Result<User, Error>) -> Void) {
        
        let email = userRequest.email
        let password = userRequest.password
    
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            guard let result = result else { completion(.failure(error!))
                return
            }
    
            
            
            let uid = result.user.uid
            
            let db = Firestore.firestore()
            db.collection("users")
                .document(uid)
                .setData(["email": email]) { error in
                    
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(result.user))
                    }
                }
        }
    }
    
    func signIn(with userRequest: LoginUserRequest, completion: @escaping (Result<User, Error>) -> Void) {
        
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error  in
            
            guard let result = result else { completion(.failure(error!))
            return }
            
            completion(.success(result.user))
        }
    }
    func signOut(completion: @escaping (Error?)-> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}



