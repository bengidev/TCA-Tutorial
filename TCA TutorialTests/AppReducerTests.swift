//
//  AppReducerTests.swift
//  TCA Tutorial
//
//  Created by ENB Mac Mini on 15/12/25.
//

import ComposableArchitecture
import Testing

@testable import TCA_Tutorial

@MainActor
struct AppReducreTests {
    @Test
    func incrementInFirstTab() async {
        let store = TestStore(initialState: AppReducer.State()) {
            AppReducer()
        }

        await store.send(\.tab1.incrementButtonTapped) {
            $0.tab1.count = 1
        }
    }
}
