import Foundation
import SwiftUI

struct ExpandableLine: Shape {
    func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            return path
        }
}

struct ExpandableLineView: View {
    var height: CGFloat
    var body: some View {
        ExpandableLine()
            .stroke(style: StrokeStyle(lineWidth: 1))
            .frame(width: 1, height: height)
            .foregroundColor(Color.gray)
            .animation(.easeInOut(duration: 0.05), value: height)
    }
}

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { (geo) -> Path in
            DispatchQueue.main.async {
                self.rect = geo.frame(in: .global)
            }
            return Path()
        }
    }
}
