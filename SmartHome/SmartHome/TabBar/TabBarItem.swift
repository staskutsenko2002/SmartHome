//
//  TabBarItem.swift
//  SmartHome
//
//  Created by Stanislav on 19.04.2023.
//

import UIKit

struct TabBarItem {
    enum Page {
        case devices
        case user
        
        var image: UIImage? {
            switch self {
            case .devices: return UIImage(systemName: "list.bullet")
            case .user: return UIImage(systemName: "person.crop.circle")
            }
        }
    }
    
    let controller: UIViewController
    let page: Page
}
