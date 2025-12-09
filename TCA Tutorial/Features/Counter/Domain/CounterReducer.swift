//
//  CounterReducer.swift
//  TCA Tutorial
//
//  Created by ENB Mac Mini on 09/12/25.
//

import ComposableArchitecture

@Reducer
struct CounterReducer: Reducer {
    @ObservableState
    struct State: Equatable {
        var count = 0
    }

    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            return .none

        case .incrementButtonTapped:
            state.count += 1
            return .none
        }
    }
}
