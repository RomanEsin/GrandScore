//
//  CompetitionsView.swift
//  CompetitionsView
//
//  Created by Роман Есин on 01.08.2021.
//

import SwiftUI

struct CompetitionsView: View {

    let competitions: [Competition] = Competition.examples

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM HH:mm"
        return formatter
    }()

    var body: some View {
        NavigationView {
            List(competitions) { competition in
                NavigationLink(destination: GamesView(competition: competition)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(competition.title)
                            .font(.title3.bold())
                            .multilineTextAlignment(.leading)
                        HStack {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                Text(competition.location)
                            }
                            .multilineTextAlignment(.leading)
                            Spacer()
                            HStack {
                                Text("\(competition.teams.count)")
                                    .foregroundColor(.accentColor)
                                Text("Команд(ы)")
                            }
                        }
                        .foregroundColor(.secondary)

                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.secondary)
                            Text("Начнется:")
                                .foregroundColor(.secondary)

                            Text(competition.startTime, formatter: formatter)
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Соревнования")
        }
    }
}

struct CompetitionsView_Previews: PreviewProvider {
    static var previews: some View {
        CompetitionsView()
    }
}
