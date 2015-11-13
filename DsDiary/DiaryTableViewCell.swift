//
//  DiaryTableViewCell.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/13.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        weatherLabel.layer.cornerRadius = 18
        weatherLabel.layer.borderWidth = 1
        weatherLabel.layer.borderColor = UIColor.secondaryColor().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
