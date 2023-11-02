//
//  Constants.swift
//  Media Finder
//
//  Created by ReMoSTos on 30/04/2023.
//

import Foundation
 // MARK: - Storyboards
struct Storyboards{
    static let main: String = "Main"
}

// MARK: - Views
struct Views {
    static let signUpVC: String = "SignUpVC"
    static let signInVC: String = "SignInVC"
    static let profileVC: String = "ProfileVC"
    static let mapVC: String = "MapVC"
    static let mediaVC: String = "MediaVC"
    static let historyVC: String = "HistoryVC"
}

// MARK: - UserDefaultsKeys
struct UserDefaultsKeys {
    static let isLoggedIn: String = "isLoggedIn"
    static let name: String = "name"
    static let phone: String = "phone"
    static let email: String = "email"
    static let password: String = "password"
    static let address: String = "address"
    static let gender: String = "gender"
    static let user: String = "user"
}

//MARK: - validationCases
struct validationCases {
    static let name: String = "Enter The Name"
    static let phone: String = "Enter The Phone"
    static let email: String = "Enter The Email"
    static let password: String = "Enter The Password"
    static let address: String = "Enter The Address"
    static let image: String = "user image is not changed!"
}




