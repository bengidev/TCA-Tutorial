//
//  Todo.swift
//  TCA Tutorial
//
//  Created on 2025-12-11.
//

import Foundation

/// Represents a To-Do item from the API
struct Todo: Codable, Identifiable, Equatable {
  /// The ID of the user who owns this todo
  let userId: Int

  /// Unique identifier for the todo
  let id: Int

  /// The title/description of the todo
  let title: String

  /// Whether the todo has been completed
  let completed: Bool
}

// MARK: - Encoding & Decoding Helpers

extension Todo {
  /// Decode a single Todo from JSON data
  /// - Parameter data: JSON data to decode
  /// - Returns: Decoded Todo object, or empty Todo if decoding fails
  static func decode(from data: Data) -> Todo {
    let decoder = JSONDecoder()
    do {
      return try decoder.decode(Todo.self, from: data)
    } catch {
      return Todo.empty
    }
  }

  /// Decode an array of Todos from JSON data
  /// - Parameter data: JSON data to decode
  /// - Returns: Array of decoded Todo objects, or empty array if decoding fails
  static func decodeArray(from data: Data) -> [Todo] {
    let decoder = JSONDecoder()
    do {
      return try decoder.decode([Todo].self, from: data)
    } catch {
      return []
    }
  }

  /// Encode this Todo to JSON data
  /// - Returns: JSON data representation of this Todo, or empty Data if encoding fails
  func encode() -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do {
      return try encoder.encode(self)
    } catch {
      return Data()
    }
  }

  /// Encode an array of Todos to JSON data
  /// - Parameter todos: Array of Todo objects to encode
  /// - Returns: JSON data representation of the todos, or empty Data if encoding fails
  static func encodeArray(_ todos: [Todo]) -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do {
      return try encoder.encode(todos)
    } catch {
      return Data()
    }
  }
}

// MARK: - Sample Data

extension Todo {
  /// Empty/default todo example
  static let empty = Todo(
    userId: 0,
    id: 0,
    title: "",
    completed: false
  )

  /// Sample data examples for testing and previews
  static let examples: [Todo] = [
    Todo(
      userId: 1,
      id: 1,
      title: "Complete iOS TCA Tutorial",
      completed: false
    ),
    Todo(
      userId: 1,
      id: 2,
      title: "Build Todo List Feature",
      completed: true
    ),
    Todo(
      userId: 2,
      id: 3,
      title: "Review SwiftUI Components",
      completed: false
    ),
    Todo(
      userId: 2,
      id: 4,
      title: "Implement Network Layer",
      completed: true
    ),
    Todo(
      userId: 3,
      id: 5,
      title: "Add Unit Tests for Reducers",
      completed: false
    ),
  ]

  /// First example for quick access
  static let example1 = examples[0]

  /// Second example for quick access
  static let example2 = examples[1]

  /// Third example for quick access
  static let example3 = examples[2]

  /// Fourth example for quick access
  static let example4 = examples[3]

  /// Fifth example for quick access
  static let example5 = examples[4]
}
