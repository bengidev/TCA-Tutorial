import ComposableArchitecture
import SwiftUI
import Testing
import XCTest

@testable import TCA_Tutorial

// MARK: - Contact Feature Tests

// Tests for ContactReducer actions and state mutations
@MainActor
struct ContactReducerTests {
    @Test
    func addFlow() async {
        // Setup: TestStore with initial state
        let store = TestStore(initialState: ContactReducer.State()) {
            ContactReducer()
        } withDependencies: {
            $0.uuid = .incrementing
        }

        await store.send(.addButtonTapped) {
            $0.destination = .addContact(
                AddContactReducer.State(
                    contact: ContactDTO(id: UUID(0), name: "")
                )
            )
        }

        await store.send(\.destination.addContact.setName, "Blob Jr.") {
            $0.$destination[case: \.addContact]?.contact.name = "Blob Jr."
        }

        await store.send(\.destination.addContact.saveButtonTapped)

        await store.receive(
            \.destination.addContact.delegate.saveContact,
            ContactDTO(id: UUID(0), name: "Blob Jr.")
        ) {
            $0.contacts = [
                ContactDTO(id: UUID(0), name: "Blob Jr.")
            ]
        }

        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }
    }

    @Test
    func addFlow_NonExhaustive() async {
        let store = TestStore(initialState: ContactReducer.State()) {
            ContactReducer()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        store.exhaustivity = .off

        await store.send(.addButtonTapped)
        await store.send(\.destination.addContact.setName, "Blob Jr.")
        await store.send(\.destination.addContact.saveButtonTapped)
        await store.skipReceivedActions()

        store.assert {
            $0.contacts = [
                ContactDTO(id: UUID(0), name: "Blob Jr.")
            ]

            $0.destination = nil
        }
    }

    @Test
    func deleteContact() async {
        let store = TestStore(
            initialState: ContactReducer.State(
                contacts: [
                    ContactDTO(id: UUID(0), name: "Blob"),
                    ContactDTO(id: UUID(1), name: "Blob Jr.")
                ]
            )
        ) {
            ContactReducer()
        }

        await store.send(.deleteButtonTapped(id: UUID(1))) {
            $0.destination = .alert(.deleteConfirmation(id: UUID(1)))
        }

        await store.send(.destination(.presented(.alert(.confirmDeletion(id: UUID(1)))))) {
            $0.contacts.remove(id: UUID(1))
            $0.destination = nil
        }
    }
}
