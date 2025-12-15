//
//  CounterReducer.swift
//  TCA Tutorial
//
//  Created by ENB Mac Mini on 09/12/25.
//

import ComposableArchitecture
import UIKit

@Reducer struct CounterReducer {
    @Dependency(\.todoClientAPI) var todoClientAPI

    @ObservableState
    struct State: Equatable {
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

    enum CancelID {
        case timer
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            // Core logic of the app feature
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
                        let todo = try await self.todoClientAPI.fetch(count)
                        await send(.factResponse(todo.title))
                    } catch {
                        await send(.factResponse(TodoDTO.empty.title))
                    }
                }

            case .factResponse(let fact):
                state.fact = fact
                state.isLoading = false
                return .none
            }
        }
    }
}
