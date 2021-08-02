//
//  PitcherThrowsView.swift
//  PitcherThrowsView
//
//  Created by Роман Есин on 01.08.2021.
//

import SwiftUI

struct PitcherThrowsView: View {

    @EnvironmentObject var teamStatus: TeamStatus

    var body: some View {
        VStack(spacing: 0) {
            Stepper("Страйки: \(Text("\(teamStatus.currentTeam.strikes)").foregroundColor(.red))",
                    value: $teamStatus.currentTeam.strikes, in: 0...3, step: 1) { changed in
                if changed {

                }
            }
                    .font(.title3.bold())
                    .padding(.bottom, 12)

            Stepper("Болы: \(Text("\(teamStatus.currentTeam.balls)").foregroundColor(.green))",
                    value: $teamStatus.currentTeam.balls, in: 0...4, step: 1) { changed in
                if changed {

                }
            }
                    .font(.title3.bold())
                    .padding(.bottom, 12)

            VStack {
                Button {
                    $teamStatus.currentTeam.totalCount.wrappedValue += 1
                    $teamStatus.currentTeam.other.wrappedValue += 1
                    $teamStatus.currentTeam.hits.wrappedValue += 1
                    $teamStatus.currentTeam.wrappedValue.outOrInField()
                } label: {
                    Text("Удар")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color(UIColor.secondarySystemFill))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)

                HStack {
                    Button {
                        let balls = $teamStatus.currentTeam.balls.wrappedValue + 1
                        if balls < 4 {
                            $teamStatus.currentTeam.balls.wrappedValue = balls
                            $teamStatus.currentTeam.wrappedValue.outOrInField()
                        } else {
                            $teamStatus.currentTeam.balls.wrappedValue = balls
                        }
                    } label: {
                        Text("HBP")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color(UIColor.secondarySystemFill))
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)

                    Button {
                        if $teamStatus.currentTeam.strikes.wrappedValue < 2 {
                            $teamStatus.currentTeam.strikes.wrappedValue += 1
                        } else {
                            $teamStatus.currentTeam.totalCount.wrappedValue += 1
                            $teamStatus.currentTeam.other.wrappedValue += 1
                        }
                    } label: {
                        Text("Фал бол")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color(UIColor.secondarySystemFill))
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            Divider()
                .padding(.vertical, 8)

            Stepper("Ауты: \(Text("\(teamStatus.currentTeam.outs)").foregroundColor(.red))",
                    value: $teamStatus.currentTeam.outs, in: 0...3, step: 1) { changed in
                if changed {

                }
            }
                    .font(.title3.bold())
        }
    }
}

struct PitcherThrowsView_Previews: PreviewProvider {
    static var previews: some View {
        PitcherThrowsView()
    }
}
