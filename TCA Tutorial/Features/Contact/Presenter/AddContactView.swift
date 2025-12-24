import ComposableArchitecture
import SwiftUI

struct AddContactView: View {
    let store: StoreOf<AddContactReducer>

    @State private var name: String = ""

    var body: some View {
        Form {
            TextField("Name", text: self.$name)
                .onAppear {
                    self.name = self.store.contact.name
                }
                .onChange(of: self.name) { newValue in
                    self.store.send(.setName(newValue))
                }
            Button("Save") {
                self.store.send(.saveButtonTapped)
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Cancel") {
                    self.store.send(.cancelButtonTapped)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        AddContactView(
            store: Store(
                initialState: AddContactReducer.State(
                    contact: ContactDTO(
                        id: UUID(),
                        name: "Blob"
                    )
                )
            ) {
                AddContactReducer()
            }
        )
    }
}
