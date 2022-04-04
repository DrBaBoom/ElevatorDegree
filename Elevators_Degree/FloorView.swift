//
//  FloorView.swift
//  Elevators_Degree
//
//  Created by Yura on 02.04.2022.
//

import UIKit

class FloorView: UIView {
    
    var setuped = false
    private let lbl = UILabel()
    private let btn = UIButton()
    var action: ((_ sender: UIButton) -> Void)? = nil
    var text: String {
        get {
            return lbl.text ?? ""
//            return lbl.text != nil ? lbl.text! : ""
        }
    
        set {
            lbl.text = newValue
        }
    }

    override func layoutSubviews() {
        
        if setuped { return }
        setuped = true
        
        let w = self.frame.size.width
        let h = self.frame.size.height
        
        btn.frame = CGRect(x: 0, y: 0, width: w / 2, height: h)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(btnPushed(_:)), for: .touchUpInside)
        lbl.frame = CGRect(x: w / 2, y: 0, width: w / 2, height: h)
        lbl.font = lbl.font.withSize(9)
        addSubview(btn)
        addSubview(lbl)
    }
    
    func setFloor(n: Int) {
        btn.setTitle("\(n)", for: .normal)
        btn.tag = n
    }
    
    func setAction(a: @escaping (_ sender: UIButton) -> Void) {
        self.action = a
    }
    
    @objc func btnPushed(_ sender: UIButton) {
        if let aa = action {
            aa(sender)
        }
    }

}
