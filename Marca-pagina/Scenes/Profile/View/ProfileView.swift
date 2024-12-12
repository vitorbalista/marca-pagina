import SwiftUI

struct ProfileView: View {

    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                ProfileCell(imageName: "user padrao",
                            name: viewModel.userName,
                            frameSize: CGSize(width: 328, height: 91),
                            imageSize: CGSize(width: 91, height: 91),
                            profilePosition: .horizontal)
                Spacer()
            }
            .padding(.leading, 32)

            Divider()
                .padding()
            VStack(alignment: .leading) {
                ForEach(Status.allCases, id: \.rawValue) { value in
                    StatisticsView(
                        imageName: value.image,
                        text: value.achievementText,
                        goal: viewModel.getBookCount(by: value),
                        foregroundColor: value.foregroundColor,
                        imageSize: CGSize(width: 26.77,
                                          height: 26.77)
                    )
                }
            }
            .padding(.horizontal, 16)
            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            Spacer()
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(CoordinatorProfileObject()))
    }
}
