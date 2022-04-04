//
//  Elevator.swift
//  Elevators_Degree
//
//  Created by Yura on 18.03.2022.
//

import Foundation

class Elevator {
    var state: ElevatorStates = .stopped
    var curentFloor: Int
    var moveToTasks: [Task] = [] //TODO: Повторяющихся задач не должно быть
    var isAnimated: Bool = false
    
    
    init(curentFloor: Int) {
        self.curentFloor = curentFloor
    }
    
    func moveUp() {
        curentFloor += 1
        state = .moveUp
    }
    
    func moveDown() {
        curentFloor -= 1
        state = .moveDown
    }
    
    func stop() {
        state = .stopped
    }
}
