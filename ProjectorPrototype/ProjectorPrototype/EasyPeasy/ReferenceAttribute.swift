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
    An enum representation of the different attribute
    classes available
 */
public enum ReferenceAttribute {
    
    // Dimesion attributes
    case width
    case height
    
    // Position attributes
    case left
    case right
    case top
    case bottom
    case leading
    case trailing
    case centerX
    case centerY
    case firstBaseline
    case lastBaseline
#if os(iOS) || os(tvOS)
    case LeftMargin
    case RightMargin
    case TopMargin
    case BottomMargin
    case LeadingMargin
    case TrailingMargin
    case CenterXWithinMargins
    case CenterYWithinMargins
#endif
    
    /// Reference attribute opposite to the current one
    internal var opposite: ReferenceAttribute {
        switch self {
        case .width: return .width
        case .height: return .height
        case .left: return .right
        case .right: return .left
        case .top: return .bottom
        case .bottom:return .top
        case .leading: return .trailing
        case .trailing: return .leading
        case .centerX: return .centerX
        case .centerY: return .centerY
        case .lastBaseline: return .lastBaseline
        case .firstBaseline: return .firstBaseline
        default:
            #if os(iOS) || os(tvOS)
            switch self {
            case .LeftMargin: return .RightMargin
            case .RightMargin: return .LeftMargin
            case .TopMargin: return .BottomMargin
            case .BottomMargin: return .TopMargin
            case .LeadingMargin: return .TrailingMargin
            case .TrailingMargin: return .LeadingMargin
            case .CenterXWithinMargins: return .CenterXWithinMargins
            case .CenterYWithinMargins: return .CenterYWithinMargins
            default: return .Width // This point should never be reached
            }
            #else
            return .width // This point should never be reached
            #endif
        }
    }
    
    /// AutoLayout attribute equivalent of the current reference
    /// attribute
    internal var layoutAttribute: NSLayoutAttribute {
        switch self {
        case .width: return .width
        case .height: return .height
        case .left: return .left
        case .right: return .right
        case .top: return .top
        case .bottom:return .bottom
        case .leading: return .leading
        case .trailing: return .trailing
        case .centerX: return .centerX
        case .centerY: return .centerY
        case .lastBaseline: return .lastBaseline
        case .firstBaseline:
            #if os(iOS) || os(tvOS)
            return .FirstBaseline
            #else
            if #available(OSX 10.11, *) {
                return .firstBaseline
            }
            else {
                return .lastBaseline
            }
            #endif
        default:
            #if os(iOS) || os(tvOS)
            switch self {
            case .LeftMargin: return .LeftMargin
            case .RightMargin: return .RightMargin
            case .TopMargin: return .TopMargin
            case .BottomMargin: return .BottomMargin
            case .LeadingMargin: return .LeadingMargin
            case .TrailingMargin: return .TrailingMargin
            case .CenterXWithinMargins: return .CenterXWithinMargins
            case .CenterYWithinMargins: return .CenterYWithinMargins
            default: return .Width // This point should never be reached
            }
            #else
            return .width // This point should never be reached
            #endif
        }
    }
    
    /// Property that determines whether the constant of 
    /// the `Attribute` should be multiplied by `-1`. This
    /// is usually done for right hand `PositionAttribute`
    /// objects
    internal var shouldInvertConstant: Bool {
        switch self {
        case .width: return false
        case .height: return false
        case .left: return false
        case .right: return true
        case .top: return false
        case .bottom:return true
        case .leading: return false
        case .trailing: return true
        case .centerX: return false
        case .centerY: return false
        case .firstBaseline: return false
        case .lastBaseline: return true
        default:
            #if os(iOS) || os(tvOS)
            switch self {
            case .LeftMargin: return false
            case .RightMargin: return true
            case .TopMargin: return false
            case .BottomMargin: return true
            case .LeadingMargin: return false
            case .TrailingMargin: return true
            case .CenterXWithinMargins: return false
            case .CenterYWithinMargins: return false
            default: return false // This point should never be reached
            }
            #else
            return false // This point should never be reached
            #endif
        }
    }
    
}

#if os(iOS) || os(tvOS)
    
/**
    Extends `ReferenceAttribute` to ease the creation of
    an `Attribute` signature
 */
internal extension ReferenceAttribute {
    
    /// Signature of a `ReferenceAttribute`. Two possible values
    /// depending on the Axis the `ReferenceAttribute` applies
    var signatureString: String {
        switch self {
        case .Left, .Leading, .LeftMargin, .LeadingMargin, .Right, .Trailing, .RightMargin, .TrailingMargin, .CenterX, .CenterXWithinMargins, .Width:
            return "h_"
        case .Top, .FirstBaseline, .TopMargin, .Bottom, .LastBaseline, .BottomMargin, .CenterY, .CenterYWithinMargins, .Height:
            return "v_"
        }
    }
    
}
    
#else
    
/**
    Extends `ReferenceAttribute` to ease the creation of
    an `Attribute` signature
 */
internal extension ReferenceAttribute {
    
    /// Signature of a `ReferenceAttribute`. Two possible values
    /// depending on the Axis the `ReferenceAttribute` applies
    var signatureString: String {
        switch self {
        case .left, .leading, .right, .trailing, .centerX, .width:
            return "h_"
        case .top, .firstBaseline, .bottom, .lastBaseline, .centerY, .height:
            return "v_"
        }
    }
    
}
    
#endif
