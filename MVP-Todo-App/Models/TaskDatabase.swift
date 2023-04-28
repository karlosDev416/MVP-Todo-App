//
//  TaskDatabase.swift
//  MVP-Todo-App
//
//  Created by KARLOS AGUIRRE on 4/27/23.
//

import Foundation

protocol TaskDatabaseType {
    var tasks:[Task]! { get set }
    func create(task:Task)
    func updateFavorite(taskId: UUID)
    func removeTask(taskId: UUID)
    func removeAll()
}

final class TaskDatabase: TaskDatabaseType {    
    
    var tasks:[Task]!
    
    init(tasks: [Task] = []) {
        self.tasks = tasks
    }
    
    func create(task:Task) {
        tasks.append(task)
    }
    
    func updateFavorite(taskId: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks[index].isFavorite = !tasks[index].isFavorite
        }
    }
    
    func removeTask(taskId: UUID) {
        tasks.removeAll(where: { $0.id == taskId })
    }
    
    func removeAll() {
        tasks.removeAll()        
    }
}
