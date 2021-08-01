//
//  PitcherStats.swift
//  PitcherStats
//
//  Created by Роман Есин on 27.07.2021.
//

import SwiftUI

struct PitcherStats: View {

    @ObservedObject var teamStatus: TeamStatus

    typealias PitcherData = (strikes: Int, balls: Int, all: [(strikes: Int, balls: Int)])

    var pitchers: [String: PitcherData] {
        let stats = $teamStatus.currentTeam.savedStats.wrappedValue
        var pitchers: [String: PitcherData] = [:]
        stats.keys.map { Int($0)! }.sorted().map { String($0) }.forEach { inning in
            stats[inning]?.forEach({ strikeBalls in
                if pitchers[strikeBalls.pitcherName] == nil {
                    pitchers[strikeBalls.pitcherName] = (0, 0, [])
                }
                pitchers[strikeBalls.pitcherName]?.strikes += strikeBalls.strikes
                pitchers[strikeBalls.pitcherName]?.balls += strikeBalls.balls

                if strikeBalls.strikes != 0 || strikeBalls.balls != 0 {
                    pitchers[strikeBalls.pitcherName]?.all.append((strikeBalls.strikes, strikeBalls.balls))
                }
            })
        }

        return pitchers
    }

    var body: some View {
        ScrollView {
            Text("Полная статистика:")
                .foregroundColor(.secondary)
                .padding(.leading, 32)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)

            VStack {
                let keys = Array(pitchers.keys).filter { !$0.isEmpty }

                ForEach(keys, id: \.self) { pitcherName in
                    let pitcher = pitchers[pitcherName]!
                    let strikes = pitcher.strikes
                    let balls = pitcher.balls

                    let strikesPerInning = pitcher.all.map { $0.strikes }
                    let ballsPerInning = pitcher.all.map { $0.balls }

                    VStack {
                        HStack {
                            Text("Питчер: \(pitcherName)")
                                .multilineTextAlignment(.leading)
                                .font(.title2.bold())
                            Spacer(minLength: 0)
                            VStack(alignment: .trailing) {
                                HStack {
                                    Text("Страйки:")
                                        .foregroundColor(.red)
                                    Text(String(strikes))
                                        .bold()
                                }
                                HStack {
                                    Text("Болы:")
                                        .foregroundColor(.green)
                                    Text(String(balls))
                                        .bold()
                                }
                            }
                            .font(.title3)
                            .multilineTextAlignment(.trailing)
                        }

                        if strikesPerInning.count > 1 {
                            ZStack {
                                let sorted = strikesPerInning.sorted()
                                let sorted2 = ballsPerInning.sorted()
                                let min: CGFloat = 0 // min(sorted.first!, sorted2.first!)
                                let max = CGFloat(max(sorted.last!, sorted2.last!))
                                
                                Chart(points: strikesPerInning.map { CGFloat($0) },
                                      min: min, max: max,
                                      fillStyle: LinearGradient(gradient: GradientColors.orange.getGradient(),
                                                                startPoint: .leading, endPoint: .trailing))

                                Chart(points: ballsPerInning.map { CGFloat($0) },
                                      min: min, max: max,
                                      fillStyle: LinearGradient(gradient: GradientColors.green.getGradient(),
                                                                startPoint: .leading, endPoint: .trailing))
                            }
                            .frame(height: 180)
                            .frame(maxWidth: .infinity)
                        }

                        if pitcherName != keys.last {
                            Divider()
                        }
                    }

                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.bottom)

            StatsView(teamStatus: teamStatus)
        }
        .navigationBarTitle("Статистика питчеров")
    }
}
