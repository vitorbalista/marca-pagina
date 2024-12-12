import SwiftUI

struct MedalPopover: View {

    let medal: Medal
    let tapAction: () -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .opacity(0.12)
                .edgesIgnoringSafeArea(.all)

            VisualEffect(style: .dark)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Você conseguiu! Parabéns!")
                    .style(.bold, size: 20)
                    .padding(.bottom, 24)
                    .padding(.top, 32)

                if let imageName = medal.image,
                   let image = UIImage(named: imageName) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 209, height: 209)
                        .scaledToFit()
                        .padding(.bottom, 24)
                }

                Text(medal.title)
                    .style(.bold, size: 20)
                    .padding(.bottom, 24)

                Text("Você leu um livro da nossa lista de \(medal.title).")
                    .style(.regular, size: 17)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 32)
            }
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal, 32)
        }
        .onTapGesture {
            self.tapAction()
        }
    }
}

struct VisualEffect: UIViewRepresentable {

    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        effectView.alpha = 0.8

        return effectView
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

 struct MedalPopover_Previews: PreviewProvider {

    static var medal = Medal(
        title: "Livros brasileiros",
        image: "Livros brasileiros",
        medalType: .diversity
    )

    static var previews: some View {
        MedalPopover(medal: medal) {}
    }
 }
