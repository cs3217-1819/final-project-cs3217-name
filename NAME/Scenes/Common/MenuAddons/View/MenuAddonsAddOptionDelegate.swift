//
//  MenuAddonsAddOptionDelegate.swift
//  NAME
//
//  Created by Julius on 20/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import UIKit

class MenuAddonsAddOptionDelegate: MenuAddonsTableViewCellProvider {
    weak var delegate: MenuAddonsTableViewCellDelegate?

    init(delegate: MenuAddonsTableViewCellDelegate) {
        self.delegate = delegate
    }

    func dequeueReusableCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell =
            tableView.dequeueReusableCell(withIdentifier: MenuAddonsTableViewAddCell.reuseIdentifier,
                                          for: indexPath)
        guard let cell = reusableCell as? MenuAddonsTableViewAddCell else {
            return reusableCell
        }
        cell.delegate = self
        return cell
    }
}

// MARK: - MenuAddonsTableViewAddCellDelegate
extension MenuAddonsAddOptionDelegate: MenuAddonsTableViewAddCellDelegate {
    func addButtonDidTap(sender: UIButton) {
        delegate?.addOptionDidTap(sender: sender)
    }
}
