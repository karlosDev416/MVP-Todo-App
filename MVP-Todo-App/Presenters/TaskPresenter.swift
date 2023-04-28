//
//  TaskPresenter.swift
//  MVP-Todo-App
//
//  Created by KARLOS AGUIRRE on 4/27/23.
//

import Foundation

protocol UI: AnyObject {
    func update()
}

final class TaskPresenter {
    
    weak var delegate:UI?
    private var taskDatabase:TaskDatabaseType!
    
    init(taskDatabase: TaskDatabaseType = TaskDatabase()) {        
        self.taskDatabase = taskDatabase
    }
    
    func create(task:String) {
        guard !task.isEmpty else { return }
        taskDatabase.create(task: .init(text: task, isFavorite: false))
        delegate?.update()
    }
    
    func updateFavorite(taskId: UUID) {
        taskDatabase.updateFavorite(taskId: taskId)
        delegate?.update()
    }
    
    func removeTask(taskId:UUID) {
        taskDatabase.removeTask(taskId: taskId)
        delegate?.update()
    }
    
    @objc func removeAllTasks() {
        taskDatabase.removeAll()
        delegate?.update()
    }
    
    var tasks:[Task] {
        return taskDatabase.tasks
    }
}
