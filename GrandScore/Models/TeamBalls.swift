//
//  TeamBalls.swift
//  GrandScore
//
//  Created by Роман Есин on 02.05.2021.
//

import SwiftUI
import os

struct StrikeBalls: Codable {
    let pitcherName: String
    var strikes: Int
    var balls: Int
    var outs: Int
    var totalCount: Int
}

protocol TeamBallsDelegate: AnyObject {
    func changeTeams()
    func save()
    func saveStats()
    func getTeamName() -> String
    func getCurrentInning() -> Int
}

class TeamBalls: ObservableObject {
    private let logger = Logger(subsystem: "grandscore", category: "TeamBalls")
    private var skipObservers = false
    weak var delegate: TeamBallsDelegate?

    @Published var totalCount = 0 {
        didSet {
            guard !skipObservers else { return }
            Haptic.shared.click()
        }
    }

    @Published var currentPitcher = "" {
        didSet {
            self.saveStats()
            skipObservers = true
            self.totalCount = 0
            self.other = 0
            skipObservers = false
        }
    }

    @Published var strikes = 0 {
        willSet {
            totalCount += newValue - strikes
        }
        didSet {
            guard !skipObservers else { return }
            if strikes == 3 {
                outOrInField()
                self.outs += 1
            }
        }
    }

    @Published var balls = 0 {
        willSet {
            totalCount += newValue - balls
        }
        didSet {
            guard !skipObservers else { return }
            if balls == 4 {
                outOrInField()
            }
        }
    }

    @Published var other = 0 {
        didSet {
            guard !skipObservers else { return }
            Haptic.shared.click()
        }
    }

    @Published var outs = 0 {
        didSet {
            guard !skipObservers else { return }
            if outs == 3 {
                self.outs = 0
                outOrInField()
                delegate?.changeTeams()
            } else {
                outOrInField()
                Haptic.shared.click()
            }
        }
    }

    typealias StatsType = [String: [StrikeBalls]]
    @Published var savedStats: StatsType = [:]

    func outOrInField() {
        Haptic.shared.hardClick()
        saveStats()
        self.delegate?.save()
        self.skipObservers = true
        self.totalCount += self.balls + self.strikes
        self.balls = 0
        self.strikes = 0
        self.other = 0
        self.skipObservers = false
    }

    func saveStats() {
        delegate?.saveStats()
    }

    func save(teamName: String? = nil) {
        if let inning = self.delegate?.getCurrentInning() {
            let inning = String(inning)
            if self.savedStats[inning] == nil {
                self.savedStats[inning] = []
            }

            if self.savedStats[inning]!.isEmpty {
                self.savedStats[inning]!.append(
                    StrikeBalls(pitcherName: currentPitcher,
                                strikes: 0,
                                balls: 0,
                                outs: 0,
                                totalCount: 0)
                )
            }
            
            var lastIndex = self.savedStats[inning]!.count - 1
            self.savedStats[inning]![lastIndex].totalCount = self.totalCount

            if self.savedStats[inning]![lastIndex].pitcherName != currentPitcher {
                self.savedStats[inning]!.append(
                    StrikeBalls(pitcherName: currentPitcher,
                                strikes: 0,
                                balls: 0,
                                outs: 0,
                                totalCount: 0)
                )
                lastIndex = self.savedStats[inning]!.count - 1
            }

            self.savedStats[inning]![lastIndex].outs = self.outs
            self.savedStats[inning]![lastIndex].strikes += self.strikes + self.other
            self.savedStats[inning]![lastIndex].balls += self.balls
        }

        do {
            let encoder = JSONEncoder()
            let savedData = try encoder.encode(self.savedStats)
            let key = "stats-\(teamName ?? "nil")"
            logger.log("SAVE KEY: \(key)")
            UserDefaults.standard.set(savedData, forKey: key)
            UserDefaults.standard.synchronize()
        } catch {
            logger.error("\(error.localizedDescription)")
        }

        logger.log("SAVED KEY: \(self.savedStats)")
    }

    init(key: String? = nil) {
        let key = key ?? "stats-\(delegate?.getTeamName() ?? "nil")"
        logger.log("INIT KEY: \(key)")
        guard let savedData = UserDefaults.standard.data(forKey: key) else { return }

        do {
            let decoder = JSONDecoder()
            let savedStats = try decoder.decode(StatsType.self, from: savedData)
            self.savedStats = savedStats
            var totalCount = 0

            let keys = savedStats.keys.map { Int($0)! }.sorted().map { String($0) }
            let lastPitcher = savedStats[keys.last!]!.last!.pitcherName
            var lastOuts = 0

            keys.forEach { key in
                let last = savedStats[key]!.last!
                let lastPitcherName = last.pitcherName

                if lastPitcher == lastPitcherName {
                    lastOuts = last.outs
                    totalCount += last.strikes + last.balls // + last.other
                }

            }

            self.outs = lastOuts
            self.currentPitcher = lastPitcher
            self.totalCount = totalCount

            // print(savedStats.sorted(by: { Int($0.key)! < Int($1.key)! }).map { "\($0.key) - \($0.value)" })
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
}
