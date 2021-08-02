//
//  ContentView.swift
//  GrandScore
//
//  Created by Роман Есин on 02.05.2021.
//

import SwiftUI
import MapKit

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

    @State var isMapFullScreen = false
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
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

                        PitcherThrowsView()
                            .environmentObject(teamStatus)
                            .padding()
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)

//                    VStack {
//                        ZStack(alignment: .topTrailing) {
//                            Field(playersInField: .constant([
//                                .init()
//                            ]))
//                                .padding(50)
//                        }
//                    }
//                    .frame(height: isMapFullScreen ? UIScreen.main.bounds.height : 220)
//                    .frame(maxWidth: .infinity)
//                    .padding(12)
//                    .background(Color(UIColor.secondarySystemGroupedBackground))
//                    .cornerRadius(16)
//                    .padding(.horizontal)

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
