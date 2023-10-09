import SwiftUI
import media_player
import swiper

public struct PlainVideoPlayerView: View {
  private var mediaPlayerViewModifier: CommandCenterHandler {
    CommandCenterHandler(player: player, stopOnLeave: stopOnLeave, playImmediately: playImmediately,
        commandCenterManager: CommandCenterManager(player: player))
  }

  @State private var startTime: Double = .zero

  @ObservedObject private var player: MediaPlayer
  private var name: Binding<String>
  @State private var mediaSource: MediaSource
  private var stopOnLeave: Bool
  private var playImmediately: Bool
  private var enableSwipe: Bool
  private var swipeChanged: ((SwipeModifier.Directions) -> Void)?

  public init(@ObservedObject player: MediaPlayer, name: Binding<String>, mediaSource: MediaSource, stopOnLeave: Bool = true,
              playImmediately: Bool = true, enableSwipe: Bool = false,
              swipeChanged: ((SwipeModifier.Directions) -> Void)? = nil) {
    self.player = player
    self.name = name
    self._mediaSource = State(initialValue: mediaSource)
    self.stopOnLeave = stopOnLeave
    self.playImmediately = playImmediately
    self.enableSwipe = enableSwipe
    self.swipeChanged = swipeChanged
  }

  public var body: some View {
    VStack {
      videoPlayer()
    }
      .navigationTitle(name.wrappedValue)
  }

  @ViewBuilder
  public func videoPlayer() -> some View {
#if os(iOS)
    if enableSwipe {
      BaseVideoPlayerView(player: player)
        .onAppear {
          player.update(mediaSource: mediaSource, startTime: startTime)
        }
        .modifier(mediaPlayerViewModifier)
        .modifier(SwipeModifier(handler: { direction in
          if let swipeChanged = swipeChanged {
            swipeChanged(direction)
          }
        }))
        .modifier(VideoBoundsModifier())
    }
    else {
      BaseVideoPlayerView(player: player)
        .onAppear {
          player.update(mediaSource: mediaSource, startTime: startTime)
        }
        .modifier(mediaPlayerViewModifier)
        .modifier(VideoBoundsModifier())
    }
#else
    BaseVideoPlayerView(player: player)
      .onAppear {
        player.update(mediaSource: mediaSource, startTime: startTime)
      }
      .modifier(mediaPlayerViewModifier)
      .modifier(VideoBoundsModifier())
#endif
  }
}

struct PlainVideoPlayerView_Previews: PreviewProvider {
  static var previews: some View {
    PlainVideoPlayerView(player: MediaPlayer(), name: Binding.constant("name"),
        mediaSource: MediaSource(url: URL(string: "")!, name: "")
    )
  }
}