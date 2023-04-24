//
//  UserViewModel.swift
//  SmartHome
//
//  Created by Stanislav on 22.04.2023.
//

import UIKit

final class UserViewModel {
    
    enum State: Equatable {
        case loading
        case loaded(UserModel)
        case error(String)
    }
    
    let title: String
    
    private let manager: UserProvider
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
    
    @Published var state: State = .loaded(
        UserModel(
            avatar: UIImage(systemName: "person.crop.circle"),
            name: "-", birthDate: "-", city: "-", address: "-"
        )
    )
    
    init(manager: UserProvider) {
        self.title = NSLocalizedString("user", tableName: "User", comment: "")
        self.manager = manager
    }
    
    func fetchUser() {
        guard state != .loading else { return }
        state = .loading
        
        Task.init {
            do {
                let response = try await manager.fetchUserPage()
                state = .loaded(UserMapper.mapToUserModel(dateFormatter: dateFormatter, user: response.user))
            } catch {
                let errorDescription = NSLocalizedString("general.error.description", tableName: "Device", comment: "")
                state = .error(errorDescription)
            }
        }
    }
}
