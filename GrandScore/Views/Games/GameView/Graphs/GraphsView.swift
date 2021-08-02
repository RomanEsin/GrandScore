//
//  GraphsView.swift
//  GraphsView
//
//  Created by Роман Есин on 28.07.2021.
//

import SwiftUI

struct GraphsView: View {

    @ObservedObject var teamStatus: TeamStatus

    @State var showFraction = true

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

            VStack {
                HStack {
                    Text(showFraction ? "Страйки / Болы" : "Все броски")
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .font(.title2.bold())
                    Spacer()
                    Button {
                        withAnimation {
                            showFraction.toggle()
                        }
                    } label: {
                        Image(systemName: showFraction ? "chart.line.uptrend.xyaxis" : "chart.xyaxis.line")
                            .font(.title2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                PitcherThrowGraph(strikes: strikes, balls: balls, showFraction: $showFraction)
                    .frame(height: 180)
                    .padding(.bottom, 8)

                HStack(spacing: 12) {
                    if showFraction {
                        HStack(alignment: .center) {
                            LinearGradient(gradient: GradientColors.bluPurpl.getGradient(),
                                           startPoint: .leading,
                                           endPoint: .trailing)
                                .frame(width: 25, height: 25)
                                .cornerRadius(12.5)
                            Text("- Страйки / Болы")
                                .font(.title3)
                        }
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .bottom)),
                            removal: .opacity.combined(with: .move(edge: .top)))
                        )
                    } else {
                        HStack(alignment: .center) {
                            LinearGradient(gradient: GradientColors.orange.getGradient(),
                                           startPoint: .leading,
                                           endPoint: .trailing)
                                .frame(width: 25, height: 25)
                                .cornerRadius(12.5)
                            Text("- Страйки")
                                .font(.title3)
                        }
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .bottom)),
                            removal: .opacity.combined(with: .move(edge: .top)))
                        )

                        HStack(alignment: .center) {
                            LinearGradient(gradient: GradientColors.green.getGradient(),
                                           startPoint: .leading,
                                           endPoint: .trailing)
                                .frame(width: 25, height: 25)
                                .cornerRadius(12.5)
                            Text("- Болы")
                                .font(.title3)
                        }
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .bottom)),
                            removal: .opacity.combined(with: .move(edge: .top)))
                        )
                    }
                }
                .foregroundColor(.secondary)
                .padding(.trailing)
            }
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(16)
            .frame(maxWidth: .infinity, alignment: .trailing)

        }
    }
}
