import Foundation
import SwiftUI

struct SingleRatingBody: View {
    let comment: String
    let imageRadius: CGFloat
    @State private var rect: CGRect = CGRect()

    var body: some View {
        HStack {
            ExpandableLineView(height: rect.height + 8)
                .frame(width: imageRadius)

            ExpandableText(comment, lineLimit: 3)
                .background(GeometryGetter(rect: $rect))
        }
        .padding([.leading, .trailing])
    }
}
