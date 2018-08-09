//
//  BDVCollectionViewCell.swift
//  Limbic-Demo-Project
//
//  Created by Bas de Vries on 7/18/18.
//  Copyright © 2018 Limbic. All rights reserved.
//

import UIKit

class BDVCollectionViewCell: UICollectionViewCell {
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.layer.cornerRadius = 3.0
    }
}
