import UIKit

enum Icon: String {
    case Low = "Low"
    case Important = "Important"
    
    case PlusButton = "PlusButton"
    case Shevron = "Shevron"
    
    var image: UIImage? {return UIImage(named: rawValue)}
}
