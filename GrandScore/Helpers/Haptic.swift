//
//  Haptic.swift
//  Haptic
//
//  Created by Роман Есин on 01.08.2021.
//

import UIKit
import CoreHaptics

class Haptic {
    static let shared: Haptic = Haptic()
    var generator = UIImpactFeedbackGenerator(style: .light)
    var heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)

    func click() {
        DispatchQueue.main.async {
            self.generator.impactOccurred()
        }
    }

    func hardClick() {
        DispatchQueue.main.async {
            self.heavyGenerator.impactOccurred()
        }
    }
}
