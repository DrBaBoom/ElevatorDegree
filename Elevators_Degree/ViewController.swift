//
//  ViewController.swift
//  Elevators_Degree
//
//  Created by Yura on 11.03.2022.
//

import UIKit

class ViewController: UIViewController, KeyboardConnection {
    
    let numberOfFloors: Int = 20
    var tasks: [Task] = []
    var floorViews: [FloorView] = []
    let elevators = [Elevator(currentFloor: 20), Elevator(currentFloor: 20)]
    var delays: [TimeInterval] = [0, 0]
    var currentChose: Int = 0
    var elevatorLabels: [UILabel] = []
    
    @IBOutlet weak var constrElevator1Height: NSLayoutConstraint!
    @IBOutlet weak var lblElevator1: UILabel!
    @IBOutlet weak var lblElevator2: UILabel!
    @IBOutlet weak var stackFloors: UIStackView!
//    @IBOutlet weak var btnFirstFloor: UIButton!
    
    @IBOutlet var viewElevatorsCollection: [UIView]!
//    @IBOutlet var btnCollection: [UIButton]!
    
    @IBAction func btnPushed(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Keyboard_VC"),
                let vvc = vc as? Keyboard_VC {
            vvc.floorCount = numberOfFloors
            vvc.floor = sender.tag
            vvc.zaheila = self
            show(vvc, sender: nil)
            
        }
}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        elevatorLabels = [lblElevator1, lblElevator2]
        
//        let btnColor = btnFirstFloor.titleColor(for: .normal)
//        for f in 2...numberOfFloors {
//            let btn = UIButton()
//            btn.setTitle("\(f)", for: .normal)
//            btn.tag = f
//            btn.setTitleColor(btnColor, for: .normal)
//            btn.addTarget(self, action: #selector(btnPushed(_:)), for: .touchUpInside)
//            stackFloors.insertArrangedSubview(btn, at: 0)
//            btnCollection.append(btn)
//        }
        
        for i in 1...numberOfFloors {
            let view = FloorView()
            view.setFloor(n: i)
            view.setAction(a: (btnPushed(_:)))
            view.text = "20, 18"
            stackFloors.insertArrangedSubview(view, at: 0)
            floorViews.append(view)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        constrElevator1Height.constant = abs(stackFloors.subviews[1].frame.origin.y - stackFloors.subviews[0].frame.origin.y)
        setLabels()
    }
    
    func updateStatus() {
        for elevator in elevators {
    //        let tasks = getAllTasks()
            if elevator.state == .stopped {
                if elevator.moveToTasks.isEmpty {
                    var closestTask: Task? = nil
                    var k = 0
                    for (i ,task) in tasks.enumerated() {
                        if task.state == .free {
                            if let cclosestTask = closestTask {
                                if abs(elevator.currentFloor - cclosestTask.from) > abs(elevator.currentFloor - task.from) {
                                    closestTask = task
                                    k = i
                                }
                            } else {
                                closestTask = task
                                k = i
                            }
                        }
                    }
                    if let cclosestTask = closestTask {
                        elevator.state = (cclosestTask.from > elevator.currentFloor) ? .moveUp : .moveDown
                        cclosestTask.state = .elevatorIsComing
                        elevator.moveToTasks.append(cclosestTask)
                        tasks.remove(at: k)
                    }
                } else {
                    
                    if elevator.moveToTasks[0].state == .delivering {
                        elevator.state = (elevator.moveToTasks[0].to > elevator.currentFloor) ? .moveUp : .moveDown
                    } else if elevator.moveToTasks[0].state == .elevatorIsComing {
                        elevator.state = (elevator.moveToTasks[0].from > elevator.currentFloor) ? .moveUp : .moveDown
                    }
                }
                
            } else if elevator.state == .moveDown {
                let liftEdetSEtaja = elevator.currentFloor
    //            let liftEdetNaEtaj = elevator.closestTaskFloor!
    //            let elevatorTask = elevator.moveToTasks.first!
                for task in tasks {
                    if task.state == .free
                        && task.direction == .down
                        && liftEdetSEtaja > task.from {
    //                    && liftEdetNaEtaj <= task.to {
    //                    elevator.moveToTasks.insert(task, at: 0)
                        elevator.moveToTasks.append(task)
                        task.state = .elevatorIsComing
                        break
                    }
                }
            } else if elevator.state == .moveUp {
                let liftEdetSEnaja = elevator.currentFloor
    //            let elevatorTask = elevator.moveToTasks.first!
    //            let liftEdetNaEtaj = elevator.closestTaskFloor
                for task in tasks {
                    if task.state == .free
                        && task.direction == .up
                        && liftEdetSEnaja < task.from {
    //                    && liftEdetNaEtaj >= task.to {
    //                    elevator.moveToTasks.insert(task, at: 0)
                        elevator.moveToTasks.append(task)
                        task.state = .elevatorIsComing
                        break
                    }
                }
            }
        }
        
        workAnimation()
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let tag = 1
//        for b in btnCollection {
//            if b.tag == tag {
//                viewElevator1.frame.origin.y = b.frame.origin.y
//                break
//            }
//        }
//    }
    
//    func printAllElevatorTasks() {
//        print()
//        for t in elevators[0].moveToTasks {
//            print(t)
//        }
//    }
    
//    func getAllTasks() -> [Task] {
//        var result: [Task] = []
//        for (index, button) in buttons.enumerated() {
//            if !button.pointsToMove.isEmpty {
//                for t in button.pointsToMove {
//                    result.append(Task(from: index + 1, to: t))
//                }
//            }
//        }
//        return result
//    }
    
    func setLabels() {
        var goodTasks: [Task] = []
        for e in elevators {
            let taski = e.moveToTasks.filter( { t in t.state != .delivering } )
            goodTasks += taski
        }
        goodTasks += tasks
        
        for i in 1...numberOfFloors {
            let x = goodTasks.filter({ t in t.from == i }) // Проверяем и берем, что на этаже есть хоть какие-то таски
            var text = ""
            if !x.isEmpty {
                let y = x.map({ t in String(t.to) }) // y = массив стрингов этажей назначений
                text = y.joined(separator: ",") // объединение массива в одну строку
            }
            floorViews[i - 1].text = text
            
        }
    }
    
    func getChosenFloor(from: Int, to: Int) {
//        buttons[from - 1].addNewPoint(p: to)
        tasks.append(Task(from: from, to: to))
        updateStatus()
    }
    
    func workAnimation() {
        
        setLabels()
        let spaceBetweenFloors = abs(stackFloors.subviews[1].frame.origin.y - stackFloors.subviews[0].frame.origin.y)
        
        for (i, e) in elevators.enumerated() {
            let deliveringTasks = e.moveToTasks.filter( { t in t.state == .delivering } )
            let x = deliveringTasks.map({ t in String(t.to) })
            elevatorLabels[i].text = x.joined(separator: ", ")
            
            if !e.moveToTasks.isEmpty && !e.isAnimated {
                
                let endPoint = e.closestTaskFloor!     //TODO: 1
                
                if endPoint < e.currentFloor {
                    e.state = .moveDown
                } else if endPoint > e.currentFloor {
                    e.state = .moveUp
                } else {
                    e.state = .stopped
                    if e.unLoadAndLoadEveryone() {
                        setLabels()
                        if !e.moveToTasks.isEmpty {
                            let nextTask = e.moveToTasks[0]
                            if nextTask.state == .delivering {
                                e.state = nextTask.to > e.currentFloor ? .moveUp : .moveDown
                            } else if nextTask.state == .elevatorIsComing {
                                e.state = nextTask.from > e.currentFloor ? .moveUp : .moveDown
                            }
                        }
                    }
                }
                
                var koef: Int? = nil
                if e.state == .moveDown {
                    koef = -1
                } else if e.state == .moveUp {
                    koef = 1
                }
                
                if let kkoef = koef {
                    e.isAnimated = true
                    UIView.animate(withDuration: 0.7,
                                   delay: delays[i],
                                   options: .curveLinear,
                                   animations: {
                        self.viewElevatorsCollection[i].frame.origin.y -= spaceBetweenFloors * CGFloat(kkoef)
                    },
                                   completion: { isCompleted in
                        if isCompleted {
                            e.isAnimated = false
                            e.currentFloor += kkoef
                            
                            self.delays[i] = e.unLoadAndLoadEveryone() ? 1 : 0
                    
//                            if e.moveToTasks[0].state == .elevatorIsComing
//                                && e.currentFloor == e.moveToTasks[0].from {
//                                e.moveToTasks[0].state = .delivering
//                                self.delays[i] = 1
//                                
//                                if e.moveToTasks[0].to > e.currentFloor {
//                                    e.state = .moveUp
//                                } else {
//                                    e.state = .moveDown
//                                }
//                                
//                            } else if e.moveToTasks[0].state == .delivering
//                                        && e.currentFloor == e.moveToTasks[0].to {
//                                e.moveToTasks.remove(at: 0)
//                                self.delays[i] = 1
//                                
//                                if e.moveToTasks.isEmpty {
//                                    e.state = .stopped
//                                }
//                            }
                            
                            DispatchQueue.main.async {
                                self.updateStatus()
                            }
                        }
                    })
                }
            }
        }
    }
    
}




