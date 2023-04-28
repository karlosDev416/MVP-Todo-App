//
//  TaskCollectionViewCell.swift
//  MVP-Todo-App
//
//  Created by KARLOS AGUIRRE on 4/27/23.
//

import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    
    var taskId:UUID? = nil
    var onFavoriteDidPress:((UUID)->())?
    var onRemoteDidPress:((UUID)->())?
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines  = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let starImage = UIImage(systemName: "start", withConfiguration: config)
        
        button.setImage(starImage, for: .normal)
        button.addTarget(self, action: #selector(didTapOnFavorite), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()
    
    private lazy var trashButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let trashImage = UIImage(systemName: "trash", withConfiguration: config)
        
        button.setImage(trashImage, for: .normal)
        button.addTarget(self, action: #selector(didTapOnRemove), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starButton, trashButton])
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mainStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLbl, buttonsStack])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .white
        contentView.addSubview(mainStack)
        
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    func configure(id: UUID, text: String, isFavorite:Bool) {
        self.taskId = id
        self.titleLbl.text = text
        let buttonImage = UIImage(systemName: isFavorite ? "star.fill" : "star")
        starButton.setImage(buttonImage, for: .normal)
    }
    
    @objc func didTapOnFavorite() {
        guard let id = self.taskId else { return }
        onFavoriteDidPress?(id)
    }
    
    @objc func didTapOnRemove() {
        guard let id = self.taskId else { return }
        onRemoteDidPress?(id)
    }
    
}
