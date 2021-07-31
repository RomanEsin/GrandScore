//
//  GamesView.swift
//  GamesView
//
//  Created by Роман Есин on 27.07.2021.
//

import SwiftUI

struct GamesView: View {
    @State var allGames: [TeamStatus] = []

    var body: some View {
        NavigationView {
            List {
                if allGames.isEmpty {
                    Text("Нет сохраненных игр")
                        .font(.title3.bold())
                } else {
                    ForEach(allGames) { status in
                        NavigationLink(destination: ContentView(teamStatus: status)) {
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
            .navigationBarTitle("Игры")
            .navigationBarItems(trailing: Button(action: {
                withAnimation {
                    refreshData()
                }
            }, label: {
                Image(systemName: "arrow.triangle.2.circlepath")
            }))
        }
//        .navigationViewStyle(StackNavigationViewStyle())
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
            print(error)
        }
    }

    func refreshData() {
        guard let data = UserDefaults.standard.data(forKey: "allGames") else { return }
        let decoder = JSONDecoder()
        do {
            let games = try decoder.decode([TeamStatusCodable].self, from: data)
            self.allGames = games.map {
                print($0)
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

            print(allGames)
        } catch {
            print(error)
        }
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView()
    }
}
