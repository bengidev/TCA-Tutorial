import ComposableArchitecture
import SwiftUI
import UIKit

struct ContactView: View {
  // MARK: Properties

  @Perception.Bindable var store: StoreOf<ContactReducer>

  // MARK: Content Properties

  var body: some View {
    WithPerceptionTracking {
      if #available(iOS 16, *) {
        ios16View
      } else {
        ios15View
      }
    }
  }

  // MARK: - iOS 16+ View

  @available(iOS 16, *)
  private var ios16View: some View {
    WithPerceptionTracking {
      NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
        contactListView
      } destination: { store in
        ContactDetailView(store: store)
      }
      .sheet(
        item: $store.scope(state: \.destination?.addContact, action: \.destination.addContact)
      ) { addContactStore in
        NavigationStack {
          AddContactView(store: addContactStore)
        }
      }
      .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
  }

  // MARK: - iOS 15 View

  private var ios15View: some View {
    WithPerceptionTracking {
      NavigationView {
        List {
          ForEach(store.contacts) { contact in
            Button {
              store.send(.contactRowTapped(contact))
            } label: {
              HStack {
                Text(contact.name)
                  .foregroundColor(.primary)

                Spacer()

                Button {
                  store.send(.deleteButtonTapped(id: contact.id))
                } label: {
                  Image(systemName: "trash")
                    .foregroundColor(.red)
                }
                .buttonStyle(.borderless)

                Image(systemName: "chevron.right")
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
            }
            .buttonStyle(.plain)
          }
        }
        .navigationTitle("Contacts")
        .toolbar {
          ToolbarItem {
            Button {
              store.send(.addButtonTapped)
            } label: {
              Image(systemName: "plus")
            }
          }
        }
      }
      .navigationViewStyle(.stack)
      .sheet(
        item: $store.scope(state: \.destination?.addContact, action: \.destination.addContact)
      ) { addContactStore in
        NavigationView {
          AddContactView(store: addContactStore)
        }
        .navigationViewStyle(.stack)
      }
      .sheet(
        item: $store.scope(state: \.destination?.contactDetail, action: \.destination.contactDetail)
      ) { detailStore in
        NavigationView {
          ContactDetailView(store: detailStore)
        }
        .navigationViewStyle(.stack)
      }
      .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
  }

  // MARK: - Shared Contact List (iOS 16+ only)

  @available(iOS 16, *)
  private var contactListView: some View {
    WithPerceptionTracking {
      List {
        ForEach(store.contacts) { contact in
          NavigationLink(state: ContactDetailReducer.State(contact: contact)) {
            HStack {
              Text(contact.name)

              Spacer()

              Button {
                store.send(.deleteButtonTapped(id: contact.id))
              } label: {
                Image(systemName: "trash")
                  .foregroundColor(.red)
              }
            }
          }
          .buttonStyle(.borderless)
        }
      }
      .navigationTitle("Contacts")
      .toolbar {
        ToolbarItem {
          Button {
            store.send(.addButtonTapped)
          } label: {
            Image(systemName: "plus")
          }
        }
      }
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
