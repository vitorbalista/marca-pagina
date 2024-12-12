struct DescriptionResponse: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ISBNKey.self)

        var styles: [Item] = []
        for key in container.allKeys {
            let nested = try container.nestedContainer(keyedBy: ISBNKey.self,
                                                       forKey: key)

            let details = try nested.decode(Details.self, forKey: .details)

            styles.append(Item(name: key.stringValue,
                               details: details))
        }

        self.descriptionStyles = styles
    }

    struct ISBNKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }

        static let details = ISBNKey(stringValue: "details")!
    }

    let descriptionStyles: [Item]
}

struct Item: Codable {
    let name: String
    let details: Details
}

struct Description: Codable {
    let type: String
    let value: String
}

struct Details: Codable, Equatable {
    var description: String?

    enum DetailsKey: CodingKey {
        case description
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DetailsKey.self)
        do {
            let description = try values.decode(String.self, forKey: .description)
            self.description = description
        } catch {
            do {
                let descriptionStructure = try values.decode(Description.self, forKey: .description)
                self.description = descriptionStructure.value
            } catch {
                self.description = nil
            }
        }
    }
}
