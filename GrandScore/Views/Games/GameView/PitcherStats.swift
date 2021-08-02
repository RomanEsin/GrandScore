//
//  PitcherStats.swift
//  PitcherStats
//
//  Created by Роман Есин on 27.07.2021.
//

import SwiftUI

struct PitcherStats: View {

    @ObservedObject var teamStatus: TeamStatus

    typealias PitcherData = (strikeOuts: Int,
                             basingBalls: Int,
                             hits: Int,

                             strikes: Int,
                             balls: Int,
                             all: [(strikes: Int, balls: Int)])

    var pitchers: [String: PitcherData] {
        let stats = $teamStatus.currentTeam.savedStats.wrappedValue
        var pitchers: [String: PitcherData] = [:]
        stats.keys.map { Int($0)! }.sorted().map { String($0) }.forEach { inning in
            stats[inning]?.forEach({ strikeBalls in
                if pitchers[strikeBalls.pitcherName] == nil {
                    pitchers[strikeBalls.pitcherName] = (0, 0, 0, 0, 0, [])
                }

                pitchers[strikeBalls.pitcherName]?.strikes += strikeBalls.strikes
                pitchers[strikeBalls.pitcherName]?.balls += strikeBalls.balls

                pitchers[strikeBalls.pitcherName]?.strikeOuts = strikeBalls.strikeOuts
                pitchers[strikeBalls.pitcherName]?.basingBalls = strikeBalls.basingBalls
                pitchers[strikeBalls.pitcherName]?.hits = strikeBalls.hits

                if strikeBalls.strikes != 0 || strikeBalls.balls != 0 {
                    pitchers[strikeBalls.pitcherName]?.all.append((strikeBalls.strikes, strikeBalls.balls))
                }
            })
        }

        return pitchers
    }

    @State var expandedPitcherName = ""
    @State var showFraction = true

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                Text("Полная статистика:")
                    .foregroundColor(.secondary)
                    .padding(.leading, 32)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)

                VStack {
                    let keys = Array(pitchers.keys).sorted().filter { !$0.isEmpty }

                    ForEach(keys, id: \.self) { pitcherName in
                        let pitcher = pitchers[pitcherName]!
                        let strikes = pitcher.strikes
                        let balls = pitcher.balls

                        let strikesPerInning = pitcher.all.map { Double($0.strikes) }
                        let ballsPerInning = pitcher.all.map { Double($0.balls) }

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

                            Button {
                                withAnimation(.spring()) {
                                    if expandedPitcherName == pitcherName {
                                        expandedPitcherName = ""
                                    } else {
                                        expandedPitcherName = pitcherName
                                    }
                                }
                            } label: {
                                HStack {
                                    Text("Посмотреть больше статистики")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .rotationEffect(expandedPitcherName == pitcherName ? .degrees(180) : .degrees(0))
                                }
                            }
                            .padding(.top, 4)

                            if expandedPitcherName == pitcherName && strikesPerInning.count > 1  {
                                VStack {
                                    PitcherThrowGraph(strikes: strikesPerInning, balls: ballsPerInning, showFraction: $showFraction)
                                        .frame(height: 140)

                                    HStack {
                                        Text("adsf")
                                        Text("\(pitcher.strikeOuts)")
                                    }

                                    HStack {
                                        Text("adsf")
                                        Text("\(pitcher.basingBalls)")
                                    }

                                    HStack {
                                        Text("adsf")
                                        Text("\(pitcher.hits)")
                                    }
                                }
                            }

//                            if pitcherName != keys.last {
                            Divider()
//                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                .padding(.bottom)

                StatsView(teamStatus: teamStatus)
            }
        }
        .navigationBarTitle("Статистика питчеров")
    }
}
