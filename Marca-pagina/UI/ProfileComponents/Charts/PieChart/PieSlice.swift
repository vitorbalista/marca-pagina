import SwiftUI

struct PieSlice: View {

    let pieSliceData: PieSliceData

    var midRadians: Double {
        return Double.pi / 2.0 - (pieSliceData.startAngle + pieSliceData.endAngle).radians / 2.0
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width

                    let center = CGPoint(x: width * 0.5, y: height * 0.5)

                    path.move(to: center)

                    path.addArc(
                        center: center,
                        radius: width * 0.5,
                        startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle,
                        endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle,
                        clockwise: false)

                }
                .fill(pieSliceData.color)
                if let text = pieSliceData.text {
                    Text(text)
                        .position(
                            x: geometry.size.width * 0.5 * CGFloat(1.0 + 0.78 * cos(self.midRadians)),
                            y: geometry.size.height * 0.5 * CGFloat(1.0 - 0.78 * sin(self.midRadians))
                        )
                        .foregroundColor(Color.white)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct PieSliceData {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    let text: String?
}
