import UIKit

protocol RootViewControllerProtocol: AnyObject {

    /// ViewDidLoad
    func viewDidLoad()
    
    func setupHeader()

    func setupLayout()
}
