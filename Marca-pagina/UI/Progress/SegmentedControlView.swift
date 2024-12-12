import SwiftUI

struct SegmentedControlView: View {

    @Binding var showMode: Int

    var body: some View {
        Picker("Choose how to show the progress", selection: $showMode) {
            Text("Porcentagem").tag(0)
            Text("Página").tag(1)
        }.pickerStyle(.segmented)
    }
}

struct SegmentedControlView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControlView(showMode: .constant(0))
            .previewLayout(.sizeThatFits)
            .padding()
        SegmentedControlView(showMode: .constant(1))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
