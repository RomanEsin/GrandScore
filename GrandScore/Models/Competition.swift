//
//  Competition.swift
//  Competition
//
//  Created by Роман Есин on 01.08.2021.
//

import Foundation

struct Player: Codable {
    let name: String
    let type: String

    static let examples = [
        Player(name: "Pidor123", type: "player"),
        Player(name: "Сергей Морозов", type: "player"),
        Player(name: "Лев Колван", type: "player"),
        Player(name: "Роман Горжей", type: "player"),
        Player(name: "Владимир Саранчук", type: "couch"),
    ]
}

struct Team: Codable {
    let name: String
    let players: [Player]

    static let examples = [
        Team(name: "Приморский край", players: Player.examples.shuffled()),
        Team(name: "Краснодарский край", players: Player.examples.shuffled()),
        Team(name: "Свердловская область", players: Player.examples.shuffled()),
        Team(name: "Москва", players: Player.examples.shuffled())
    ]
}

struct Competition: Codable, Identifiable {
    var id = UUID().uuidString

    let title: String
    let teams: [Team]
    let location: String
    let startTime: Date
    let endTime: Date

    static let examples = [
        Competition(title: "Всероссийкая спартакиада хуяда", teams: Team.examples.shuffled(), location: "Москва", startTime: Date().addingTimeInterval(1000), endTime: Date().addingTimeInterval(2000)),
    ]
}
