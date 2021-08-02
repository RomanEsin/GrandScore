//
//  Field.swift
//  Field
//
//  Created by Роман Есин on 02.08.2021.
//

import SwiftUI

let circleWidth: CGFloat = 20
let circleHeight: CGFloat = 20

struct PlayerInField: Identifiable {
    let id = UUID().uuidString
    var pos = 0

    func getXYOffsets(for frame: CGRect) -> (x: CGFloat, y: CGFloat) {
        let trailing = frame.size.width - circleWidth / 2
        let bottom = frame.size.height - circleHeight / 2

        let leading = -circleWidth / 2
        let top = -circleHeight / 2

        switch pos {
        case 0:
            return (trailing, bottom)
        case 1:
            return (trailing, top)
        case 2:
            return (leading, top)
        case 3:
            return (leading, bottom)
        default:
            return (0, 0)
        }
    }
}

struct Field: View {

    @Binding var playersInField: [PlayerInField]

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                Rectangle()
                    .stroke(lineWidth: 5)

                let frame = proxy.frame(in: .local)

                ForEach(playersInField) { player in
                    let (x, y) = player.getXYOffsets(for: frame)

                    Circle()
                        .frame(width: circleWidth, height: circleHeight)
                        .foregroundColor(.secondary)
                        .offset(
                            x: x,
                            y: y
                        )
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .rotationEffect(.degrees(45))
    }
}

//struct Field_Previews: PreviewProvider {
//    static var previews: some View {
//        Field()
//            .padding()
//    }
//}
