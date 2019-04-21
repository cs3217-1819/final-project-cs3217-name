//
//  AccessControl.swift
//  NAME
//
//  Created by Caryn Heng on 20/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

enum AccessControl {
    case kitchen(stallId: String)
    case stallOwner(stallId: String)
    case establishment(establishmentId: String)
}

extension AccessControl: Codable {
    private enum CodingKeys: CodingKey {
        case userType
        case accountType
    }

    private enum UserType: Int, Codable {
        case kitchen
        case stallOwner
        case establishment

        init(of accessControl: AccessControl) {
            switch accessControl {
            case .kitchen: self = .kitchen
            case .stallOwner: self = .stallOwner
            case .establishment: self = .establishment
            }
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let usertype = try container.decode(UserType.self, forKey: .userType)
        switch usertype {
        case .kitchen:
            let stallId = try container.decode(String.self, forKey: .accountType)
            self = .kitchen(stallId: stallId)
        case .stallOwner:
            let stallId = try container.decode(String.self, forKey: .accountType)
            self = .stallOwner(stallId: stallId)
        case .establishment:
            let establishmentId = try container.decode(String.self, forKey: .accountType)
            self = .establishment(establishmentId: establishmentId)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(UserType(of: self), forKey: .userType)
        switch self {
        case .kitchen(let stall), .stallOwner(let stall):
            try container.encode(stall, forKey: .accountType)
        case .establishment(let establishment):
            try container.encode(establishment, forKey: .accountType)
        }
    }
}
