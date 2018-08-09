//
//  CardView.swift
//  Limbic-Demo-Project
//
//  Created by Bas de Vries on 7/6/18.
//  Copyright © 2018 Limbic. All rights reserved.
//

import UIKit

@IBDesignable
class CornerView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
