import ComposableArchitecture
import Testing
import XCTest

@testable import TCA_Tutorial

// MARK: - Counter Feature Tests

// Tests for CounterReducer actions and state mutations
@MainActor
struct CounterReducerTests {
    // MARK: Basic increment/decrement functionality

    @Test
    func basics() async {
        // Setup: TestStore with initial state
        let store = TestStore(initialState: CounterReducer.State()) {
            CounterReducer()
        }

        // Test: Increment increases count by 1
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        // Test: Decrement decreases count by 1
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }

    // MARK: Timer functionality

    @Test
    func timer() async {
        // Setup: TestStore and test scheduler
        let store = TestStore(initialState: CounterReducer.State()) {
            CounterReducer()
        }

        let scheduler = DispatchQueue.test

        // Test: Toggle timer on
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }

        // Advance scheduler by 1 second to trigger timer tick
        // ✅ Test Suite 'Selected tests' passed.
        //        Executed 1 test, with 0 failures (0 unexpected) in 1.044 (1.046) seconds
        //    or:
        // ❌ Expected to receive an action, but received none after 0.1 seconds.
        await scheduler.advance(by: .seconds(1))

        // Verify: Timer tick received and count incremented
        await store.receive(\.timerTick) {
            $0.count = 1
        }

        // Test: Toggle timer off
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }

    // MARK: Number fact API call

    @Test
    func numberFact() async {
        // Setup: TestStore with mocked API dependency
        let store = TestStore(initialState: CounterReducer.State()) {
            CounterReducer()
        } withDependencies: {
            $0.todoClientAPI.fetch = { _ in .empty }
        }

        let scheduler = DispatchQueue.test

        // Test: Fact button tap triggers loading state
        await store.send(.factButtonTapped) {
            $0.isLoading = true
        }

        // Advance scheduler to simulate async response delay
        await scheduler.advance(by: .seconds(1))

        // Verify: Fact response received and loading state cleared
        await store.receive(\.factResponse) {
            $0.isLoading = false
            $0.fact = ""
        }
    }
}
