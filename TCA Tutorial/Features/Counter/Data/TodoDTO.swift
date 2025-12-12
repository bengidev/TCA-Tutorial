//
//  TodoDTO.swift
//  TCA Tutorial
//
//  Created on 2025-12-11.
//

import Foundation

/// Represents a To-Do item from the API
struct TodoDTO: Codable, Identifiable, Equatable {
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

extension TodoDTO {
  /// Decode a single TodoDTO from JSON data
  /// - Parameter data: JSON data to decode
  /// - Returns: Decoded TodoDTO object, or empty TodoDTO if decoding fails
  static func decode(from data: Data) -> TodoDTO {
    let decoder = JSONDecoder()
    do {
      return try decoder.decode(TodoDTO.self, from: data)
    } catch {
      return TodoDTO.empty
    }
  }

  /// Decode an array of Todos from JSON data
  /// - Parameter data: JSON data to decode
  /// - Returns: Array of decoded TodoDTO objects, or empty array if decoding fails
  static func decodeArray(from data: Data) -> [TodoDTO] {
    let decoder = JSONDecoder()
    do {
      return try decoder.decode([TodoDTO].self, from: data)
    } catch {
      return []
    }
  }

  /// Encode this TodoDTO to JSON data
  /// - Returns: JSON data representation of this TodoDTO, or empty Data if encoding fails
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
  /// - Parameter todos: Array of TodoDTO objects to encode
  /// - Returns: JSON data representation of the todos, or empty Data if encoding fails
  static func encodeArray(_ todos: [TodoDTO]) -> Data {
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

extension TodoDTO {
  /// Empty/default todo example
  static let empty = TodoDTO(
    userId: 0,
    id: 0,
    title: "",
    completed: false
  )

  /// Sample data examples for testing and previews
  static let examples: [TodoDTO] = [
    TodoDTO(
      userId: 1,
      id: 1,
      title: "Complete iOS TCA Tutorial",
      completed: false
    ),
    TodoDTO(
      userId: 1,
      id: 2,
      title: "Build TodoDTO List Feature",
      completed: true
    ),
    TodoDTO(
      userId: 2,
      id: 3,
      title: "Review SwiftUI Components",
      completed: false
    ),
    TodoDTO(
      userId: 2,
      id: 4,
      title: "Implement Network Layer",
      completed: true
    ),
    TodoDTO(
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
