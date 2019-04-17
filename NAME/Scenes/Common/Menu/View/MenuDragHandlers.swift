//
//  MenuDragHandlers.swift
//  NAME
//
//  Created by E-Liang Tan on 16/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

private typealias DragLocalObject = (section: Int, itemId: String)

final class MenuDragHandler: NSObject, UICollectionViewDragDelegate {
    private let dataSourceProvider: () -> MenuDataSource?

    init(dataSourceProvider: @escaping () -> MenuDataSource?) {
        self.dataSourceProvider = dataSourceProvider
        super.init()
    }

    private func dragItems(forIndexPath indexPath: IndexPath) -> [UIDragItem] {
        guard let menuItem = dataSourceProvider()?.menuItemViewModel(at: indexPath) else {
            return []
        }

        let itemProvider = NSItemProvider(item: menuItem.id as NSSecureCoding,
                                          typeIdentifier: MenuConstants.menuItemDragTypeIdentifier)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = (section: indexPath.section, itemId: menuItem.id) as DragLocalObject
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
        dataSourceProvider()?.freezeSection(forCategoryAtIndex: dragLocalObject.section)
    }

    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        dataSourceProvider()?.unfreezeSection()
    }
}

final class CategoryDropHandler: NSObject, UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [MenuConstants.menuItemDragTypeIdentifier])
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let menuItemIds: [String] = session.items.compactMap { ($0.localObject as? DragLocalObject)?.itemId }
        print("Kosnte", menuItemIds)
        // TODO: Identify category dropped on
        // TODO: (elsewhere) change category selector
        // TODO: (elsewhere) generate uncategorized category
    }
}
