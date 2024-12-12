import Foundation

extension Date {
    static func getDateInDDMMYYYY(_ date: Date?) -> String {
        let format = DateFormatter()
        format.dateStyle = .short
        if let date = date {
            let formattedDate = format.string(from: date)
            return formattedDate
        } else {
            return "Data não pode ser exibida"
        }
    }
}
