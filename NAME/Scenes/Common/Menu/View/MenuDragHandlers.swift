//
//  MenuDragHandlers.swift
//  NAME
//
//  Created by E-Liang Tan on 16/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

private typealias DragLocalObject = (section: Int, itemId: String)

// MARK: - Drag

protocol MenuDragHandlerDelegate: class {
    func dragHandler(_ handler: MenuDragHandler, menuItemIdForIndexPath indexPath: IndexPath) -> String?
    func dragHandler(_ handler: MenuDragHandler, willBeginDragSessionForCategoryAtIndex index: Int)
    func dragHandlerDidEndDragSession(_ handler: MenuDragHandler)
}

final class MenuDragHandler: NSObject, UICollectionViewDragDelegate {
    private weak var delegate: MenuDragHandlerDelegate?

    init(delegate: MenuDragHandlerDelegate) {
        self.delegate = delegate
        super.init()
    }

    private func dragItems(forIndexPath indexPath: IndexPath) -> [UIDragItem] {
        guard let menuItemId = delegate?.dragHandler(self, menuItemIdForIndexPath: indexPath) else {
            return []
        }

        let itemProvider = NSItemProvider(item: menuItemId as NSSecureCoding,
                                          typeIdentifier: MenuConstants.menuItemDragTypeIdentifier)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = (section: indexPath.section, itemId: menuItemId) as DragLocalObject
        return [dragItem]
    }

    func collectionView(_ collectionView: UICollectionView,
                        itemsForBeginning session: UIDragSession,
                        at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(forIndexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        itemsForAddingTo session: UIDragSession,
                        at indexPath: IndexPath,
                        point: CGPoint) -> [UIDragItem] {
        return dragItems(forIndexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        guard let dragLocalObject = session.items.first?.localObject as? DragLocalObject else {
            return
        }
        delegate?.dragHandler(self, willBeginDragSessionForCategoryAtIndex: dragLocalObject.section)
    }

    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        delegate?.dragHandlerDidEndDragSession(self)
    }
}

// MARK: - Drop

protocol CategoryDropHandlerDelegate: class {
    /// Delegate method that provides a drop target for the handler.
    ///
    /// - Returns: The drop target to be used by this drop handler.
    func dropHandlerDropTarget(_ handler: CategoryDropHandler) -> UIView

    /// Delegate method that informs the drop handler whether a drop can be handled.
    ///
    /// - Parameters:
    ///     - handler: The calling handler
    ///     - point: The point in the drop target returned by `dropHandlerDropTarget(_:)` where the menu items
    ///         are hovering over.
    /// - Returns: Whether the menu items can be copied at `point`.
    func dropHandler(_ handler: CategoryDropHandler, canDropAt point: CGPoint) -> Bool

    /// Delegate method that handles the dropping of menu items on the drop target.
    ///
    /// - Parameters:
    ///     - handler: The calling handler
    ///     - menuItemIds: The menu items that were dropped. May contain duplicates.
    ///     - point: The point in the drop target returned by `dropHandlerDropTarget(_:)` where the menu items
    ///         were dropped on.
    func dropHandler(_ handler: CategoryDropHandler,
                     didDropMenuItemIds menuItemIds: [String],
                     at point: CGPoint)
}

final class CategoryDropHandler: NSObject, UIDropInteractionDelegate {
    private weak var delegate: CategoryDropHandlerDelegate?

    init(delegate: CategoryDropHandlerDelegate) {
        self.delegate = delegate
        super.init()
    }

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [MenuConstants.menuItemDragTypeIdentifier])
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        guard let delegate = delegate else {
            return UIDropProposal(operation: .cancel)
        }

        let target = delegate.dropHandlerDropTarget(self)
        let locationInTarget = session.location(in: target)
        let canDrop = delegate.dropHandler(self, canDropAt: locationInTarget)
        return UIDropProposal(operation: canDrop ? .copy : .cancel)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let delegate = delegate else {
            return
        }
        let menuItemIds: [String] = session.items.compactMap { ($0.localObject as? DragLocalObject)?.itemId }
        let target = delegate.dropHandlerDropTarget(self)
        let locationInTarget = session.location(in: target)
        delegate.dropHandler(self, didDropMenuItemIds: menuItemIds, at: locationInTarget)
    }
}
