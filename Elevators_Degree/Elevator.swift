//
//  Elevator.swift
//  Elevators_Degree
//
//  Created by Yura on 18.03.2022.
//

import Foundation

class Elevator {
    var state: ElevatorStates = .stopped
    var currentFloor: Int
    var moveToTasks: [Task] = [] //TODO: Повторяющихся задач не должно быть
    var isAnimated: Bool = false
    var closestTaskFloor: Int? {
        get {
            var result: Int? = nil
            if self.state == .moveDown {
                for t in moveToTasks {
                    if t.state == .delivering {
                        if t.to <= currentFloor && (result == nil || result! < t.to) {
                            result = t.to
                        }
                    } else if t.state == .elevatorIsComing {
                        if t.from <= currentFloor && (result == nil || result! < t.from) {
                            result = t.from
                        }
                    }
                }
            } else if self.state == .moveUp {
                for t in moveToTasks {
                    if t.state == .delivering {
                        if t.to >= currentFloor && (result == nil || result! > t.to) {
                            result = t.to
                        }
                    } else if t.state == .elevatorIsComing {
                        if t.from >= currentFloor && (result == nil || result! > t.from) {
                            result = t.from
                        }
                    }
                }
            }
            return result
        }
    }
    
    
    init(currentFloor: Int) {
        self.currentFloor = currentFloor
    }
    
    func moveUp() {
        currentFloor += 1
        state = .moveUp
    }
    
    func moveDown() {
        currentFloor -= 1
        state = .moveDown
    }
    
    func stop() {
        state = .stopped
    }
    
    func getTasks(of floor: Int) -> [Task] {
//        var res: [Task] = []
//        for t in moveToTasks {
//            if t.to == floor || t.from == floor {
//                res.append(t)
//            }
//        }
//        return res
        return moveToTasks.filter({ t in t.to == floor || t.from == floor })
    }
    
    func removeDelivered(to floor: Int) {
        moveToTasks = moveToTasks.filter({ t in t.to != floor })
    }
    
    func doSomething() -> Bool {
        if let cTf = closestTaskFloor, cTf == currentFloor {
            removeDelivered(to: currentFloor)
            for t in moveToTasks {
                if t.state == .elevatorIsComing && t.from == currentFloor {
                    t.state = .delivering
                }
            }
            return true
        }
        return false
    }
    
}
