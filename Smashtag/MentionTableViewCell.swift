//
//  MentionTableViewCell.swift
//  Smashtag
//
//  Created by Winnie on 16/10/2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class MentionTableViewCell: UITableViewCell {

    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */
    @IBOutlet weak var mentionTextLabel: UILabel!
    
    var mentionType: (MentionItem.MentionType)?

    var mention: Mention? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        mentionTextLabel.text = mention?.keyword
    }
}
