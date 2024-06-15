//
//  ColorsCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Salma on 11/06/2024.
//

//import UIKit
//
//class ColorsCollectionViewCell: UICollectionViewCell {
//    
//    @IBOutlet weak var colorLabel: UILabel!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setupUI()
//    }
//    
//    private func setupUI() {
//        
//        colorLabel.layer.cornerRadius = colorLabel.frame.width / 2
//        colorLabel.clipsToBounds = true
//
//        colorLabel.layer.borderWidth = 0.7
//        colorLabel.layer.borderColor = UIColor.black.cgColor
//        colorLabel.textAlignment = .center
//       
//    }
//    
//    func setColorForValue(_ value: String?) {
//        guard let value = value else {
//            colorLabel.backgroundColor = .gray
//            return
//        }
//        
//        let colorMapping: [String: UIColor] = [
//            "red": .red,
//            "blue": .blue,
//            "green": .green,
//            "yellow": .yellow,
//            "orange": .orange,
//            "purple": .purple,
//            "brown": .brown,
//            "cyan": .cyan,
//            "magenta": .magenta,
//            "white": .white,
//            "black": .black,
//            "gray": .gray,
//            "lightGray": .lightGray,
//            "darkGray": .darkGray,
//            "clear": .clear
//        ]
//        
//        if let color = colorMapping[value.lowercased()] {
//            colorLabel.backgroundColor = color
//        } else {
//            colorLabel.backgroundColor = .gray
//        }
//    }
//}


import UIKit

class ColorsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectionUI()
        }
    }
    
    private func setupUI() {
        colorLabel.layer.cornerRadius = colorLabel.frame.width / 2
        colorLabel.clipsToBounds = true
        colorLabel.textAlignment = .center
        colorLabel.font = UIFont.systemFont(ofSize: 16)
    }
    
    func setColorForValue(_ value: String?) {
        guard let value = value else {
            colorLabel.backgroundColor = .gray
            return
        }
        
        let colorMapping: [String: UIColor] = [
            "red": .red,
            "blue": .blue,
            "green": .green,
            "yellow": .yellow,
            "orange": .orange,
            "purple": .purple,
            "brown": .brown,
            "cyan": .cyan,
            "magenta": .magenta,
            "white": .white,
            "black": .black,
            "gray": .gray,
            "lightGray": .lightGray,
            "darkGray": .darkGray,
            "clear": .clear
        ]
        
        if let color = colorMapping[value.lowercased()] {
            colorLabel.backgroundColor = color
        } else {
            colorLabel.backgroundColor = .gray
        }
    }
    
    private func updateSelectionUI() {
        if isSelected {
            colorLabel.layer.borderWidth = 2.0
            colorLabel.layer.borderColor = UIColor.black.cgColor
            colorLabel.font = UIFont.boldSystemFont(ofSize: 16)
        } else {
            colorLabel.layer.borderWidth = 0.7
            colorLabel.layer.borderColor = UIColor.black.cgColor
            colorLabel.font = UIFont.systemFont(ofSize: 16)
        }
    }
}


