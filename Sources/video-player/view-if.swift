import SwiftUI

extension View {
  @ViewBuilder
  public func `if`<T>(_ condition: Bool, transform: (Self) -> T) -> some View where T : View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}
