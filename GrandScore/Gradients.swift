//
//  Gradients.swift
//  Gradients
//
//  Created by Роман Есин on 30.07.2021.
//

import SwiftUI

extension Color {
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}

public struct Colors {
    public static let color1:Color = Color(hexString: "#E2FAE7")
    public static let color1Accent:Color = Color(hexString: "#72BF82")
    public static let color2:Color = Color(hexString: "#EEF1FF")
    public static let color2Accent:Color = Color(hexString: "#4266E8")
    public static let color3:Color = Color(hexString: "#FCECEA")
    public static let color3Accent:Color = Color(hexString: "#E1614C")
    public static let OrangeEnd:Color = Color(hexString: "#FF782C")
    public static let OrangeStart:Color = Color(hexString: "#EC2301")
    public static let LegendText:Color = Color(hexString: "#A7A6A8")
    public static let LegendColor:Color = Color(hexString: "#E8E7EA")
    public static let LegendDarkColor:Color = Color(hexString: "#545454")
    public static let IndicatorKnob:Color = Color(hexString: "#FF57A6")
    public static let GradientUpperBlue:Color = Color(hexString: "#C2E8FF")
    public static let GradinetUpperBlue1:Color = Color(hexString: "#A8E1FF")
    public static let GradientPurple:Color = Color(hexString: "#7B75FF")
    public static let GradientNeonBlue:Color = Color(hexString: "#6FEAFF")
    public static let GradientLowerBlue:Color = Color(hexString: "#F1F9FF")
    public static let DarkPurple:Color = Color(hexString: "#1B205E")
    public static let BorderBlue:Color = Color(hexString: "#4EBCFF")
}

public struct GradientColor {
    public let start: Color
    public let end: Color

    public init(start: Color, end: Color) {
        self.start = start
        self.end = end
    }

    public func getGradient() -> Gradient {
        return Gradient(colors: [start, end])
    }
}

public struct GradientColors {
    public static let orange = GradientColor(start: Colors.OrangeStart, end: Colors.OrangeEnd)
    public static let blue = GradientColor(start: Colors.GradientPurple, end: Colors.GradientNeonBlue)
    public static let green = GradientColor(start: Color(hexString: "0BCDF7"), end: Color(hexString: "A2FEAE"))
    public static let blu = GradientColor(start: Color(hexString: "0591FF"), end: Color(hexString: "29D9FE"))
    public static let bluPurpl = GradientColor(start: Color(hexString: "4ABBFB"), end: Color(hexString: "8C00FF"))
    public static let purple = GradientColor(start: Color(hexString: "741DF4"), end: Color(hexString: "C501B0"))
    public static let prplPink = GradientColor(start: Color(hexString: "BC05AF"), end: Color(hexString: "FF1378"))
    public static let prplNeon = GradientColor(start: Color(hexString: "FE019A"), end: Color(hexString: "FE0BF4"))
    public static let orngPink = GradientColor(start: Color(hexString: "FF8E2D"), end: Color(hexString: "FF4E7A"))
}
