//
//  SubtitleCell.swift
//  BlueDentist
//
//  Created by Michael Holt on 8/23/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit

class SubtitleCell: UITableViewCell {
    static let reuseIdentifier = "SubtitleCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: SubtitleCell.reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
