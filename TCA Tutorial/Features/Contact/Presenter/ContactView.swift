import ComposableArchitecture
import SwiftUI
import UIKit

struct ContactView: View {
    // MARK: Properties

    @Perception.Bindable var store: StoreOf<ContactReducer>

    // MARK: Content Properties

    var body: some View {
        WithPerceptionTracking {
            NavigationView {
                List {
                    ForEach(self.store.contacts) { contact in
                        HStack {
                            Text(contact.name)

                            Spacer()

                            Button {
                                self.store.send(.deleteButtonTapped(id: contact.id))
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .navigationTitle("Contacts")
                .toolbar {
                    ToolbarItem {
                        Button {
                            self.store.send(.addButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(
                item: $store.scope(state: \.destination?.addContact, action: \.destination.addContact)
            ) { addContactStore in
                if #available(iOS 16.0, *) {
                    NavigationStack {
                        AddContactView(store: addContactStore)
                    }
                } else {
                    NavigationView {
                        AddContactView(store: addContactStore)
                    }
                    .navigationViewStyle(.stack)
                }
            }
            .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
        }
    }
}

#Preview {
    ContactView(
        store: Store(
            initialState: ContactReducer.State(
                contacts: [
                    ContactDTO(id: UUID(), name: "Blob"),
                    ContactDTO(id: UUID(), name: "Blob Jr"),
                    ContactDTO(id: UUID(), name: "Blob Sr"),
                ]
            )
        ) {
            ContactReducer()
        }
    )
}
