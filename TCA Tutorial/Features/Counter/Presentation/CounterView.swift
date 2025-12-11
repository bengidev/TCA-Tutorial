//
//  CounterView.swift
//  TCA Tutorial
//
//  Created by ENB Mac Mini on 09/12/25.
//

import ComposableArchitecture
import SwiftUI

// MARK: - CounterView

/// A SwiftUI view that displays a counter with increment and decrement controls.
///
/// This view is built using The Composable Architecture (TCA) pattern,
/// where all state changes are managed through the `CounterReducer`.
///
/// ## Usage
/// ```swift
/// CounterView(
///     store: Store(initialState: CounterReducer.State()) {
///         CounterReducer()
///     }
/// )
/// ```
struct CounterView: View {
  // MARK: - Properties

  /// The store that holds the state and handles actions for the counter feature.
  ///
  /// This store is of type `StoreOf<CounterReducer>`, which manages:
  /// - `State`: Contains the current count value
  /// - `Action`: Handles increment and decrement button taps
  let store: StoreOf<CounterReducer>

  // MARK: - Body

  /// The main content view displaying the counter value and control buttons.
  var body: some View {
    WithPerceptionTracking {
      VStack {
        // Counter display label
        Text("\(store.count)")
          .font(.largeTitle)
          .padding()
          .background(Color.black.opacity(0.1))
          .cornerRadius(10)

        // Increment and decrement button controls
        HStack {
          // Decrement button - sends decrementButtonTapped action to the store
          Button("-") {
            store.send(.decrementButtonTapped)
          }
          .font(.largeTitle)
          .padding()
          .background(Color.black.opacity(0.1))
          .cornerRadius(10)

          // Increment button - sends incrementButtonTapped action to the store
          Button("+") {
            store.send(.incrementButtonTapped)
          }
          .font(.largeTitle)
          .padding()
          .background(Color.black.opacity(0.1))
          .cornerRadius(10)
        }

        Button(store.isTimerRunning ? "Stop Timer New" : "Start Timer") {
          store.send(.toggleTimerButtonTapped)
        }
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)

        Button("Fact") {
          store.send(.factButtonTapped)
        }
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)

        if store.isLoading {
          ProgressView()
        } else if let fact = store.fact {
          Text(fact)
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .padding()
        }
      }
    }
  }
}

// MARK: - Preview

/// SwiftUI Preview for CounterView with a default initial state.
#Preview {
  CounterView(
    store: Store(initialState: CounterReducer.State()) {
      CounterReducer()
    }
  )
}
