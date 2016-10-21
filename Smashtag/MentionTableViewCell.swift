//
//  MentionTableViewCell.swift
//  Smashtag
//
//  Created by Winnie on 16/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class MentionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mentionTextLabel: UILabel! { didSet { updateUI() } }
    
    var labelText: String? { didSet { updateUI() } }
    
    private func updateUI() {
        mentionTextLabel?.text = labelText ?? ""
        
    }
}
