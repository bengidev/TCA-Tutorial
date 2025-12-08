//
//  TCA_TutorialApp.swift
//  TCA Tutorial
//
//  Created by ENB Mac Mini on 08/12/25.
//

import SwiftUI
import CoreData

@main
struct TCA_TutorialApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
