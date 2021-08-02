//
//  GamesView.swift
//  GamesView
//
//  Created by Роман Есин on 27.07.2021.
//

import SwiftUI
import os

extension View {
    var logger: Logger {
        Logger(subsystem: "grandscore", category: "Views")
    }
}

struct GamesView: View {
    var competition: Competition
    @State var allGames: [TeamStatus] = []

    var body: some View {
        List {
            if allGames.isEmpty {
                Text("Нет сохраненных игр")
                    .font(.title3.bold())
            } else {
                ForEach(allGames) { status in
                    NavigationLink(destination: ContentView().environmentObject(status)) {
                        HStack {
                            Text(status.homeTeamName)
                                .bold()
                            Text(" - ")
                            Text(status.awayTeamName)
                                .bold()
                        }
                    }
                }
                .onDelete(perform: delete)
            }

            Section {
                NavigationLink(destination: StartView(teamStatus: .init(homeTeam: .init(), awayTeam: .init()))) {
                    Text("Новая игра")
                        .foregroundColor(.accentColor)
                }
                //                    .isDetailLink(false)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(competition.title)
        .navigationBarItems(trailing: Button(action: {
            withAnimation {
                refreshData()
            }
        }, label: {
            Image(systemName: "arrow.triangle.2.circlepath")
        }))
        .onAppear {
            refreshData()
        }
    }

    func delete(at offsets: IndexSet) {
        allGames.remove(atOffsets: offsets)

        let encoder = JSONEncoder()
        do {
            let allGamesCodable = allGames.map {
                TeamStatusCodable(id: $0.id,
                                  homeTeam: "stats-\($0.homeTeamName)-\($0.id)",
                                  awayTeam: "stats-\($0.awayTeamName)-\($0.id)",
                                  homeName: $0.homeTeamName,
                                  awayName: $0.awayTeamName,
                                  isHomeTeam: $0.isHomeTeam,
                                  currentInning: $0.currentInning)
            }
            let gamesData = try encoder.encode(allGamesCodable)
            UserDefaults.standard.set(gamesData, forKey: "allGames")
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }

    func refreshData() {
        guard let data = UserDefaults.standard.data(forKey: "allGames") else { return }
        let decoder = JSONDecoder()
        do {
            let games = try decoder.decode([TeamStatusCodable].self, from: data)
            self.allGames = games.map {
                return TeamStatus(
                    id: $0.id,
                    homeTeam: .init(key: $0.homeTeam),
                    awayTeam: .init(key: $0.awayTeam),
                    homeName: $0.homeName,
                    awayName: $0.awayName,
                    isHomeTeam: $0.isHomeTeam,
                    currentInning: $0.currentInning
                )
            }

            logger.log("All games: \(allGames)")
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
}

//struct GamesView_Previews: PreviewProvider {
//    static var previews: some View {
//        GamesView()
//    }
//}
