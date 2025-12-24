//
//  TodoClientAPI.swift
//  TCA Tutorial
//
//  Created by ENB Mac Mini on 12/12/25.
//

import ComposableArchitecture
import Foundation

// MARK: - TodoClientAPI

struct TodoClientAPI {
    var fetch: (Int) async throws -> TodoDTO
}

// MARK: DependencyKey

extension TodoClientAPI: DependencyKey {
    static let liveValue = Self(
        fetch: { number in
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "https://jsonplaceholder.typicode.com/todos/\(number)")!)
            return TodoDTO.decode(from: data)
        }
    )
}

extension DependencyValues {
    var todoClientAPI: TodoClientAPI {
        get { self[TodoClientAPI.self] }
        set { self[TodoClientAPI.self] = newValue }
    }
}
