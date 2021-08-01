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

    @State var homeTeamName = ""
    @State var awayTeamName = ""

    @State var nextScreenActive = false

    var body: some View {
        VStack(alignment: .center) {
            Text("Напишите названия команд")
                .font(.title.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 32)
            Spacer()
            VStack(alignment: .center) {
                VStack(alignment: .center) {
                    TextField("Хозяева", text: $homeTeamName)
                        .multilineTextAlignment(.center)
                        .font(.title.bold())
                    TextField("Номер питчера", text: $homePitcher)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .font(.title2.bold())
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(16)
                .padding()

//                Divider()
//                    .padding(.vertical, 32)

                VStack(alignment: .center) {
                    TextField("Гости", text: $awayTeamName)
                        .multilineTextAlignment(.center)
                        .font(.title.bold())
                    TextField("Номер питчера", text: $awayPitcher)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .font(.title2.bold())
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(16)
                .padding()
            }
            Spacer()

            Button {
                teamStatus.homeTeamName = homeTeamName.trimmingCharacters(in: .whitespacesAndNewlines)
                teamStatus.awayTeamName = awayTeamName.trimmingCharacters(in: .whitespacesAndNewlines)
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
                homeTeamName.isEmpty || awayTeamName.isEmpty ||
                homePitcher.isEmpty || awayPitcher.isEmpty
            )


            NavigationLink(destination: ContentView().environmentObject(teamStatus),
                           isActive: $nextScreenActive) { EmptyView() }
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
