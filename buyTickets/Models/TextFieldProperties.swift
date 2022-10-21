//
//  UIFieldProperties.swift
//  buyTickets
//
//  Created by Alexey Valevich on 05/05/2022.
//

import UIKit

struct TextFieldProperties {
    public private(set) var borderWidth: CGFloat
    public private(set) var cornerRadius: CGFloat
    public private(set) var borderColor: CGColor
    
    init(borderWidth: CGFloat = 0.7, cornerRadius: CGFloat = 7, borderColor: CGColor = CGColor(red: 169, green: 169, blue: 169, alpha: 0.4)) {
        
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
    }
}
