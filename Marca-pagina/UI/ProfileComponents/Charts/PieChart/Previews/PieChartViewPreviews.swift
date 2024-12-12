import SwiftUI

struct PieChartView_Previews: PreviewProvider {

    static let values: [Double] = [1300, 500, 700]
    static let genres = ["Rent", "Transport", "Education"]
    static let colors = [Color.blue, Color.green, Color.pink]
    static let backgroundColor = Color.white
    static let innerRadiusFraction = 0.6
    static let showInnerText = true
    static let interactionEnabled = true
    static let showPercentages = true

    static let valuesReading: [Double] = [1300, 500, 700]
    static let genresReading = ["Rent", "Transport", "Education"]
    static let colorsReading = [Color.blue, Color.green, Color.pink]
    static let backgroundColorReading = Color.white
    static let innerRadiusFractionReading = 0.8
    static let showInnerTextReading = false
    static let interactionEnabledReading = false
    static let showPercentagesReading = false

    static var previews: some View {
        PieChartView(values: values,
                     names: genres,
                     colors: colors,
                     backgroundColor: backgroundColor,
                     innerRadiusFraction: innerRadiusFraction,
                     showInnerText: showInnerText,
                     interactionEnabled: interactionEnabled,
                     showPercentages: showPercentages)

        PieChartView(values: valuesReading,
                     names: genresReading,
                     colors: colorsReading,
                     backgroundColor: backgroundColorReading,
                     innerRadiusFraction: innerRadiusFractionReading,
                     showInnerText: showInnerTextReading,
                     interactionEnabled: interactionEnabledReading,
                     showPercentages: showPercentagesReading)
        .frame(width: 48, height: 48)
    }
}
