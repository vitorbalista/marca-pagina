import SwiftUI

struct AllMedalsView: View {
    let medals: [Medal]

    var body: some View {
        // TODO: - filtrar apenas os tipos de medalha que o usuário possui, atualmente está mostrando todos os tipos
        ScrollView {
            ForEach(MedalType.allCases, id: \.self) { medalType in
                let toShowMedals = self.getMedalsByType(medalType)
                if !toShowMedals.isEmpty {
                    MedalListRow(medalType: medalType,
                                 medals: getMedalsByType(medalType))
                    Divider()
                        .overlay(.secondary)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.top, 24)
        }
        .navigationTitle("Medalhas")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func getMedalsByType(_ type: MedalType) -> [Medal] {
        return self.medals.filter({ $0.medalType == type })
    }
}

struct MedalListRow: View {
    let medalType: MedalType
    let medals: [Medal]

    var body: some View {
        VStack {
            HStack {
                Text("Medalhas \(medalType.rawValue)")
                    .style(.bold, size: 20)
                    .padding(.leading, 16)

                Spacer()
            }
            MedalsCollection(horizontalSpacing: 16, medals: medals)
        }
    }
}

struct MedalsCollection: View {
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    let horizontalSpacing: CGFloat
    let medals: [Medal]

    var body: some View {
            LazyVGrid(columns: columns) {
                ForEach(medals, id: \.self) { medal in
                    if let imageName = medal.image,
                       let image = UIImage(named: imageName) {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: getWidth(), height: getWidth())
                            .clipShape(Circle())
                            .accessibilityLabel(imageName)
                    }
                }

            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
    }

    func getWidth() -> CGFloat {
        // Calculo o tamanho utilizando o width disponivel e
        // removo o espaço que sera o numero de itens
        // +1 devido a um dos lados(3 espacos referente a leading e entre os card)
        // e um extra devido o espaco do trailing
        let width: CGFloat = (UIScreen.main.bounds.width - horizontalSpacing * (4)) / 3
        return width
    }
}

 struct AllMedalsView_Previews: PreviewProvider {
    static let medals: [Medal] = [
        Medal(title: "Medalha Início da Jornada", image: "author-icon", medalType: .goal),
        Medal(title: "5 livros", image: "author-icon", medalType: .goal),
        Medal(title: "10 livros", image: "author-icon", medalType: .goal),
        Medal(title: "15 livros", image: "author-icon", medalType: .goal)
    ]

    static var previews: some View {
        AllMedalsView(medals: medals)
    }
 }
