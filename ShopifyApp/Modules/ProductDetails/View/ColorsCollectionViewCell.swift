//
//  ColorsCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Salma on 11/06/2024.
//

import UIKit

class ColorsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorLabel.layer.cornerRadius = colorLabel.frame.width / 2
        colorLabel.clipsToBounds = true
    }
    
    func setColorForValue(_ value: String?) {
        guard let value = value else {
            colorLabel.backgroundColor = .gray // Default color if value is nil
            return
        }
        
        // Define a mapping of values to colors
        let colorMapping: [String: UIColor] = [
            "red": .red,
            "blue": .blue,
            "green": .green,
            // Add more mappings as needed
        ]
        
        // Check if the value exists in the mapping, otherwise set a fallback color
        if let color = colorMapping[value.lowercased()] {
            colorLabel.backgroundColor = color
        } else {
            colorLabel.backgroundColor = .gray // Fallback color
        }
    }
}


