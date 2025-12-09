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
    static let store = Store(initialState: CounterReducer.State()) {
        CounterReducer()
            ._printChanges()
    }

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)

            CounterView(store: TCA_TutorialApp.store)
        }
    }
}
