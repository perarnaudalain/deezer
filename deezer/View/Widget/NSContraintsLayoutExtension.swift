import UIKit

extension NSLayoutConstraint {
    /**
     * Add a method in NSLayoutConstraint to allow the multiplier modification in a constraint
     */
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
