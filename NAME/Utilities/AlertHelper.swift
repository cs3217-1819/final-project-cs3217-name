//
//  AlertHelper.swift
//  NAME
//
//  Created by Julius on 18/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import UIKit

enum AlertHelper {
    /// A factory for UIAlertController of style alert. It will only create textField
    /// if textFieldText is not nil.
    /// The content of the textField is the argument to the okHandler.
    static func makeAlertController(title: String?,
                                    message: String?,
                                    textFieldText: String?,
                                    showCancelButton: Bool = true,
                                    okHandler: @escaping (String?) -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let textFieldText = textFieldText {
            alertController.addTextField { $0.text = textFieldText }
        }
        let okAction = UIAlertAction(title: AlertConstants.okTitle, style: .default) { _ in
            okHandler(alertController.textFields?.first?.text)
        }
        alertController.addAction(okAction)
        if showCancelButton {
            let cancelAction = UIAlertAction(title: AlertConstants.cancelTitle,
                                             style: .cancel,
                                             handler: nil)
            alertController.addAction(cancelAction)
        }
        return alertController
    }
}
