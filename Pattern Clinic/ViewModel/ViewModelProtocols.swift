
import UIKit

struct BrokenRule {
    var propertyName :String
    var message :String
}
protocol ViewModel {
    var brokenRules :[BrokenRule] { get set}
    var isValid :Bool { mutating get }
    var showAlertClosure: (() -> ())? { get set }
    var updateLoadingStatus: (() -> ())? { get set }
    var didFinishFetch: (() -> ())? { get set }
    var error: String? { get set }
    var isLoading: Bool { get set }
}
// Mark: Creating Generic datatype for accepting dynamic data
class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    var value: T {
        didSet {
            listener?(value)
        }
    }
    init(_ v: T) {
        value = v
    }
}

