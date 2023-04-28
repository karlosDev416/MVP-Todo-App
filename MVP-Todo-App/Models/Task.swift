//
//  Task.swift
//  MVP-Todo-App
//
//  Created by KARLOS AGUIRRE on 4/27/23.
//

import Foundation

struct Task: Equatable {
    let id: UUID = UUID()
    let text: String
    var isFavorite: Bool
}
