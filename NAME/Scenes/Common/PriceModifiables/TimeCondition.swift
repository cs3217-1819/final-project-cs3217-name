import Foundation

enum TimeCondition {
    case timeRange(Date, Date)
    case dayRange(Date, Date)
    case everyNDays(Int, Date, Date)
    // TODO
}
