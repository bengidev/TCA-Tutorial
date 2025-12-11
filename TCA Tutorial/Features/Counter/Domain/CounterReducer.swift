//
//  CounterReducer.swift
//  TCA Tutorial
//
//  Created by ENB Mac Mini on 09/12/25.
//

import ComposableArchitecture
import Foundation
import UIKit

@Reducer
struct CounterReducer {
    @ObservableState
    struct State {
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }

    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case toggleTimerButtonTapped
        case timerTick
        case factButtonTapped
        case factResponse(String)
    }

    nonisolated enum CancelID {
        case timer
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            state.fact = nil
            return .none

        case .incrementButtonTapped:
            state.count += 1
            state.fact = nil
            return .none

        case .toggleTimerButtonTapped:
            state.isTimerRunning.toggle()
            if state.isTimerRunning {
                return .run { send in
                    while true {
                        try await _Concurrency.Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                        await send(.timerTick)
                    }
                }
                .cancellable(id: CancelID.timer)
            } else {
                return .cancel(id: CancelID.timer)
            }

        case .timerTick:
            state.count += 1
            state.fact = nil
            return .none

        case .factButtonTapped:
            state.fact = nil
            state.isLoading = true

            return .run { [count = state.count] send in
                do {
                    let (data, _) = try await URLSession.shared
                        .data(from: URL(string: "https://jsonplaceholder.typicode.com/todos/\(count)")!)
                    let fact = await Todo.decode(from: data)

                    await send(.factResponse(fact.title))
                } catch {
                    await send(.factResponse(Todo.empty.title))
                }
            }

        case .factResponse(let fact):
            state.fact = fact
            state.isLoading = false
            return .none
        }
    }
}
