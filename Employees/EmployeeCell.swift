//
//  EmployeeCell.swift
//  Quotes
//
//  Created by Sumit Bangarwa on 11/6/19.
//  Copyright © 2019 Cocoacasts. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "QuoteCell"
    
    // MARK: -
    
    @IBOutlet var cellBtn: UIButton!
    @IBOutlet var nmLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
