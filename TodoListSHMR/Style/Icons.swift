import UIKit

enum Icon: String {
    case Low = "Low"
    case Important = "Important"
    
    var image: UIImage? {return UIImage(named: rawValue)}
}
