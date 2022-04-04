//
//  Task.swift
//  Elevators_Degree
//
//  Created by Yura on 18.03.2022.
//

import Foundation

class Task: Hashable, CustomStringConvertible {

    var state: TaskStates = .free
    var from: Int
    let to: Int
    var direction: Directions {
        get {
            return from > to ? .down : .up
        }
    }
    
    init(from: Int, to: Int) {
        self.from = from
        self.to = to
    }
    
    var description: String {
        get {
            return "TAsk с \(from) на \(to). Status: \(state)"
        }
    }
    
    
    //MARK: Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(to)
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.from == rhs.from && lhs.to == rhs.to
    }
}
