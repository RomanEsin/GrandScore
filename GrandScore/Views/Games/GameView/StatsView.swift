//
//  StatsView.swift
//  StatsView
//
//  Created by Роман Есин on 27.07.2021.
//

import SwiftUI

struct StatsView: View {

    @ObservedObject var teamStatus: TeamStatus

    var body: some View {
        VStack(alignment: .leading) {
            let stats = teamStatus.currentTeam.savedStats
            let innings = stats.keys.map { Int($0)! }.sorted().reversed().filter {
                stats[String($0)]!.last?.strikes != 0 ||
                stats[String($0)]!.last?.balls != 0
            }.map { String($0) }
//
//            let strikes = innings.map { Double(stats[$0]!.first?.strikes ?? 0) }
//            let balls = innings.map { Double(stats[$0]!.first?.balls ?? 0) }

            ForEach(innings, id:\.self) { inning in
                let pitchers = stats[inning]!

                VStack(alignment: .leading, spacing: 8) {
                    Text("Иннинг: \(1 + Int(inning)! / 2)")
                        .foregroundColor(.secondary)
                        .padding(.leading)

                    ForEach(pitchers, id: \.pitcherName) { pitcherStats in
                        HStack {
                            Text(pitcherStats.pitcherName)
                                .font(.title3.bold())
                            Spacer()
                            VStack(alignment: .trailing) {
                                HStack {
                                    Text("Страйки:")
                                    Text("\(pitcherStats.strikes)")
                                }
                                HStack {
                                    Text("Болы:")
                                    Text("\(pitcherStats.balls)")
                                }
                            }
                            .multilineTextAlignment(.trailing)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            }
            .padding(.horizontal)
        }
        .listStyle(InsetGroupedListStyle())
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//struct StatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatsView()
//    }
//}
