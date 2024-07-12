import SwiftUI
import swift_ui_commons

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
  }
}

extension View {
  public func fullScreen(_ flag: Binding<Bool>) -> some View {
    self.modifier(FullScreenModifier(flag))
  }
}

