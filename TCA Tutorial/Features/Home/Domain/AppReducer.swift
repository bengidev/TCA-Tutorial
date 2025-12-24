import ComposableArchitecture

@Reducer
struct AppReducer {
    // MARK: Nested Types

    @ObservableState
    struct State: Equatable {
        var tab1 = CounterReducer.State()
        var tab2 = CounterReducer.State()
    }

    enum Action {
        case tab1(CounterReducer.Action)
        case tab2(CounterReducer.Action)
    }

    // MARK: Computed Properties

    var body: some ReducerOf<Self> {
        Scope(state: \.tab1, action: \.tab1) {
            CounterReducer()
        }

        Scope(state: \.tab2, action: \.tab2) {
            CounterReducer()
        }

        Reduce { _, _ in
            // Core logic of the app feature
            .none
        }
    }
}
