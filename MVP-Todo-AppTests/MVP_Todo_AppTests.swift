//
//  MVP_Todo_AppTests.swift
//  MVP-Todo-AppTests
//
//  Created by KARLOS AGUIRRE on 4/27/23.
//

import XCTest
@testable import MVP_Todo_App


final class MVP_Todo_AppTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: TaskPresenter!
    var taskDatabaseMock: TaskDatabaseMock!
    var delegateMock: DelegateMock!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        taskDatabaseMock = TaskDatabaseMock()
        delegateMock = DelegateMock()
        sut = TaskPresenter(taskDatabase: taskDatabaseMock)
        sut.delegate = delegateMock
    }
    
    override func tearDown() {
        sut = nil
        taskDatabaseMock = nil
        delegateMock = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testCreateTask() {
        //given
        let taskText = "Test task"
        //when
        sut.create(task: taskText)
        //then
        XCTAssertEqual(sut.tasks.count, 1)
        XCTAssertEqual(sut.tasks.first?.text, taskText)
        XCTAssertTrue(taskDatabaseMock.createTaskCalled)
        XCTAssertTrue(delegateMock.updateCalled)
    }
    
    func testCreateTaskEmptyString() {
        //when
        sut.create(task: "")
        //then
        XCTAssertTrue(sut.tasks.isEmpty)
        XCTAssertFalse(taskDatabaseMock.createTaskCalled)
        XCTAssertFalse(delegateMock.updateCalled)
    }
    
    func testUpdateFavorite() {
        //given
        sut.create(task: "Test")
        guard let task = sut.tasks.first else { return XCTFail() }
        //when
        sut.updateFavorite(taskId: task.id)
        //then
        guard let updatedTask = sut.tasks.first else { return XCTFail() }
        XCTAssertEqual(sut.tasks.count, 1)
        XCTAssertTrue(updatedTask.isFavorite)
        XCTAssertTrue(taskDatabaseMock.updateFavoriteCalled)
        XCTAssertTrue(delegateMock.updateCalled)
    }
    
    func testRemoveTask() {
        //given
        sut.create(task: "Task 1")
        guard let task = sut.tasks.first else { return XCTFail() }
        //when
        sut.removeTask(taskId: task.id)
        //then
        XCTAssertTrue(sut.tasks.isEmpty)
        XCTAssertTrue(taskDatabaseMock.removeTaskCalled)
        XCTAssertTrue(delegateMock.updateCalled)
    }
    
    func testRemoveAllTasks() {
        //given
        sut.create(task: "Task 1")
        sut.create(task: "Task 2")
        //when
        sut.removeAllTasks()
        //then
        XCTAssertTrue(sut.tasks.isEmpty)
        XCTAssertTrue(taskDatabaseMock.removeAllTasksCalled)
        XCTAssertTrue(delegateMock.updateCalled)
    }
    
    func testTasks() {
        //given
        let task1 = Task(text: "Task 1", isFavorite: false)
        let task2 = Task(text: "Task 2", isFavorite: true)
        //when
        taskDatabaseMock.tasks = [task1, task2]
        //then
        XCTAssertEqual(sut.tasks, [task1, task2])
    }
}

// MARK: - Mocks

class TaskDatabaseMock: TaskDatabaseType {
    
    var tasks: [MVP_Todo_App.Task]! = []
    var createTaskCalled = false
    var updateFavoriteCalled = false
    var removeTaskCalled = false
    var removeAllTasksCalled = false
    
    func create(task: Task) {
        tasks.append(task)
        createTaskCalled = true
    }
    
    func updateFavorite(taskId: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks[index].isFavorite = !tasks[index].isFavorite
        }
        updateFavoriteCalled = true
    }
    
    func removeTask(taskId: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks.remove(at: index)
        }
        removeTaskCalled = true
    }
    
    func removeAll() {
        tasks.removeAll()
        removeAllTasksCalled = true
    }
}

class DelegateMock: UI {
    
    var updateCalled = false
    
    func update() {
        updateCalled = true
    }
}
