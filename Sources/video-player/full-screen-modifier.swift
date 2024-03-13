import SwiftUI

#if canImport(UIKit)

import UIKit

#endif

public struct FullScreenModifier: ViewModifier {
  @Binding private var flag: Bool

  public init(_ flag: Binding<Bool>) {
    self._flag = flag
  }

  public func body(content: Content) -> some View {
    content
      .if(flag) { view in
        view.edgesIgnoringSafeArea(.all)
      }
    
#if os(iOS) || os(tvOS)
      .if(flag) { view in
        view.navigationBarHidden(true)
      }
#endif
    
#if canImport(UIKit)
      .if(UIDevice.isAppleTV) { view in
        view.edgesIgnoringSafeArea(.all)
      }
#endif
  }
}

extension View {
  public func fullScreen(_ flag: Binding<Bool>) -> some View {
    self.modifier(FullScreenModifier(flag))
  }
}

