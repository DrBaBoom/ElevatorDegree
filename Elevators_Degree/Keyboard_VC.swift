//
//  Keyboard_VC.swift
//  Elevators_Degree
//
//  Created by Yura on 21.03.2022.
//

import UIKit

protocol KeyboardConnection {
    func getChosenFloor(from: Int, to: Int)
}

class Keyboard_VC: UIViewController {
    
    @IBOutlet weak var stcView: UIStackView!
    
    var zaheila: KeyboardConnection? = nil
    var floorCount = 0
    var floor = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createKeyboard()
        
    }
    
    func createKeyboard() {
        var levels = floorCount / 3
        if floorCount % 3 != 0 {
            levels += 1   // +1 для перехода на последний уровень этажей с Экстра кнопками
        }
        
        var n = 1
        
        for _ in 0..<levels {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            for _ in 0..<3 {
                if n > floorCount {
                    break
                }
                let btn = UIButton()
                btn.setTitle("\(n)", for: .normal)
                btn.tag = n
                btn.addTarget(self, action: #selector(floorChosen(_:)), for: .touchUpInside)
                n += 1
                stackView.addArrangedSubview(btn)
            }
            stcView.insertArrangedSubview(stackView, at: 0)
        }
        
    }

    @objc func floorChosen(_ btn: UIButton) {
        zaheila?.getChosenFloor(from: floor, to: btn.tag)
        dismiss(animated: true)
    }
    
}


