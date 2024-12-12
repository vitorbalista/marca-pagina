import SwiftUI

struct PieChartView: View {

    let values: [Double]
    let names: [String]
    let colors: [Color]
    let backgroundColor: Color
    let innerRadiusFraction: CGFloat
    let showInnerText: Bool
    let interactionEnabled: Bool
    let showPercentages: Bool

    @State private var activeIndex: Int = -1

    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []

        for (index, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            let pieSliceData = PieSliceData(startAngle: Angle(degrees: endDeg),
                                            endAngle: Angle(degrees: endDeg + degrees),
                                            color: self.colors[index],
                                            text: showPercentages == true ? String(format:
                                                                                    "%.0f%%", value * 100 / sum) : nil)

            tempSlices.append(pieSliceData)
            endDeg += degrees
        }
        return tempSlices
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<self.values.count, id: \.self) { index in
                    PieSlice(pieSliceData: self.slices[index])
                        .scaleEffect(self.activeIndex == index && interactionEnabled == true ? 1.03 : 1)
                        .animation(.spring(), value: activeIndex)
                }
                .frame(width: geometry.size.width, height: geometry.size.width)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let radius = 0.5 * geometry.size.width
                            let diff = CGPoint(x: value.location.x - radius, y: radius - value.location.y)
                            let dist = pow(pow(diff.x, 2.0) + pow(diff.y, 2.0), 0.5)
                            if dist > radius || dist < radius * innerRadiusFraction {
                                self.activeIndex = -1
                                return
                            }
                            var radians = Double(atan2(diff.x, diff.y))
                            if radians < 0 {
                                radians = 2 * Double.pi + radians
                            }

                            for (index, slice) in slices.enumerated() where radians < slice.endAngle.radians {
                                self.activeIndex = index
                                break
                            }
                        }
                        .onEnded { _ in
                            self.activeIndex = -1
                        }
                )

                Circle()
                    .fill(self.backgroundColor)
                    .frame(width: geometry.size.width * innerRadiusFraction,
                           height: geometry.size.width * innerRadiusFraction)

                VStack {
                    Text(self.activeIndex == -1 ? "Total" : names[self.activeIndex])
                        .font(.title)
                        .foregroundColor(Color.gray)
                    Text(String(format: "%.2f",
                                self.activeIndex == -1 ? values.reduce(0, +) : values[self.activeIndex]))
                    .font(.title)
                    .foregroundColor(.brown)
                }
                .opacity(showInnerText == true ? 1 : 0)
            }
            .background(self.backgroundColor)
            .foregroundColor(Color.white)
        }
    }
}
