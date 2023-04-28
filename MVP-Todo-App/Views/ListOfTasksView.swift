//
//  ViewController.swift
//  MVP-Todo-App
//
//  Created by KARLOS AGUIRRE on 4/27/23.
//

import UIKit

class ListOfTasksView: UIViewController {
    
    var presenter = TaskPresenter()
    
    private let taskTextView:UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        textView.backgroundColor = .systemGray6
        textView.textColor = .label
        textView.layer.cornerRadius = 12
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.layer.borderWidth = 1
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var createTaskButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapOnCreateTask), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var taskCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 340, height: 80)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: "taskCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        taskCollectionView.dataSource = self
        presenter.delegate = self
    }
    
    private func setupUI() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove All", style: .done, target: presenter, action: #selector(presenter.removeAllTasks))
        [taskTextView, createTaskButton, taskCollectionView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            taskTextView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            taskTextView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            taskTextView.trailingAnchor.constraint(equalTo: createTaskButton.leadingAnchor, constant: -20),
            taskTextView.heightAnchor.constraint(equalToConstant: 60),
            
            createTaskButton.centerYAnchor.constraint(equalTo: taskTextView.centerYAnchor),
            createTaskButton.heightAnchor.constraint(equalToConstant: 40),
            createTaskButton.widthAnchor.constraint(equalToConstant: 40),
            createTaskButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            taskCollectionView.topAnchor.constraint(equalTo: taskTextView.bottomAnchor, constant: 20),
            taskCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func didTapOnCreateTask() {
        presenter.create(task: taskTextView.text)
    }
}

extension ListOfTasksView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taskCollectionViewCell", for: indexPath) as? TaskCollectionViewCell else { return UICollectionViewCell() }
        let task = presenter.tasks[indexPath.row]
        cell.configure(id: task.id, text: task.text, isFavorite: task.isFavorite)
        cell.onFavoriteDidPress = { [weak self] taskId in
            self?.presenter.updateFavorite(taskId: taskId)
        }
        cell.onRemoteDidPress = { [weak self] taskId in
            self?.presenter.removeTask(taskId: taskId)
        }
        
        return cell
    }
}

extension ListOfTasksView: UI {
    func update() {
        taskTextView.text = ""
        taskCollectionView.reloadData()
    }
    
}
