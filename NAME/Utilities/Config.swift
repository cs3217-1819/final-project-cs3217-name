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

// MARK: - Colorrs
enum Colors {
    static let base = UIColor(displayP3Red: 106 / 255,
                              green: 108 / 255,
                              blue: 209 / 255,
                              alpha: 1)
}

// MARK: - Splash
enum SplashConstants {
    static let numTapsToLoginScreen = 5
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
    static let containerColor = UIColor.Custom.purple
    static let textFieldMargin: CGFloat = 16.0
    static let textFieldHeight: CGFloat = 60.0
    static let textFieldBackgroundColor: UIColor = .white
}

// MARK: - Stall Root
enum StallRootConstants {
    static let menuTabBarTitle = "MENU"
    static let kitchenTabBarTitle = "KITCHEN"
    static let settingsTabBarTitle = "SETTINGS"
    static let logoutTabBarTitle = "LOG OUT"
}

// MARK: - Stall Kitchen Backlog
enum KitchenBacklogConstants {
    static let clockHeight: CGFloat = 50.0
    static let clockWidth: CGFloat = 150.0

    // MARK: Order
    static let orderReadyButtonTitle = "ALL READY"
    static let orderCompleteButtonTitle = "ORDER COLLECTED"
    static let orderWidth: CGFloat = 350
    static let spaceBetweenOrders: CGFloat = 20
    static let orderMargins: CGFloat = 20
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
    static let orderDetailsFontColor: UIColor = .darkGray
}

// MARK: - Establishment Root
enum EstablishmentRootConstants {
    static let stallListTabBarTitle = "STALLS"
    static let settingsTabBarTitle = "SETTINGS"
    static let logoutTabBarTitle = "LOG OUT"
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

// MARK: - Order Confirmation
enum OrderConfirmationItemConstants {

    // Item View Labels
    static let addonsLabelTitle = "Add Ons"
    static let optionsLabelTitle = "Options"
    static let discountsLabelTitle = "Discounts"

    static let increaseQuantityButtonTitle = "▲"
    static let decreaseQuantityButtonTitle = "▼"
    static let removeItemButtonTitle = "🗑️"

    static let diningOptionControlHeretitle = "Here"
    static let diningOptionControlTakeAwaytitle = "Take Away"

    // Font sizes
    static let nameLabelFontSize: CGFloat = 30
    static let additionalsLabelFontSize: CGFloat = 20
    static let quantityLabelsFontSize: CGFloat = 40
    static let discountedPriceFontSize: CGFloat = 36

    // Item View Constraints
    static let itemViewOffsetTop = 10
    static let itemViewBottom = -10

    static let imageOffsetTop = 20
    static let imageOffsetLeft = 30
    static let imageLength = 150

    static let nameLabelOffsetTop = 20
    static let nameLabelOffsetLeft = 40
    static let nameOptionsLabelOffsetHeight = 30
    static let additionalsOffsetTop = 5
    static let additionalsLabelsOffsetTop = 10
    static let discountsStackBottom = -20

    static let priceLabelsOffsetRight = -20
    static let priceLabelsGapHeight = 10
    static let quantityLabelOffsetRight = -100
    static let increaseQuantityOffsetHeight = -10
    static let decreaseQuantityOffsetHeight = 10
    static let removeItemButtonOffsetLeft = 50
    static let diningOptionControlOffsetBottom = -15
    static let diningOptionControlOffsetRight = -15
}

enum OrderConfirmationOptionsAddonConstants {
    static let imageLength = 30
    static let nameLabelOffsetTop = 5
    static let nameLabelOffsetLeft = 10
    static let nameLabelBottom = -10
    static let optionPriceLabelOffsetLeft = 20
}

enum OrderConfirmationDiscountConstants {
    static let nameLabelOffsetTop = 5
    static let nameLabelBottom = -10
    static let descriptionLabelOffsetLeft = 20
}

enum OrderConfirmationTotalConstants {
    // Labels
    static let subtotalLabelTitle = "Subtotal"
    static let discountsLabelTitle = "Establishment Discounts"
    static let surchargesLabelTitle = "Establishment Surcharges"
    static let totalLabelTitle = "Total"

    // Font sizes
    static let subtotalLabelFontSize: CGFloat = 28
    static let discountsSurchargesLabelFontSize: CGFloat = 25
    static let totalLabelFontSize: CGFloat = 30

    // Colours
    static let labelsColor = UIColor.white

    // Constraints
    static let totalsLabelsOffsetRight = -200
    static let totalsLabelOffsetTop = 20
    static let totalsLabelPriceGap = 10
    static let totalsSubLabelPriceGap = 20
    static let grandTotalLabelBottom = -10
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

enum MenuInfoConstants {
    static let maximumNumberOfLines = 4
    static let nameAlertTitle = "Menu Item Name"
    static let priceAlertTitle = "Price"
    static let detailsAlertTitle = "Menu Item Detail"
    static let extraCommentAlertTitle = "Extra Comment"
    static let commentLabelText = "EXTRA COMMENT"
    static let deleteCommentButtonTitle = "DELETE EXTRA COMMENT"
}

// MARK: - MenuAddons
enum MenuAddonsConstants {
    static let featureComingSoon = "Feature coming in version 2!"
    static let addChoiceNameTitle = "%@"
    static let addChoiceNameMessage = "New choice title"
    static let addChoicePriceMessage = "New choice price"
    static let addChoicePriceDefault = "0.0"
    static let addChoiceButtonTitle = "+"
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
    static let backgroundColor = UIColor.Custom.paleGray
    static let selectedCellBackgroundColor: UIColor = .white
}

// MARK: - QuantityView
enum QuantityViewConstants {
    static let increaseQuantityTitle = "▲"
    static let decreaseQuantityTitle = "▼"
    static let title = "Qty"
    static let quantityWidth: CGFloat = 30.0
    static let quantityFontSize: CGFloat = 22.0
}

enum AlertConstants {
    static let okTitle = "OK"
    static let cancelTitle = "Cancel"
}

// MARK: - Button
enum ButtonConstants {
    static let mediumButtonHeight: CGFloat = 45.0
}

// MARK: - Corner Radius
enum CornerRadiusConstants {
    static let standardRadius: CGFloat = 15.0
    static let subtleRadius: CGFloat = 10.0
}

// MARK: - Date
enum DateConstants {
    static let timerSuffix = " ago"
}

// MARK: - Custom Alert
enum CustomAlertConstants {
    static let doneButtonTitle = "OK"
    static let titleFontSize: CGFloat = 32.0
    static let imageViewHeight: CGFloat = 200.0
    static let alertWidth: CGFloat = 450.0
}

// MARK: - Image
enum ImageConstants {
    static let sadMascotName = "mascot-sad"
}

// MARK: - Error Messages
enum ErrorMessage {
    static let stallDeleteErrorTitle = "Sorry! Error Deleting Stall."
    static let stallDeleteErrorMessage = "The stall cannot be deleted. Please try again later."
}
