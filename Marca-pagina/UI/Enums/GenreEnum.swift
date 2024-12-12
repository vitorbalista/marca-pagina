import SwiftUI

enum Genre: String, CaseIterable {

    case fantasia = "Fantasia"
    case lgbtqia    = "LGBTQIA+"
    case crime = "Crime"
    case acaoAventura = "Ação e Aventura"
    case distopia = "Distopia"
    case infantil = "Infantil"
    case thriller = "Thriller"
    case biografia = "Biografia"
    case naoFiccao = "Não Ficção"
    case hq = "HQ"
    case humor = "Humor"
    case horror = "Horror"
    case pecasRoteiros = "Peças e Roteiros"
    case poesia = "Poesia"
    case youngAdult = "Young Adult"
    case romance = "Romance"
    case ficcaoCientifica = "Ficção Científica"
    case contos = "Contos"

    var description: [String] {
        switch self {
        case .fantasia: return ["Fantasia", "Fiction", "Young Adult Fiction"]
        case .lgbtqia: return ["LGBTQIA+", "LGBTQ", "LGBT"]
        case .crime: return ["Crime"]
        case .acaoAventura: return ["Ação e Aventura"]
        case .distopia: return ["Distopia"]
        case .infantil: return ["Infantil"]
        case .thriller: return ["Thriller"]
        case .biografia: return ["Biografia"]
        case .naoFiccao: return ["Não Ficção"]
        case .hq: return ["HQ", "Graphic Novels"]
        case .humor: return ["Humor"]
        case .horror: return ["Horror"]
        case .pecasRoteiros: return ["Peças e Roteiros"]
        case .poesia: return ["Poesia", "Poetry"]
        case .youngAdult: return ["Young Adult", "Juvenile Fiction", "Young Adult Fiction"]
        case .romance: return ["Romance"]
        case .ficcaoCientifica: return ["Ficção Científica", "Science fiction"]
        case .contos: return ["Contos"]
        }
    }

    var image: Image {
        switch self {
        case .crime: return Image("crime")
        case .acaoAventura: return Image("acao-e-aventura")
        case .distopia: return Image("distopia")
        case .infantil: return Image("infantil")
        case .thriller: return Image("thriller")
        case .biografia: return Image("biografia")
        case .naoFiccao: return Image("nao-ficcao")
        case .hq: return Image("hq")
        case .humor: return Image("humor")
        case .horror: return Image("horror")
        case .pecasRoteiros: return Image("pecas-e-roteiros")
        case .poesia: return Image("poesia")
        case .youngAdult: return Image("young-adult")
        case .romance: return Image("romance")
        case .ficcaoCientifica: return Image("ficcao-cientifica")
        case .contos: return Image("contos")
        case .fantasia: return Image("fantasia")
        case .lgbtqia: return Image("LGBTQIA+")
        }
    }

    static func presentGenres(give categories: [String]) -> [Genre] {
        var ourGenre: [Genre] = []
        var genresRemindToCheck = Genre.allCases

        for category in filterCategories(categories) {
            let newGenreFound = genresRemindToCheck.filter { genre in
                genre.description.contains(category)
            }

            ourGenre += newGenreFound

            genresRemindToCheck = genresRemindToCheck.filter { $0 != newGenreFound.first }
        }

        return ourGenre
    }

    private static func filterCategories(_ categories: [String]) -> [String] {
        var categoriesFiltered = [String]()

        for category in categories {
            categoriesFiltered += category.components(separatedBy: " / ")
        }

        categoriesFiltered = Array(Set(categoriesFiltered))

        return categoriesFiltered
    }
}
