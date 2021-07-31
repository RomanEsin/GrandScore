//
//  TeamStatus.swift
//  GrandScore
//
//  Created by Роман Есин on 02.05.2021.
//

import SwiftUI

struct TeamStatusCodable: Codable {
    let id: String
    
    let homeTeam: String
    let awayTeam: String

    let homeName: String
    let awayName: String

    let isHomeTeam: Bool
    let currentInning: Int
}

class TeamStatus: ObservableObject, Identifiable {
    var id = UUID().uuidString

    @Published var homeTeam: TeamBalls
    @Published var awayTeam: TeamBalls

    @Published var homeTeamName: String
    @Published var awayTeamName: String

    @Published var currentInning = 0

    @Published var shouldChangeTeams = false

    @Published var isHomeTeam = true {
        didSet {
            currentTeam = isHomeTeam ? homeTeam : awayTeam
        }
    }

    @Published var currentTeam: TeamBalls

    init(id: String, homeTeam: TeamBalls, awayTeam: TeamBalls, homeName: String, awayName: String, isHomeTeam: Bool, currentInning: Int) {
        self.id = id
        self.homeTeamName = homeName
        self.awayTeamName = awayName
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.currentInning = currentInning
        self.isHomeTeam = isHomeTeam
        self.currentTeam = isHomeTeam ? homeTeam : awayTeam

        self.homeTeam.delegate = self
        self.awayTeam.delegate = self
    }

    init(homeTeam: TeamBalls, awayTeam: TeamBalls, isHomeTeam: Bool = true) {
        self.homeTeamName = ""
        self.awayTeamName = ""
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.isHomeTeam = isHomeTeam
        self.currentTeam = isHomeTeam ? homeTeam : awayTeam

        self.homeTeam.delegate = self
        self.awayTeam.delegate = self
    }

    func changeTeams3Outs() {
        DispatchQueue.main.async {
            self.currentInning += 1
            self.isHomeTeam = self.currentInning % 2 == 0
        }
    }
}

extension TeamStatus: TeamBallsDelegate {
    func changeTeams() {
        shouldChangeTeams.toggle()
    }

    func save() {
        let stats = TeamStatusCodable(id: id,
                                      homeTeam: "stats-\(homeTeamName)-\(id)",
                                      awayTeam: "stats-\(awayTeamName)-\(id)",
                                      homeName: homeTeamName,
                                      awayName: awayTeamName,
                                      isHomeTeam: isHomeTeam,
                                      currentInning: currentInning)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        do {
            if let allData = UserDefaults.standard.data(forKey: "allGames") {
                var allGames = try decoder.decode([TeamStatusCodable].self, from: allData)
                if allGames.contains(where: { $0.id == id }),
                   let index = allGames.firstIndex(where: { $0.id == id }) {
                    allGames[index] = stats
                    let data = try encoder.encode(allGames)
                    UserDefaults.standard.set(data, forKey: "allGames")
                } else {
                    allGames.append(stats)
                    let data = try encoder.encode(allGames)
                    UserDefaults.standard.set(data, forKey: "allGames")
                }
                
                print(allGames)
            } else {
                let data = try encoder.encode([stats])
                UserDefaults.standard.set(data, forKey: "allGames")
            }
            UserDefaults.standard.synchronize()
        } catch {
            print(error)
        }
    }

    func getTeamName() -> String {
        "\(isHomeTeam ? homeTeamName : awayTeamName)-\(id)"
    }

    func getCurrentInning() -> Int {
        currentInning
    }

    func saveStats() {
        homeTeam.save(teamName: homeTeamName + "-" + id)
        awayTeam.save(teamName: awayTeamName + "-" + id)
        save()
    }
}
