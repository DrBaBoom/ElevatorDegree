//
//  Button.swift
//  Elevators_Degree
//
//  Created by Yura on 18.03.2022.
//

import Foundation

class Button {
    var pointsToMove: [Int] = []
    
    func addNewPoint(p: Int) {
        if !pointsToMove.contains(p) {
            pointsToMove.append(p)
        }
    }
}
