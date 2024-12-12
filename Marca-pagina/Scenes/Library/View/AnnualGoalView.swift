import SwiftUI

struct AnnualGoalView: View {

    @ObservedObject var viewModel: LibraryViewModel

    private let frameSize = CGSize(
        width: UIScreen.main.bounds.width * 0.91,
        height: UIScreen.main.bounds.width * 0.79 * 0.44
    )

    enum Constants {
        static let goalText = "Meta de leitura \(Calendar.current.component(.year, from: .now))"
        static let metaDeLeituraImage = "meta-de-leitura0"
        static let ops = "Que tal descobrir novas histórias?"
        static let inviteLong =
        """
        Você ainda não marcou livros lidos ou que queira ler. Seu próximo favorito pode estar entre as sugestões!
        """
        static let emptyLibraryImage = "biblioteca-vazia"
    }

    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.shouldShowAnnualGoal {
                annualGoalCard
            }

            if viewModel.shouldShowInviteLong {
                VStack(alignment: .leading) {
                    Text(Constants.ops)
                        .style(.bold, size: 18)
                        .padding(.top, 48)
                        .padding(.bottom, 16)
                        .padding(.leading, 32)

                    Text(Constants.inviteLong)
                        .style(.regular, size: 15)
                        .padding(.bottom, 40)

                    VStack(spacing: 16) {
                        HeaderViewWithButton(imageName: "book", foregroundColor: .black, text: "Sugestões") {
                            viewModel.openSuggestions()
                        }
                        .padding(.horizontal, 16)
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 16) {
                                ForEach(viewModel.suggestionBooks) { book in
                                    BookCellView(book: book,
                                                 size: CGSize(width: 100, height: 150))
                                    .onTapGesture {
                                        viewModel.showBookDetails.toggle()
                                    }
                                    .sheet(isPresented: $viewModel.showBookDetails) {
                                        let bookInfoViewModel = BookInfoViewModel(book: book)
                                            BookInfoView(viewModel: bookInfoViewModel)
                                    }
                                    .padding(.vertical, 3)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, 16)
    }

    var annualGoalCard: some View {
        Group {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.init(uiColor: UIColor.tertiarySystemBackground))
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 0)

                VStack {
//                    AnnualProgress(readBooks: 0, goal: 100)

                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(alignment: .lastTextBaseline) {
                                Image(systemName: "bookmark.fill")
                                    .foregroundColor(ColorAsset.pink.primary)

                                Text(viewModel.inviteText)
                                    .style(.bold, size: 16)
                                    .padding(.bottom, 16)
                            }

                            Text(viewModel.explanationText)
                                .style(.regular, size: 12)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .layoutPriority(2)

                        Spacer()

                        Image(Constants.emptyLibraryImage)
                            .resizable()
                            .frame(width: 122, height: 112)
                    }
                }
//                .padding(.vertical, 24)
                .padding(.horizontal, 16)

            }
            .frame(
                width: frameSize.width,
                height: frameSize.height + 10
            )
            .onTapGesture {
                viewModel.openGoalAtualization()
            }
            .padding(.top, 24)
            //.padding(.bottom, 24)
        }

    }
}

struct AnnualProgress: View {

    let readBooks: Int
    let goal: Int

    private var progress: Double {
        Double(readBooks)/Double(goal)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .frame(height: 4)
                    .foregroundColor(Color(UIColor.systemGray2))

                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(Color("AccentColor"))
                    .frame(
                        width: progress * geometry.size.width,
                        height: 4
                    )
            }
        }
    }
}

struct AnnualGoalView_Previews: PreviewProvider {

    static var previews: some View {
        AnnualGoalView(
            viewModel: .init(coordinator: .init())
        )
    }
}
