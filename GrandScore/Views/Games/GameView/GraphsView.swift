//
//  GraphsView.swift
//  GraphsView
//
//  Created by Роман Есин on 28.07.2021.
//

import SwiftUI

struct GraphsView: View {

    @ObservedObject var teamStatus: TeamStatus

    var body: some View {
        HStack {
            let stats = teamStatus.currentTeam.savedStats
            let innings = stats.keys.map { Int($0)! }.sorted()
                .filter {
                    let i = String($0)
                    let last = stats[i]!.last
                    return last?.strikes != 0 ||
                    last?.balls != 0 // ||
//                    last?.outs != 0
                }
                .map { String($0) }

            let strikes = innings.map { Double(stats[$0]!.last?.strikes ?? 0) }
            let balls = innings.map { Double(stats[$0]!.last?.balls ?? 0) }

            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    LinearGradient(gradient: GradientColors.orange.getGradient(),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                        .frame(width: 30, height: 30)
                        .cornerRadius(15)
                    Text("- Страйки")
                        .font(.title3.bold())
                }

                HStack(alignment: .center) {
                    LinearGradient(gradient: GradientColors.green.getGradient(),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                        .frame(width: 30, height: 30)
                        .cornerRadius(15)
                    Text("- Болы")
                        .font(.title3.bold())
                }
            }
            .foregroundColor(.secondary)
            .padding(.trailing)
            VStack(alignment: .leading) {
                Text("Статистика")
                    .font(.title2.bold())
                    .multilineTextAlignment(.leading)

                ZStack {
                    let sorted = strikes.sorted()
                    let sorted2 = balls.sorted()
                    let min: CGFloat = 0 // min(sorted.first!, sorted2.first!)
                    let max = max(sorted.last!, sorted2.last!)

                    Chart(points: strikes.map { CGFloat($0) },
                          min: min, max: max,
                          fillStyle: LinearGradient(gradient: GradientColors.orange.getGradient(),
                                                    startPoint: .leading, endPoint: .trailing))

                    Chart(points: balls.map { CGFloat($0) },
                          min: min, max: max,
                          fillStyle: LinearGradient(gradient: GradientColors.green.getGradient(),
                                                    startPoint: .leading, endPoint: .trailing))
                }
                .frame(height: 180)
            }
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(16)
            .frame(maxWidth: .infinity, alignment: .trailing)

        }
    }
}

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
            let height = frame.size.height
//            let height = absHeight - 20
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
