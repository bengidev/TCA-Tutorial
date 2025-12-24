//
//  TCA_TutorialApp.swift
//  TCA Tutorial
//
//  Created by ENB Mac Mini on 08/12/25.
//

import ComposableArchitecture
import CoreData
import SwiftUI

@main
struct TCA_TutorialApp: App {
    // MARK: Static Properties

    static let store = Store(initialState: ContactReducer.State()) {
        ContactReducer()
            ._printChanges()
    }

    // MARK: Properties

    let persistenceController = PersistenceController.shared

    // MARK: Computed Properties

    var body: some Scene {
        WindowGroup {
            ContactView(store: TCA_TutorialApp.store)
        }
    }
}
