import UIKit

enum Colors: String {

    //  Support colors
    case supportSeparator   = "supportSeparator"
    case supportOverlay     = "supportOverlay"
    case supportNavBarBlur  = "supportNavBarBlur"

    //  Label colors
    case labelPrimary   = "labelPrimary"
    case labelSecondary = "labelSecondary"
    case labelTertiary  = "labelTertiary"
    case labelDisable   = "labelDisable"

    //  Colors
    case red        = "red"
    case green      = "green"
    case blue       = "blue"
    case gray       = "gray"
    case grayLight  = "grayLight"
    case white      = "white"

    //  Background colors
    case backIOSPrimary = "backIOSPrimary"
    case backPrimary    = "backPrimary"
    case backSecondary  = "backSecondary"
    case backElevated   = "backElevated"

    var color: UIColor { return UIColor(named: rawValue) ?? .orange}
}
