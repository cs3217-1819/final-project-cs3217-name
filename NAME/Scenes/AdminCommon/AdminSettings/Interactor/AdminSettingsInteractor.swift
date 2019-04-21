//
//  AdminSettingsInteractor.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol AdminSettingsInteractorInput: AdminSettingsViewControllerOutput {

}

protocol AdminSettingsInteractorOutput {
    func presentStallSettingsForStall(name: String?, details: String?)
    func presentStallSettingsForEstablishment(name: String?, location: String?)
    func presentEstablishmentSettings(name: String?, location: String?, details: String?)
}

final class AdminSettingsInteractor {
    fileprivate struct Dependencies {
        let storageManager: StorageManager
        let authManager: AuthManager
    }
    private let deps: Dependencies

    let output: AdminSettingsInteractorOutput
    let worker: AdminSettingsWorker

    private let stallOrEstablishmentId: String
    private let settingsType: SettingsType

    // MARK: - Initializers
    init(id: String,
         type: SettingsType,
         output: AdminSettingsInteractorOutput,
         injector: DependencyInjector,
         worker: AdminSettingsWorker = AdminSettingsWorker()) {
        deps = injector.dependencies()
        stallOrEstablishmentId = id
        settingsType = type
        self.output = output
        self.worker = worker
    }
}

// MARK: - AdminSettingsInteractorInput
extension AdminSettingsInteractor: AdminSettingsViewControllerOutput {
    func reload() {
        guard let userAccountType = deps.authManager.getCurrentStallOrEstablishment()?.type else {
            return
        }
        switch (userAccountType, settingsType) {
        case (.stall, .stall):
            presentStallSettingsForStall()
        case (.establishment, .stall):
            presentStallSettingsForEstablishment()
        case (.establishment, .establishment):
            presentEstablishmentSettings()
        case (.stall, .establishment):
            assertionFailure("Invalid combination of account type and settings type.")
            return
        }
    }

    private func presentStallSettingsForStall() {
        guard let stall = deps.storageManager.getStall(id: stallOrEstablishmentId) else {
            // TODO: Stall not found error
            return
        }
        output.presentStallSettingsForStall(name: stall.name, details: stall.details)
    }

    private func presentStallSettingsForEstablishment() {
        guard let stall = deps.storageManager.getStall(id: stallOrEstablishmentId) else {
            // TODO: Stall not found error
            return
        }
        output.presentStallSettingsForEstablishment(name: stall.name, location: stall.location)
    }

    private func presentEstablishmentSettings() {
        guard let establishment = deps.storageManager.getEstablishment(id: stallOrEstablishmentId) else {
            // TODO: Establishment not found error
            return
        }
        output.presentEstablishmentSettings(name: establishment.name,
                                            location: establishment.location,
                                            details: establishment.details)
    }

    func update(name: String?, location: String?, details: String?) {
        do {
            try deps.storageManager.writeTransaction { manager in
                switch settingsType {
                case .stall:
                    manager.updateStall(id: stallOrEstablishmentId,
                                        name: name,
                                        location: location,
                                        details: details)
                case .establishment:
                    manager.updateEstablishment(id: stallOrEstablishmentId,
                                                name: name,
                                                location: location,
                                                details: details)
                }
            }
        } catch {
            // TODO: Handle error
            print("Update error")
        }
    }
}

// MARK: - Dependency injection
extension DependencyInjector {
    fileprivate func dependencies() -> AdminSettingsInteractor.Dependencies {
        return AdminSettingsInteractor.Dependencies(storageManager: storageManager, authManager: authManager)
    }
}
