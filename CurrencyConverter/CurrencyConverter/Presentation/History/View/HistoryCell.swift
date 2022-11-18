//
//  HistoryCell.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 18/11/2022.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var RateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
    }
    
    
    var history: HistoryRate! {
        didSet {
            dateLabel.text = history.date
            RateLabel.text = "\(history.rate)"
        }
    }
}
