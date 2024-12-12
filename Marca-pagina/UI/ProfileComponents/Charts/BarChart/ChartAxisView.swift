import SwiftUI

struct YaxisView: View {

    var maxGoal: Int?
    var scaleFactor: Double

    var body: some View {
        GeometryReader { geoR in
            let fullChartHeight = geoR.size.height
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 1.5)
                    .offset(x: (geoR.size.width/2.0) - 1, y: 1)

                ForEach(ticks(), id: \.self) { tick in
                    HStack {
                        Spacer()
                        Text("\(tick)")
                            .font(.footnote)
                            .foregroundColor(maxGoal == tick ? ColorAsset.pink.primary : .none)
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 10, height: 1)
                    }
                    .offset(y: (fullChartHeight/2.0) - (CGFloat(tick) * CGFloat(scaleFactor)))
                }
            }
        }
    }

    func ticks() -> [Int] {
        guard let maxGoal = maxGoal else { return [0] }

        let percentages = [0, 0.5, 1, 1.2]

        return percentages
            .map { $0 * Double(maxGoal) }
            .map { Int($0) }
    }
}

struct XaxisView: View {

    var data: ReadingGoals
    var height: CGFloat

    var body: some View {
        GeometryReader { geoR in
            let labelWidth = (geoR.size.width * 0.9) / CGFloat(data.goals.count)
            let padWidth = (geoR.size.width * 0.05) / CGFloat(data.goals.count)

            ZStack {

                Rectangle()
                    .fill(Color.clear)
                    .frame(height: height)

                VStack {
                    HStack(spacing: 0) {
                        ForEach(data.months, id: \.self) { item in
                            Text(item)
                                .font(.footnote)
                                .frame(width: labelWidth)
                        }
                        .padding(.horizontal, padWidth)
                    }
                }
            }
        }
    }
}
