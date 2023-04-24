//
//  DeviceCellModel.swift
//  SmartHome
//
//  Created by Stanislav on 20.04.2023.
//

import UIKit

struct DeviceCellModel: Equatable {
    var id: Int
    var title: String
    var state: StateProtocol
    
    static func == (lhs: DeviceCellModel, rhs: DeviceCellModel) -> Bool {
        lhs.title == rhs.title && lhs.state.description == rhs.state.description
    }
}
