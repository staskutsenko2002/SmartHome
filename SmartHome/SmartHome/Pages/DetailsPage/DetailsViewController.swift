//
//  DetailsViewController.swift
//  SmartHome
//
//  Created by Stanislav on 23.04.2023.
//

import UIKit
import Combine

final class DetailsViewController: UIViewController {
    
    private let viewModel: DetailsViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    private let deviceImageView = UIImageView()
    private let deviceNameLabel = UILabel()
    private let statusLabel = UILabel()
    private let modeLabel = UILabel()
    private let modeSwitch = UISwitch()
    private let slider = UISlider()
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupObservation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.onCloseScreenAction.send(viewModel.deviceModel)
    }
}

// MARK: - Setup functions
private extension DetailsViewController {
    func setupUI() {
        view.backgroundColor = .white
        setupImageView()
        setupLabels()
        setupStates()
        setupControls()
    }
    
    func setupLayout() {
        [deviceImageView, deviceNameLabel, statusLabel, modeLabel, modeSwitch, slider].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            deviceImageView.heightAnchor.constraint(equalToConstant: 60),
            deviceImageView.widthAnchor.constraint(equalTo: deviceImageView.heightAnchor),
            deviceImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60),
            deviceImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            deviceNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            deviceNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deviceNameLabel.topAnchor.constraint(equalTo: deviceImageView.bottomAnchor, constant: 20),
            
            modeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            modeLabel.topAnchor.constraint(equalTo: deviceNameLabel.bottomAnchor, constant: 20),
            
            modeSwitch.leadingAnchor.constraint(equalTo: modeLabel.trailingAnchor, constant: 10),
            modeSwitch.centerYAnchor.constraint(equalTo: modeLabel.centerYAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: modeLabel.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            slider.topAnchor.constraint(equalTo: statusLabel.topAnchor),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            slider.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupImageView() {
        deviceImageView.image = viewModel.deviceModel.state.image
    }
    
    func setupControls() {
        slider.transform = slider.transform.rotated(by: -.pi/2)
        slider.addTarget(self, action: #selector(didSlide), for: .valueChanged)
        modeSwitch.addTarget(self, action: #selector(didSwitch), for: .valueChanged)
    }
    
    func setupLabels() {
        deviceNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        deviceNameLabel.text = viewModel.deviceModel.title
        statusLabel.font = .systemFont(ofSize: 20, weight: .bold)
        statusLabel.text = viewModel.deviceModel.state.description
        modeLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    func setupStates() {
        if let state = viewModel.deviceModel.state as? HeaterState {
            setValueToSlider(current: state.temperature, min: state.minTemp, max: state.maxTemp)
            modeLabel.isHidden = false
            modeSwitch.isHidden = false
            slider.isUserInteractionEnabled = state.isOn
            modeSwitch.isOn = state.isOn
        } else if let state = viewModel.deviceModel.state as? LightState {
            setValueToSlider(current: state.intensity, min: state.minIntensity, max: state.maxIntensity)
            modeLabel.isHidden = false
            modeSwitch.isHidden = false
            slider.isUserInteractionEnabled = state.isOn
            modeSwitch.isOn = state.isOn
        } else if let state = viewModel.deviceModel.state as? RollerState {
            setValueToSlider(current: state.position, min: state.minPosition, max: state.maxPosition)
            modeLabel.isHidden = true
            modeSwitch.isHidden = true
        }
    }
    
    func setValueToSlider(current: Float, min: Float, max: Float) {
        slider.maximumValue = max
        slider.minimumValue = min
        slider.value = current
    }
    
    func setupObservation() {
        viewModel.$deviceModel.sink { [weak self] model in
            guard let self else { return }
            self.statusLabel.text = self.viewModel.deviceModel.state.description
            self.deviceImageView.image = self.viewModel.deviceModel.state.image
        }.store(in: &cancellables)
    }
}

// MARK: - Selectors
@objc private extension DetailsViewController {
    func didSlide() {
        viewModel.updateSlider(value: slider.value)
    }
    
    func didSwitch() {
        viewModel.updateSwitch(isOn: modeSwitch.isOn)
        self.statusLabel.text = self.viewModel.deviceModel.state.description
        self.deviceImageView.image = self.viewModel.deviceModel.state.image
        self.slider.isUserInteractionEnabled = self.modeSwitch.isOn
    }
}
