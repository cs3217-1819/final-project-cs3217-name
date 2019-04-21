//
//  AdminSettingsPresenter.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol AdminSettingsPresenterInput: AdminSettingsInteractorOutput {

}

protocol AdminSettingsPresenterOutput: class {
    func display(viewModel: AdminSettingsViewModel)
}

typealias SettingsFieldViewModel = AdminSettingsViewModel.SettingsFieldViewModel

final class AdminSettingsPresenter {
    private(set) unowned var output: AdminSettingsPresenterOutput

    // MARK: - Initializers
    init(output: AdminSettingsPresenterOutput) {
        self.output = output
    }
}

// MARK: - AdminSettingsPresenterInput
extension AdminSettingsPresenter: AdminSettingsPresenterInput {
    func presentStallSettingsForStall(name: String?, details: String?) {
        let fields = [SettingsFieldViewModel(title: AdminSettingsConstants.nameTitle,
                                             placeholder: name ?? AdminSettingsConstants.namePlaceholder,
                                             type: .name),
                      SettingsFieldViewModel(title: AdminSettingsConstants.detailsTitle,
                                             placeholder: details ?? AdminSettingsConstants.detailsPlaceholder,
                                             type: .details)]
        let viewModel = AdminSettingsViewModel(header: AdminSettingsConstants.stallSettingsHeaderTitle,
                                               fields: fields)

        output.display(viewModel: viewModel)
    }

    func presentStallSettingsForEstablishment(name: String?, location: String?) {
        let fields = [SettingsFieldViewModel(title: AdminSettingsConstants.nameTitle,
                                             placeholder: name ?? AdminSettingsConstants.namePlaceholder,
                                             type: .name),
                      SettingsFieldViewModel(title: AdminSettingsConstants.locationTitle,
                                             placeholder: location ?? AdminSettingsConstants.locationPlaceholder,
                                             type: .location)]
        let viewModel = AdminSettingsViewModel(header: AdminSettingsConstants.stallSettingsHeaderTitle,
                                               fields: fields)

        output.display(viewModel: viewModel)
    }

    func presentEstablishmentSettings(name: String?, location: String?, details: String?) {
        let fields = [SettingsFieldViewModel(title: AdminSettingsConstants.nameTitle,
                                             placeholder: name ?? AdminSettingsConstants.namePlaceholder,
                                             type: .name),
                      SettingsFieldViewModel(title: AdminSettingsConstants.locationTitle,
                                             placeholder: location ?? AdminSettingsConstants.locationPlaceholder,
                                             type: .location),
                      SettingsFieldViewModel(title: AdminSettingsConstants.detailsTitle,
                                             placeholder: details ?? AdminSettingsConstants.detailsPlaceholder,
                                             type: .details)]
        let viewModel = AdminSettingsViewModel(header: AdminSettingsConstants.estSettingsHeaderTitle,
                                               fields: fields)

        output.display(viewModel: viewModel)
    }
}
