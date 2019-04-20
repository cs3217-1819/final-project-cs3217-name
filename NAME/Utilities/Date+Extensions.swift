//
//  Date+Extensions.swift
//  NAME
//
//  Created by Caryn Heng on 17/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation

extension Date {
    func formattedAsTimeFromNow() -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        guard let formattedDate = formatter.string(from: self, to: Date()) else {
            return nil
        }
        return formattedDate + DateConstants.timerSuffix
    }

    func formattedAsTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
}
