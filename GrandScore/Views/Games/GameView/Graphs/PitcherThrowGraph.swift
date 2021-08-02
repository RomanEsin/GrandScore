//
//  PitcherThrowGraph.swift
//  PitcherThrowGraph
//
//  Created by Роман Есин on 02.08.2021.
//

import SwiftUI

struct PitcherThrowGraph: View {
    let strikes: [Double]
    let balls: [Double]

    @Binding var showFraction: Bool

    var body: some View {
        HStack {

//            if showFraction {
//                let roundedMax = CGFloat(Int(maxValue * 100)) / 100
//
//                VStack(alignment: .trailing) {
//                    Text("\(roundedMax)".trimmingCharacters(in: .init(charactersIn: "0")))
//                    Spacer()
//                    Text("0")
//                }
//                .foregroundColor(.secondary)
//            }

            ZStack {
                if showFraction {
                    let fractions = strikes.enumerated().map { enumerated -> CGFloat in
                        let strike = enumerated.element == 0 ? 1 : enumerated.element
                        let ball = balls[enumerated.offset] == 0 ? 1 : balls[enumerated.offset]

                        return CGFloat(strike) / CGFloat(ball)
                    }

                    let sorted = fractions.sorted()
                    let min: CGFloat = 0 // sorted.first!
                    let maxValue = sorted.last!

                    Chart(points: fractions,
                          min: min, max: maxValue,
                          fillStyle: LinearGradient(gradient: GradientColors.bluPurpl.getGradient(),
                                                    startPoint: .leading, endPoint: .trailing))
                        .transition(.opacity)
                } else {
                    let sorted = strikes.sorted()
                    let sorted2 = balls.sorted()
                    let min: CGFloat = 0 // sorted.first!
                    let maxValue = max(sorted.last!, sorted2.last!)


                    Chart(points: strikes.map { CGFloat($0) },
                          min: min, max: maxValue,
                          fillStyle: LinearGradient(gradient: GradientColors.orange.getGradient(),
                                                    startPoint: .leading, endPoint: .trailing))
                        .transition(.opacity)

                    Chart(points: balls.map { CGFloat($0) },
                          min: min, max: maxValue,
                          fillStyle: LinearGradient(gradient: GradientColors.green.getGradient(),
                                                    startPoint: .leading, endPoint: .trailing))
                        .transition(.opacity)
                }
            }
        }
    }
}
