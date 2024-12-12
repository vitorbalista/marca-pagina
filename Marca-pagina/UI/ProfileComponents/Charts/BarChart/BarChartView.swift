import SwiftUI

struct BarChartView: View {

    @Binding var data: ReadingGoals

    var body: some View {
        GeometryReader { geoR in

            let fullChartHeight = geoR.size.height * 0.8
            let axisWidth = geoR.size.width * 0.2
            let axisHeight = geoR.size.height * 0.1

            let maxTickHeight = fullChartHeight * 0.95
            let scaleFactor = maxTickHeight / CGFloat(maxDataValue())

            VStack(spacing: 0) {
                HStack(spacing: 0) {

                    YaxisView(maxGoal: data.goals.max(), scaleFactor: scaleFactor)
                        .frame(width: axisWidth, height: fullChartHeight)

                    VStack {
                        HStack(spacing: 0) {
                            ForEach(0 ..< data.goals.count, id: \.self) { index in
                                BarView(month: data.months[index],
                                        goal: data.goals[index],
                                        achievement: data.achievement[index],
                                        scaleFactor: scaleFactor)
                            }
                        }
                    }
                    .frame(height: fullChartHeight)
                }

                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: axisWidth, height: axisHeight)
                    XaxisView(data: data, height: axisHeight)
                }
            }
        }
    }

    func maxDataValue() -> Double {
        guard var largest = data.goals.first else { return 0 }

        for item in data.goals where item > largest {
            largest = item
        }

        return Double(largest) * 1.2
    }
}

struct BarView: View {

    let month: String
    let goal: Int
    let achievement: Int
    var scaleFactor: Double

    var body: some View {
        GeometryReader { geoR in

            let padWidth = geoR.size.width * 0.3

            VStack {
                Spacer()

                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.background)
                        .frame(width: 20)
                        .cornerRadius(10)

                    Rectangle()
                        .fill(ColorAsset.pink.primary)
                        .frame(width: 20, height: achievementOverGoal() * scaleFactor)
                        .cornerRadius(10)
                }

                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.background)
                        .frame(width: 20, height: Double(goal) * scaleFactor)
                        .cornerRadius(10)

                    Rectangle()
                        .fill(ColorAsset.pink.primary)
                        .frame(width: 20, height: achievementUnderGoal() * scaleFactor)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, padWidth)
        }
    }

    func achievementUnderGoal() -> Double {
        Double(achievement <= goal ? achievement : goal)
    }

    func achievementOverGoal() -> Double {
        var achivementOverGoal: Double {
            Double(achievement - goal) > Double(goal) * 0.2 ? Double(goal) * 0.2 : Double(achievement - goal)
        }

        return achievement >= goal ? achivementOverGoal : 0
    }
}

private extension Color {
    static var background = Color(red: 196/255, green: 196/255, blue: 196/255)
}

 struct ChartView_Previews: PreviewProvider {

    static let months = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun"]
    static let goals: [Int] = [100, 100, 100, 80, 50, 30]
    static let achievement: [Int] = [110, 100, 120, 80, 30, 20]

    static let readingGoals = ReadingGoals(months: months,
                                           goals: goals,
                                           achievement: achievement)

    static var previews: some View {

        BarChartView(data: .constant(readingGoals))
            .frame(width: 380, height: 400, alignment: .center)
            .padding(.trailing, 16)
    }
 }
