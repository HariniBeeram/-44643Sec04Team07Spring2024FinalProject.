//
//  File.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 4/19/24.
//

import FirebaseAuth


final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() {}
    
    func createUser(email: String, password: String) async throws{
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    
    func signIn(email: String, password: String) async throws{
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signOut() throws{
        try Auth.auth().signOut()
    }
    
    func resetPassword(email :String) async throws{
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("Password reset email sent successfully.")
        } catch {
            print("Error sending password reset email: \(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteUser(){
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print("Error while trying to delete user - \(error.localizedDescription)")
            } else {
                print("Success! User deleted.")
            }
        }
    }
}
