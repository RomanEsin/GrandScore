//
//  Chart.swift
//  Chart
//
//  Created by Роман Есин on 02.08.2021.
//

import SwiftUI

struct Chart<T: ShapeStyle>: View {
    var points: [CGFloat]
    var min: CGFloat
    var max: CGFloat
    var fillStyle: T

    func map(minRange: CGFloat, maxRange: CGFloat, minDomain: CGFloat, maxDomain: CGFloat, value: CGFloat) -> CGFloat {
        return minDomain + (maxDomain - minDomain) * (value - minRange) / (maxRange - minRange)
    }

    @State var didAppear = false

    var body: some View {
        GeometryReader { proxy in
            let frame = proxy.frame(in: .local)
            let absHeight = frame.size.height
            let height = absHeight - 20
            let step = frame.size.width / CGFloat(points.count - 1)

            ZStack {
                Path { path in
                    for i in 0..<points.count {
                        path.move(to: CGPoint(
                            x: step * CGFloat(i),
                            y: height
                        ))

                        let nextPoint = CGPoint(
                            x: step * CGFloat(i),
                            y: 0
                        )

                        path.addLine(to: nextPoint)
                    }
                }
                .stroke(.gray.opacity(0.5), style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, dash: [5]))

                Path { path in
                    path.move(to: CGPoint(
                        x: 0,
                        y: map(minRange: min, maxRange: max, minDomain: height, maxDomain: 0, value: points[0])
                    ))

                    for i in 1..<points.count {
                        let nextPoint = CGPoint(
                            x: step * CGFloat(i),
                            y: map(minRange: min, maxRange: max, minDomain: height, maxDomain: 0, value: points[i])
                        )

                        path.addLine(to: nextPoint)
                    }
                }
                .trim(from: 0, to: didAppear ? 1 : 0)
                .stroke(fillStyle, style: .init(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .animation(.spring(), value: points)

//                ForEach(0..<points.count) { i in
//                    Text("\(i + 1)")
//                        .position(x: step * CGFloat(i), y: absHeight)
//                        .foregroundColor(.secondary)
//                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 2)) {
                    didAppear = true
                }
            }
        }
        .onDisappear {
            didAppear = false
        }
    }
}
