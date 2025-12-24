import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct ContactReducer {
    // MARK: Nested Types

    @ObservableState
    struct State {
        @Presents var destination: Destination.State?

        var contacts: IdentifiedArrayOf<ContactDTO> = []
    }

    enum Action {
        case addButtonTapped
        case deleteButtonTapped(id: ContactDTO.ID)
        case destination(PresentationAction<Destination.Action>)

        // MARK: Nested Types

        enum Alert: Equatable {
            case confirmDeletion(id: ContactDTO.ID)
        }
    }

    // MARK: Computed Properties

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addContact(
                    AddContactReducer.State(
                        contact: ContactDTO(id: UUID(), name: "")
                    )
                )
                return .none

            case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                return .none

            case let .deleteButtonTapped(id: id):
                state.destination = .alert(
                    AlertState {
                        TextState("Are you sure?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                            TextState("Delete")
                        }
                    }
                )
                return .none

            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                state.contacts.remove(id: id)
                return .none

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension ContactReducer {
    @Reducer
    enum Destination {
        case addContact(AddContactReducer)
        case alert(AlertState<ContactReducer.Action.Alert>)
    }
}
