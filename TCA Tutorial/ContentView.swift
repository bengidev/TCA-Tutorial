//
//  ContentView.swift
//  TCA Tutorial
//
//  Created by ENB Mac Mini on 08/12/25.
//

import CoreData
import SwiftUI

// MARK: - TaskItem

struct TaskItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let date: String
    let progress: Double?
    let priority: String?
    let members: [String] // Placeholder for avatar image names
    let assigne: String?
}

// MARK: - ContentView

struct ContentView: View {
    // MARK: SwiftUI Properties

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // MARK: Content Properties

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(self.items) { item in
                        NavigationLink {
                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                        } label: {
                            Text(item.timestamp!, formatter: itemFormatter)
                        }
                    }
                    .onDelete(perform: self.deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: self.addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {}) {
                            Label("Task Management", systemImage: "person.fill")
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Important for iPhone
    }

    // MARK: Functions

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try self.viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { self.items[$0] }.forEach(self.viewContext.delete)

            do {
                try self.viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
