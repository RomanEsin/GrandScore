//
//  ChangePitcherView.swift
//  ChangePitcherView
//
//  Created by Роман Есин on 30.07.2021.
//

import SwiftUI

struct ChangePitcherView: View {

    @Binding var changePitcherIsPresented: Bool

    @ObservedObject var teamStatus: TeamStatus
    @State var newName = ""
    @State var didAppear = false

    var body: some View {
        if changePitcherIsPresented {
            ZStack {
                Color.black.opacity(0.1).ignoresSafeArea()
                VStack(alignment: .center) {
                    TextField("Номер нового питчера", text: $newName)
                        .multilineTextAlignment(.center)
                        .font(.title3.bold())
                        .keyboardType(.numberPad)
                        .padding(.bottom, 24)

                    HStack {
                        Button {
                            changePitcherIsPresented = false
                        } label: {
                            Text("Отмена")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Color(UIColor.secondarySystemFill))
                                .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity)

                        Button {
                            $teamStatus.currentTeam.currentPitcher.wrappedValue = newName
                            changePitcherIsPresented = false
                        } label: {
                            Text("Продолжить")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Color(UIColor.secondarySystemFill))
                                .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial)))
                .cornerRadius(16)
                .padding(.horizontal, 32)
                .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 0)
                .scaleEffect(didAppear ? 1 : 0.5)
            }
            .transition(.opacity.animation(.spring()))
            .onAppear {
                withAnimation(.spring()) {
                    didAppear = true
                }
            }
            .onDisappear {
                newName = ""
                didAppear = false
            }
        }
    }
}
