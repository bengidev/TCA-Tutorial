import ComposableArchitecture
import Foundation

@Reducer
struct AddContactReducer {
    // MARK: Nested Types

    @ObservableState
    struct State: Equatable {
        var contact: ContactDTO
    }

    enum Action: Equatable {
        case cancelButtonTapped
        case saveButtonTapped
        case delegate(Delegate)
        case setName(String)

        // MARK: Nested Types
        @CasePathable
        enum Delegate: Equatable {
            case saveContact(ContactDTO)
        }
    }

    // MARK: Properties

    @Dependency(\.dismiss) var dismiss

    // MARK: Computed Properties

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case .cancelButtonTapped:
                return .run(operation: { _ in await self.dismiss() })

            case .saveButtonTapped:
                return .run(operation: { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await self.dismiss()
                })

            case let .setName(name):
                state.contact.name = name
                return .none
            }
        }
    }
}
