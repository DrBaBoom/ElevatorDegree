//
//  Enums.swift
//  Elevators_Degree
//
//  Created by Yura on 18.03.2022.
//

import Foundation

enum ElevatorStates {
    case moveDown
    case moveUp
    case stopped
}

enum TaskStates {
    case free
    case elevatorIsComing
    case delivering
}

enum Directions {
    case up
    case down
}
