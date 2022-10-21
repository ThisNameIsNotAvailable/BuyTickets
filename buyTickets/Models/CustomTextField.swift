//
//  CustomField.swift
//  buyTickets
//
//  Created by Alexey Valevich on 05/05/2022.
//

import UIKit

class CustomUIField: UITextField {
    public func setProperties(_ properties: TextFieldProperties) {
        self.layer.borderWidth = properties.borderWidth
        self.layer.cornerRadius = properties.cornerRadius
        self.layer.borderColor = properties.borderColor
    }
    
    
}
