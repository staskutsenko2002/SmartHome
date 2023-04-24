//
//  PageStateView.swift
//  SmartHome
//
//  Created by Stanislav on 22.04.2023.
//

import UIKit

final class PageStateView: UIView {
    
    var state: State? {
        didSet {
            configure()
        }
    }
    
    private let titleLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - Private
private extension PageStateView {
    func setupUI() {
        [titleLabel, actionButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 32),
            
            actionButton.heightAnchor.constraint(equalToConstant: 32),
            actionButton.widthAnchor.constraint(equalToConstant: 80),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40)
        ])
        
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16)
        actionButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    func configure() {
        guard let state = state else { return erase() }
        titleLabel.text = state.title
        actionButton.setTitle(state.action?.title, for: .normal)
    }
    
    func erase() {
        titleLabel.text = nil
    }
    
    @objc
    func onAction() {
        state?.action?.onAction()
    }
}

// MARK: - State Object
extension PageStateView {
    struct State {
        let title: String
        let action: Action?
    }
    
    struct Action {
        let title: String
        let onAction: (() -> Void)
    }
}
