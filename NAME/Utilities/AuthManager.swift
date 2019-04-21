//
//  AuthManager.swift
//  NAME
//
//  Created by Caryn Heng on 21/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation

protocol AuthManager {
    func login(withUsername username: String, password: String) -> AccessControl?
    func logout()

    func getCurrentStallOrEstablishment() -> (id: String, type: AccountType)?
}

class ProductionAuthManager: AuthManager {
    private let storageManager: StorageManager
    private var accessControl: AccessControl?

    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }

    func login(withUsername username: String, password: String) -> AccessControl? {
        guard let user = storageManager.getAccount(username: username) else {
            print("User does not exist!")
            return nil
        }

        guard user.checkPassword(password) else {
            print("Wrong password!")
            return nil
        }

        // Update current access control
        accessControl = user.accessControl
        return user.accessControl
    }

    func logout() {
        accessControl = nil
    }

    func getCurrentStallOrEstablishment() -> (id: String, type: AccountType)? {
        guard let accessControl = accessControl else {
            return nil
        }

        switch accessControl {
        case .kitchen(let stallId), .stallOwner(let stallId):
            return (stallId, .stall)
        case .establishment(let establishmentId):
            return (establishmentId, .establishment)
        }
    }
}
