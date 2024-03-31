//
//  AuthViewModel.swift
//  CT
//
//  Created by Nate Owen on 3/7/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid : Bool  { get }
}


@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    private var db = Firestore.firestore()

    init() {
        self.userSession = Auth.auth().currentUser
        
//        Task {
//            await fetchUser()
//        }
    }
    
    func signIn(email: String, password: String) async throws -> String {
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }catch {
            print("Failed to Create user error \(error.localizedDescription)")
            return error.localizedDescription
        }
        return ""
    }
    
    func signUp(email: String, password: String, fullname: String) async throws -> String {
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, email: email, fullname: fullname)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("Users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("Failed to Create user error \(error.localizedDescription)")
            return error.localizedDescription
        }
        return ""
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        }
        catch{
            print((error.localizedDescription))
        }
        }
    
    func deleteAccount() {
        }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("Users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
        print("The user is \(String(describing: self.currentUser))")
        }
    
    
    func fetchUserTest() {
        let uid = Auth.auth().currentUser?.uid ?? "mockUID"
        let doc = db.collection("Users").document(uid)
        
        doc.getDocument { (document, error) in
            guard error == nil else {
                print("error")
                return
            }
            self.currentUser = document.map({ doc -> User in
                let data = doc.data()
                let id = data?["id"] as? String ?? ""
                let email = data?["email"] as? String ?? ""
                let fullname = data?["fullname"] as? String ?? ""
                
                return User(id: id, email: email, fullname: fullname, favorites: [])
            })
            
        }
          
    }
    
    func addUserFavorites() async {
        // should got to the current uid and then create/ add to the existing array of favorite schools
        }
}

extension AuthViewModel {
    
    static var mock: AuthViewModel {
        // Create an instance of AuthViewModel
        let mockViewModel = AuthViewModel()
        
        // Setup the mock data
        // Note: You might need to adjust this part depending on how FirebaseAuth.User and User are defined in your project.
        // For instance, you might need to create mock versions of these objects or use existing initializers with mock data.
        
        // Setup a mock user session
        
        
        // Setup a mock current user
        mockViewModel.currentUser = User(id: "mockUID", email: "mock@example.com", fullname: "Mock User")
        
        // Return the mocked ViewModel
        return mockViewModel
    }
}
