//
//  Config.swift
//  NAME
//
//  Created by Caryn Heng on 29/3/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

// MARK: - ReuseIdentifiers
enum ReuseIdentifiers {
    static let orderCellIdentifier = "orderCellIdentifier"
    static let orderItemCellIdentifier = "orderItemCellIdentifier"
}

// MARK: - Splash
enum SplashConstants {
    static let numTapsToLoginScreen: Int = 5
    static let tapAreaWidth: CGFloat = 100.0
    static let tapAreaHeight: CGFloat = 100.0
}

// MARK: - Login
enum LoginConstants {
    static let cancelButtonTitle = "CANCEL"
    static let stallLoginButtonTitle = "STALL"
    static let establishmentLoginButtonTitle = "ESTABLISHMENT"
    static let usernamePlaceholder = "Username"
    static let passwordPlaceholder = "Password"

    static let containerHeight: CGFloat = 300.0
    static let maxContainerWidth: CGFloat = 600.0
    static let minContainerMargin: CGFloat = 40.0
    static let containerCornerRadius: CGFloat = 20.0
    static let containerColor: UIColor = .gray
    static let textFieldMargin: CGFloat = 16.0
    static let textFieldHeight: CGFloat = 60.0
    static let textFieldBackgroundColor: UIColor = .white
}

// MARK: - Stall Root
enum StallRootConstants {
    static let menuTabBarTitle = "MENU"
    static let kitchenTabBarTitle = "KITCHEN"
    static let settingsTabBarTitle = "SETTINGS"
}

// MARK: - Stall Kitchen Backlog
enum KitchenBacklogConstants {
    static let clockHeight: CGFloat = 50.0
    static let clockWidth: CGFloat = 100.0

    // MARK: Order
    static let orderReadyButtonTitle = "ALL READY"
    static let orderCompleteButtonTitle = "ORDER COLLECTED"
    static let orderWidth: CGFloat = 400
    static let spaceBetweenOrders: CGFloat = 40
    static let orderMargins: CGFloat = 40
}

enum OrderConstants {
    static let preparedItemsSectionTitle = "PREPARED"
    static let orderNumberPrefix = "Order #"
    static let headerPadding: CGFloat = 16.0
    static let headerHeight: CGFloat = 50.0

    // MARK: Order Item
    static let eatInDiningOptionTitle = "(EAT IN)"
    static let takeAwayDiningOptionTitle = "(TAKE AWAY)"
    static let itemReadyButtonTitle = "ITEM READY"
    static let addonsHeaderTitle = "Add Ons:"
    static let commentsHeaderTitle = "Comments:"
    static let optionsHeaderTitle = "Options:"
    static let orderItemPadding: CGFloat = 8.0
    static let leftPanelRatio: CGFloat = 1 / 5
    static let orderItemTitleFontSize: CGFloat = 22.0
}

// MARK: - Establishment Root
enum EstablishmentRootConstants {
    static let stallListTabBarTitle = "STALLS"
    static let settingsTabBarTitle = "SETTINGS"
}

// MARK: - Stall List
enum StallListConstants {
    // MARK: Stall Cell
    static let customerCellHeight: CGFloat = 70.0
    static let establishmentCellHeight: CGFloat = 300.0
    static let establishmentCellWidth: CGFloat = 300.0
    static let editButtonTitle = "EDIT"
    static let deleteButtonTitle = "DELETE"
    static let titleFontSize: CGFloat = 22.0
    static let cellPadding: CGFloat = 8.0
}

// MARK: - Customer Common
enum CustomerCommonConstants {
    static let primaryWidth: CGFloat = 250
}

// MARK: - Constraints
enum ConstraintConstants {
    static let standardValue: CGFloat = 8.0
    static let dividerWidth: CGFloat = 1.0
}

// MARK: - Menu
enum MenuConstants {
    static let menuItemDragTypeIdentifier = "menuItemDragType"
}

// MARK: - MenuAddons
enum MenuAddonsConstants {
    static let maximumNumberOfLines = 4
    static let extraCommentAlertTitle = "Extra Comment"
    static let commentLabelText = "EXTRA COMMENT"
    static let deleteCommentButtonTitle = "DELETE EXTRA COMMENT"
    static let resetButtonTitle = "RESET ALL"
    static let sectionResetButtonTitle = "RESET"
    static let addButtonTitle = "ADD"
    static let addOnsOptionTitle = "Add-ons"
    static let booleanChoices = [true, false]
    static let booleanChoicesTitle = ["YES", "NO"]
    static let addonsSize = CGSize(width: 100, height: 120)
    static let footerViewHeight: CGFloat = 100.0
    static let sectionHeaderHeight: CGFloat = 50.0
    static let diningOptionTitle = "Dining Options"
    static let diningOptionLabels: [(title: String, value: OrderItem.DiningOption)] = OrderItem.DiningOption.allCases
        .map { option in
            switch option {
            case .eatin: return ("Eat-in", option)
            case .takeaway: return ("Takeaway", option)
            }
        }
}

// MARK: - QuantityView
enum QuantityViewConstants {
    static let increaseQuantityTitle = "▲"
    static let decreaseQuantityTitle = "▼"
    static let title = "Qty"
    static let quantityWidth: CGFloat = 30.0
}

enum AlertConstants {
    static let okTitle = "OK"
    static let cancelTitle = "Cancel"
}

// MARK: - Button
enum ButtonConstants {
    static let mediumButtonHeight: CGFloat = 50.0
}
