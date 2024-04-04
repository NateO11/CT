//
//  LoginManager.swift
//  CT
//
//  Created by Nate Owen on 12/11/23.
//

import Foundation


class LoginManager {
    static func performLogin(username: String, password: String, completion: @escaping (Bool) -> Void) {
        // Replace this logic with your authentication logic
        // For simplicity, we'll assume a successful login if the username is "user" and the password is "password"
        let isValid = username == "User" && password == "Password"
        completion(isValid)
    }
}
