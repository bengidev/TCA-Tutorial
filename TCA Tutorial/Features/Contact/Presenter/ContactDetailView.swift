//
//  ContactDetailView.swift
//  TCA Tutorial
//
//  Created by ENB Mac Mini on 26/12/25.
//

import ComposableArchitecture
import SwiftUI

struct ContactDetailView: View {
  @Perception.Bindable var store: StoreOf<ContactDetailReducer>

  var body: some View {
    WithPerceptionTracking {
      Form {
        Button("Delete") {
          store.send(.deleteButtonTapped)
        }
      }
      .navigationBarTitle(Text(store.contact.name))
      .alert($store.scope(state: \.alert, action: \.alert))
    }
  }
}

#Preview {
  NavigationView {
    ContactDetailView(
      store: Store(
        initialState: ContactDetailReducer.State(
          contact: ContactDTO(id: UUID(), name: "Blob")
        )
      ) {
        ContactDetailReducer()
      }
    )
  }
  .navigationViewStyle(.stack)
}
