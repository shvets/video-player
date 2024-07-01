import SwiftUI

public struct VideoPlayerOverlay: View {
  @Binding var name: String
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
    GeometryReader { geometry in
      HStack {
        Spacer()

        Text(name)
          .foregroundColor(.white)
          .background(Color.black.opacity(0))

        Spacer()
      }
        .position(x: geometry.size.width * 0.5, y: -50)
    }
  }

#endif
}
