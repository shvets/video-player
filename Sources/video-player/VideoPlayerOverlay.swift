import SwiftUI

public struct VideoPlayerOverlay: View {
  @Binding var name: String
  var size: CGSize
  @Binding var isFullScreen: Bool

  public var body: some View {
#if os(iOS) || os(tvOS)
    layout()
#else
  EmptyView()
#endif
  }

#if os(iOS)

  @ViewBuilder
  public func layout() -> some View {
    VStack {
      HStack {
        Spacer()

        Text(name)
          .foregroundColor(.white)
          .background(Color.black.opacity(0))

        Spacer()

        Image(systemName: "arrow.up.left.and.arrow.down.right")
          .padding(.leading, 32)
          .foregroundStyle(.white)
          .tint(.white)
          .onTapGesture {
            isFullScreen.toggle()
          }
      }

      Spacer()
    }
  }

#endif

#if os(tvOS)

  @ViewBuilder
  public func layout() -> some View {
    HStack {
      Spacer()

      Text(name)
        .foregroundColor(.white)
        .background(Color.black.opacity(0))

      Spacer()
    }
      .position(x: size.width * 0.5, y: -50)
  }

#endif
}
