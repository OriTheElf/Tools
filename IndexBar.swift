//
//  IndexBar.swift
//  IndexBar
//
//  Created by Ori on 2019/9/17.
//  Copyright © 2019 Ori. All rights reserved.
//

import UIKit

protocol IndexBarProtocol: AnyObject {
    func updateIndex(_ indexPath: IndexPath?)
}

class IndexBar: UILabel {

    
    let indexes = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var lastRow: Int = -1
    
    weak var delegate: IndexBarProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    func commonSetup() {
        font = .systemFont(ofSize: 18, weight: .black)
        backgroundColor = .groupTableViewBackground
        textAlignment = .center
        isUserInteractionEnabled = true
        numberOfLines = 0
        text = indexes.reduce(nil, { (result, character) -> String in
            guard let result = result else {
                return "\(character)"
            }
            return "\(result)\n\(character)"
        })
    }
    
    func indexPath(_ point: CGPoint, singleTouch: Bool) -> IndexPath? {
        let cHeight = bounds.size.height / CGFloat(indexes.count)
        let row = Int(point.y / cHeight)
        guard row != lastRow else {
            if singleTouch {
                return .init(row: row, section: 0)
            } else {
                return nil
            }
        }
        lastRow = row
        return .init(row: row, section: 0)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            switch touch.location(in: self) {
            case let pt where pt.y >= 0 && pt.y <= bounds.size.height:
                delegate?.updateIndex(indexPath(pt, singleTouch: false))
            default:
                print("Out of bounds")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            switch touch.location(in: self) {
            case let pt where bounds.contains(pt):
                delegate?.updateIndex(indexPath(pt, singleTouch: true))
            default:
                print("Out of bounds")
            }
        }
    }
}
