// The MIT License (MIT) - Copyright (c) 2016 Carlos Vidal
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

/**
    Superclass for those `Attribute` objects that imply dimension
    constraints like width and height
 */
open class DimensionAttribute: Attribute {

    /// Whether the `NSLayoutConstraint` generated by the
    /// `Attribute` is owned by the the `createItem`
    open override var ownedByItem: Bool {
        return true
    }

}

/**
    The width of the object’s alignment rectangle
 */
open class Width: DimensionAttribute {
    
    /// `Attribute` applied to the view
    open override var createAttribute: ReferenceAttribute {
        return .width
    }

}

/**
    The height of the object’s alignment rectangle
 */
open class Height: DimensionAttribute {
    
    /// `Attribute` applied to the view
    open override var createAttribute: ReferenceAttribute {
        return .height
    }
    
}

/**
    The size of the object’s rectangle
 */
open class Size: CompoundAttribute {
    
    /**
        Initializer which creates a `CompountAttribute` instance formed
        by `Width` and `Height` attributes with `constant = 0.0`,
        `multiplier = 1.0` and `relatedBy = .Equal`
        - returns: the `CompoundAttribute` instance created
     */
    public override init() {
        super.init()
        self.attributes = [
            Width(),
            Height()
        ]
    }
    
    /**
        Initializer which creates a `CompountAttribute` instance formed
        by `Width` and `Height` attributes with `constant = value`,
        `multiplier = 1.0` and `relatedBy = .Equal`
        - parameter value: `constant` of the constraint
        - returns: the `CompoundAttribute` instance created
     */
    public override init(_ value: CGFloat) {
        super.init()
        self.attributes = [
            Width(value),
            Height(value)
        ]
    }
    
    /**
        Initializer which creates a `CompountAttribute` instance formed
        by `Width` and `Height` attributes with the `constant`,
        `multiplier` and `relatedBy` defined by the `Constant` supplied
        - parameter constant: `Constant` struct aggregating `constant`, 
        `multiplier` and `relatedBy` properties
        - returns: the `CompoundAttribute` instance created
     */
    public override init(_ constant: Constant) {
        super.init()
        self.attributes = [
            Width(constant),
            Height(constant)
        ]
    }
    
    /**
        Initializer which creates a `CompountAttribute` instance formed
        by `Width` and `Height` attributes with `constant = size.width`
        and `constant = size.height` respectively, `multiplier = 1.0` 
        and `relatedBy = .Equal`
        - parameter size: `CGSize` that sets the constants for the `Width`
        and `Height` *subattributes*
        - returns: the `CompoundAttribute` instance created
     */
    public init(_ size: CGSize) {
        super.init()
        self.attributes = [
            Width(CGFloat(size.width)),
            Height(CGFloat(size.height))
        ]
    }

}
