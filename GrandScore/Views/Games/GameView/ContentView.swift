//
//  ContentView.swift
//  GrandScore
//
//  Created by Роман Есин on 02.05.2021.
//

import SwiftUI

class Haptic {
    static let shared: Haptic = Haptic()
    var generator = UIImpactFeedbackGenerator(style: .light)
    var heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    func click() {
        DispatchQueue.main.async {
            self.generator.impactOccurred()
        }
    }
    
    func hardClick() {
        DispatchQueue.main.async {
            self.heavyGenerator.impactOccurred()
        }
    }
}

struct HiddenNavBarOptional: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .navigationBarHidden(true)
        } else {
            content
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var teamStatus: TeamStatus
    
    @State var isSettingNewName = false
    
    @Environment(\.presentationMode) var presentationMode

    @State var teamsWillChange = false
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    VStack {
                        HStack {
                            Text("Иннинг: \(1 + teamStatus.currentInning / 2) -")
                            if teamStatus.currentInning % 2 == 0 {
                                Text("Верх")
                            } else {
                                Text("Низ")
                                    .foregroundColor(.red)
                            }
                        }
                        .opacity(0.8)
                        .font(.title3.bold())
                        .padding(.top, 8)

                        Picker(selection: $teamStatus.isHomeTeam, label: Text("Picker")) {
                            Text("Хозяева").tag(true)
                            Text("Гости").tag(false)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        //                    .allowsHitTesting(false)

                        Text(teamStatus.isHomeTeam ? teamStatus.homeTeamName : teamStatus.awayTeamName)
                            .font(.title.bold())
                            .padding(.vertical)

                        HStack(alignment: .center) {
                            Text("Питчер: \(teamStatus.currentTeam.currentPitcher)")
                                .multilineTextAlignment(.leading)
                                .font(.title2.bold())
                            Spacer(minLength: 0)
                            Text("Всего Бросков: \(teamStatus.currentTeam.totalCount)")
                                .font(.title3.bold())
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.secondary)

                            Button {
                                self.isSettingNewName = true
                            } label: {
                                Image(systemName: "arrow.2.squarepath")
                                    .font(.title3)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom)


                        VStack(spacing: 0) {
//                            Stepper("Всего Бросков: \(Text("\(teamStatus.currentTeam.totalCount)").foregroundColor(.secondary))",
//                                    value: $teamStatus.currentTeam.totalCount) { changed in
//                                if changed {
//
//                                }
//                            }
//                                    .font(.title3.bold())
//
//                            Divider()
//                                .padding(.vertical, 8)

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
//                            .padding(.bottom, 12)

                            Divider()
                                .padding(.vertical, 8)

                            Stepper("Ауты: \(Text("\(teamStatus.currentTeam.outs)").foregroundColor(.red))",
                                    value: $teamStatus.currentTeam.outs, in: 0...3, step: 1) { changed in
                                if changed {

                                }
                            }
                                    .font(.title3.bold())
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)

                    if teamStatus.currentInning >= 2 {
                        GraphsView(teamStatus: teamStatus)
                            .padding(.horizontal)
                            .transition(.opacity.animation(.spring()))
                    } else {
                        Text("Через иннинг здесь появится статисика бросков питчера")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal)
                    }
//                    .frame(height: 300)

                    NavigationLink(destination: PitcherStats(teamStatus: teamStatus)) {
                        HStack {
                            Text("Статистика питчеров")
                                .font(.title3)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
//                    .padding(.bottom)

                    VStack {
                        Button {
                            teamStatus.save()
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Закрыть игру")
                                .foregroundColor(.red)
                                .font(.title3)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .padding(.horizontal)
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .cornerRadius(16)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 32)
                }
                .frame(maxWidth: .infinity)
                .disabled(teamsWillChange)
            }
            .overlay(ChangePitcherView(changePitcherIsPresented: $isSettingNewName, teamStatus: teamStatus))
        }
        .onChange(of: teamStatus.shouldChangeTeams, perform: { newValue in
            teamsWillChange = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                teamsWillChange = false
                withAnimation {
                    teamStatus.changeTeams3Outs()
                }
            }
        })
        .overlay(TeamsWillChangeView(teamsWillChange: $teamsWillChange))
//                .navigationBarHidden(true)
//        .navigationBarTitle("\(teamStatus.homeTeamName) - \(teamStatus.awayTeamName)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .modifier(HiddenNavBarOptional())
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(teamStatus: TeamStatus(homeTeam: .init(), awayTeam: .init()))
//    }
//}
