//
//  Account.swift
//  NAME
//
//  Created by Caryn Heng on 20/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import RealmSwift

extension String {
    fileprivate var secureHash: String {
        // TODO: Use something more secure than Facebook-standard ROT26
        return self
    }
}

class Account: Object {

    // MARK: - Properties
    @objc dynamic var username: String = ""
    @objc private dynamic var password: String = ""
    @objc dynamic private var accessControlEncoded = Data()

    private var _accessControl: AccessControl?
    var accessControl: AccessControl {
        get {
            if let accessControl = _accessControl {
                return accessControl
            }
            let accessControl = ModelHelper.decodeAsJson(AccessControl.self, from: accessControlEncoded)
            _accessControl = accessControl
            return accessControl
        }
        set {
            accessControlEncoded = ModelHelper.encodeAsJson(newValue)
            _accessControl = newValue
        }
    }

    var accountType: AccountType {
        switch accessControl {
        case .kitchen, .stallOwner:
            return .stall
        case .establishment:
            return .establishment
        }
    }

    // MARK: - Initialisers

    convenience init(username: String, password: String, accessControl: AccessControl) {
        self.init()

        self.username = username
        self.password = password.secureHash
        self.accessControl = accessControl
    }

    override static func primaryKey() -> String? {
        return "username"
    }

    // MARK: - Methods

    func checkPassword(_ candidate: String) -> Bool {
        return candidate.secureHash == password
    }
}
