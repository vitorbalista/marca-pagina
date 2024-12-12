import SwiftUI

struct PieSlice_Previews: PreviewProvider {

    static var pieSliceData = PieSliceData(startAngle: Angle(degrees: 0.0),
                                           endAngle: Angle(degrees: 220.0),
                                           color: Color.black,
                                           text: "20")

    static var previews: some View {
        PieSlice(pieSliceData: pieSliceData)
    }
}
