//
//  StartView.swift
//  StartView
//
//  Created by Роман Есин on 26.07.2021.
//

import SwiftUI

struct StartView: View {
    
    @ObservedObject var teamStatus: TeamStatus

    @State var homePitcher = ""
    @State var awayPitcher = ""

    @State var nextScreenActive = false

    var body: some View {
        VStack(alignment: .center) {
            Text("Напишите названия команд")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 32)
            Spacer()
            VStack(alignment: .center) {
                TextField("Хозяева", text: $teamStatus.homeTeamName)
                    .multilineTextAlignment(.center)
                    .font(.title.bold())
                TextField("Номер питчера", text: $homePitcher)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.title2.bold())

                Divider()
                    .padding(.vertical, 32)

                TextField("Гости", text: $teamStatus.awayTeamName)
                    .multilineTextAlignment(.center)
                    .font(.title.bold())
                TextField("Номер питчера", text: $awayPitcher)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.title2.bold())
            }
            Spacer()

            Button {
                teamStatus.homeTeam.currentPitcher = homePitcher
                teamStatus.awayTeam.currentPitcher = awayPitcher
                
                nextScreenActive = true
            } label: {
                Text("Продолжить")
                    .font(.title3.bold())
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding()
                    .padding(.bottom, 32)
            }
            .disabled(
                teamStatus.homeTeamName.isEmpty || teamStatus.awayTeamName.isEmpty ||
                homePitcher.isEmpty || awayPitcher.isEmpty
            )


            NavigationLink(destination: ContentView(teamStatus: teamStatus), isActive: $nextScreenActive) { EmptyView() }
            .isDetailLink(false)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .navigationBarTitle("Новая игра")
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarHidden(true)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(teamStatus: .init(homeTeam: .init(), awayTeam: .init()))
    }
}
