import Foundation

struct ReadingGoals {

    let months: [String]
    let goals: [Int]
    let achievement: [Int]

    init(months: [String],
         goals: [Int] = Array(repeating: 12, count: 6),
         achievement: [Int] = Array(repeating: 0, count: 6)
    ) {
        self.months = months
        self.goals = goals
        self.achievement = achievement
    }
}
