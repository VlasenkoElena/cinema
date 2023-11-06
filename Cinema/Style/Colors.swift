//
//  Colors.swift
//  Cinema
//
//  Created by Helen on 25.10.2023.
//

import Foundation
import SwiftUI

struct Colors {

    static let blackWhite = color(
        lightMode: .black,
        darkMode: .white
    )
    
    static let darkCharcoal = color(
        lightMode: UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00),
        darkMode: UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
    )
    
    static let cardColor = color(
        lightMode: UIColor.secondarySystemBackground,
        darkMode: UIColor.secondarySystemBackground
    )
    
    static let shadowColor = color(
        lightMode: UIColor(.black.opacity(0.2)),
        darkMode: .clear
    )

    static func color(
        lightMode: UIColor,
        darkMode: UIColor
    ) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return darkMode
                } else {
                    return lightMode
                }
            }
        } else {
            return lightMode
        }
    }
}

extension UIColor {
    var sui: Color {
        Color(self)
    }
}
