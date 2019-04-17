//
//  PassthroughStackView.swift
//  NAME
//
//  Created by E-Liang Tan on 17/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

/// A stack view which returns an arranged subview or nil as the hit test result.
///
/// See: <http://www.openradar.me/30592429>
class PassthroughStackView: UIStackView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in arrangedSubviews {
            let pointInSubview = convert(point, to: subview)
            if subview.point(inside: pointInSubview, with: event) {
                return subview
            }
        }
        return nil
    }
}
