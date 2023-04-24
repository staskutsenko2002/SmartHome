//
//  DeviceTableViewCell.swift
//  SmartHome
//
//  Created by Stanislav on 19.04.2023.
//

import UIKit

final class DeviceTableViewCell: UITableViewCell, Reusable {
        
    private let deviceImageView = UIImageView()
    private let titleLabel = UILabel()
    private let stateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(cellModel: DeviceCellModel) {
        titleLabel.text = cellModel.title
        stateLabel.text = cellModel.state.description
        deviceImageView.image = cellModel.state.image
    }
}

// MARK: - Private
private extension DeviceTableViewCell {
    func setupUI() {
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.numberOfLines = 0
        stateLabel.font = .systemFont(ofSize: 16)
    }
    
    func setupLayout() {
        [deviceImageView, titleLabel, stateLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            deviceImageView.heightAnchor.constraint(equalToConstant: 50),
            deviceImageView.widthAnchor.constraint(equalTo: deviceImageView.heightAnchor, multiplier: 1),
            deviceImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            deviceImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: deviceImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            stateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            stateLabel.leadingAnchor.constraint(equalTo: deviceImageView.trailingAnchor, constant: 8),
            stateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
