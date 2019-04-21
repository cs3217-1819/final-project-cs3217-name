//
//  AdminSettingsViewModel.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

enum SettingsType {
    case stall
    case establishment
}

struct AdminSettingsViewModel {
    enum FieldType {
        case name
        case location
        case details
    }

    struct SettingsFieldViewModel {
        let title: String
        let placeholder: String
        let type: FieldType
    }

    let header: String
    let fields: [SettingsFieldViewModel]
}
