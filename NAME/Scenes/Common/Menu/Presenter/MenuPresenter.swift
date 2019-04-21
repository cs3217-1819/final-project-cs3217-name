//
//  MenuPresenter.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

protocol MenuPresenterInput: MenuInteractorOutput {
}

protocol MenuPresenterOutput: class {
    func displayMenu(viewModel: MenuViewModel, isEditable: Bool)
    func display(actions: [MenuCategoryAction], forCategoryAt index: Int, name: String)
    func displayDetail(forMenuItemId id: String?, isEditable: Bool)
}

final class MenuPresenter {
    private(set) unowned var output: MenuPresenterOutput

    init(output: MenuPresenterOutput) {
        self.output = output
    }
}

// MARK: - MenuPresenterInput

extension MenuPresenter: MenuPresenterInput {
    private func viewModel(forCategory category: MenuCategory) -> MenuViewModel.MenuCategoryViewModel {
        let itemVMs = category.items.map { item in
            MenuViewModel.MenuItemViewModel(id: item.id,
                                            name: item.name,
                                            imageURL: item.imageURL,
                                            price: item.price,
                                            discounts: []) // TODO: Add discounts
        }
        return MenuViewModel.MenuCategoryViewModel(name: category.name, items: itemVMs)
    }

    private func viewModel(forMenu menu: Menu?) -> [MenuViewModel.MenuCategoryViewModel] {
        guard let menu = menu else {
            return []
        }
        let categoryVMs = menu.categories.map { viewModel(forCategory: $0) }
        return categoryVMs
    }

    private func viewModel(forStall stall: Stall?) -> MenuViewModel {
        guard let stall = stall else {
            return MenuViewModel(stall: MenuViewModel.MenuStallViewModel(name: ""),
                                 categories: [])
        }
        let stallVM = MenuViewModel.MenuStallViewModel(name: stall.name)
        let categoryVMs = viewModel(forMenu: stall.menu)
        return MenuViewModel(stall: stallVM, categories: categoryVMs)
    }

    func present(stall: Stall?, isEditable: Bool) {
        output.displayMenu(viewModel: viewModel(forStall: stall), isEditable: isEditable)
    }

    func present(actions: [MenuCategoryAction], forCategoryAt index: Int, name: String) {
        output.display(actions: actions, forCategoryAt: index, name: name)
    }

    func presentDetail(forMenuItemId id: String?, isEditable: Bool) {
        output.displayDetail(forMenuItemId: id, isEditable: isEditable)
    }
}
