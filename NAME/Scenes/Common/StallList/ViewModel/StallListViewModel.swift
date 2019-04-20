//
//  StallListViewModel.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

struct StallListEstablishmentViewModel {
    let name: String
}

struct StallListViewModel {
    struct StallViewModel {
        let name: String
        let location: String?
    }

    let stalls: [StallViewModel]
}
