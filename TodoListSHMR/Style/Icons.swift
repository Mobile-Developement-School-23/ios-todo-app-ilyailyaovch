import UIKit

enum Icon: String {
    case Low = "Low"
    case Important = "Important"

    case PlusButton = "PlusButton"
    case Shevron = "Shevron"

    case CircleCompleted = "CircleCompleted"
    case CircleEmpty = "CircleEmpty"
    case CircleImportant = "CircleImportant"

    var image: UIImage? {return UIImage(named: rawValue)}
}
