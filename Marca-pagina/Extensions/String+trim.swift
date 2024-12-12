import Foundation

extension String {
    func trim() -> String {
        let trimmedText = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedText
    }
}
