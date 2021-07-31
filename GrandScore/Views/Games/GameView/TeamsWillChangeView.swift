//
//  TeamsWillChangeView.swift
//  TeamsWillChangeView
//
//  Created by Роман Есин on 30.07.2021.
//

import SwiftUI

struct TeamsWillChangeView: View {
    @Binding var teamsWillChange: Bool

    @State var degrees: CGFloat = 0
    @State var didAppear = false

    var body: some View {
        if teamsWillChange {
            ZStack {
                Color.black.opacity(0.1).ignoresSafeArea()

                VStack {
                    Text("Смена команд")
                        .font(.title3.bold())
                        .foregroundColor(.secondary)
                        .padding(.bottom)
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .rotationEffect(.degrees(degrees))
                        .foregroundColor(.secondary)
                        .font(.system(size: 50))
                }
                .frame(width: 200, height: 200)
                .background(VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial)))
                .cornerRadius(32)
                .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 0)
                .scaleEffect(didAppear ? 1 : 0.5)
            }
            .transition(.opacity.animation(.spring()))
            .onAppear {
                withAnimation(.spring()) {
                    didAppear = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.spring()) {
                        degrees = 180
                    }
                }
            }
            .onDisappear {
                didAppear = false
                degrees = 0
            }
        }
    }
}
