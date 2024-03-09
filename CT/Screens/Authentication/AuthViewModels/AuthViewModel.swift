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

    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
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
    
    func addUserFavorites() async {
        // should got to the current uid and then create/ add to the existing array of favorite schools
        }
}

