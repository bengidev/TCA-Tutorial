import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct ContactReducer {
  // MARK: Nested Types

  @Dependency(\.uuid) var uuid

  @ObservableState
  struct State: Equatable {
    @Presents var destination: Destination.State?

    var contacts: IdentifiedArrayOf<ContactDTO> = []
    var path = StackState<ContactDetailReducer.State>()
  }

  enum Action {
    case addButtonTapped
    case contactRowTapped(ContactDTO)
    case deleteButtonTapped(id: ContactDTO.ID)
    case destination(PresentationAction<Destination.Action>)
    case path(StackAction<ContactDetailReducer.State, ContactDetailReducer.Action>)

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
            contact: ContactDTO(id: self.uuid(), name: "")
          )
        )
        return .none

      case .destination(.presented(.addContact(.delegate(.saveContact(let contact))))):
        state.contacts.append(contact)
        return .none

      case .deleteButtonTapped(let id):
        state.destination = .alert(.deleteConfirmation(id: id))
        return .none

      case .destination(.presented(.alert(.confirmDeletion(id: let id)))):
        state.contacts.remove(id: id)
        return .none

      case .destination(.presented(.contactDetail(.delegate(.confirmDeletion)))):
        guard case .contactDetail(let detailState) = state.destination else { return .none }
        state.contacts.remove(id: detailState.contact.id)
        return .none

      case .contactRowTapped(let contact):
        state.destination = .contactDetail(
          ContactDetailReducer.State(contact: contact)
        )
        return .none

      case .destination:
        return .none

      case .path(.element(id: let id, action: .delegate(.confirmDeletion))):
        guard let detailState = state.path[id: id]
        else { return .none }
        state.contacts.remove(id: detailState.contact.id)
        return .none

      case .path:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
    .forEach(\.path, action: \.path) {
      ContactDetailReducer()
    }
  }
}

extension ContactReducer {
  @Reducer
  enum Destination {
    case addContact(AddContactReducer)
    case alert(AlertState<ContactReducer.Action.Alert>)
    case contactDetail(ContactDetailReducer)
  }
}

extension ContactReducer.Destination.State: Equatable {}

extension AlertState where Action == ContactReducer.Action.Alert {
  static func deleteConfirmation(id: UUID) -> Self {
    Self {
      TextState("Are you sure?")
    } actions: {
      ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
        TextState("Delete")
      }
    }
  }
}
