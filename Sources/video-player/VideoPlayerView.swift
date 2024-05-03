import SwiftUI
import AVKit
import media_player
import swiper

public struct VideoPlayerView: View {
  var videoPlayerViewHelper: VideoPlayerViewHelper {
    VideoPlayerViewHelper(player: player, url: $url, name: $name, startTime: $startTime)
  }

  @State private var isFullScreen = false

  public var swipeChanged: (SwipeModifier.Directions) -> Void = { _ in }

  public var player: MediaPlayer
  @Binding private var url: URL?
  @Binding public var name: String
  @Binding private var startTime: Double
  private var enableSwipe: Bool
  private var onMediaCompleted: (Bool) -> Void

  public init(player: MediaPlayer, url: Binding<URL?>, name: Binding<String>, startTime: Binding<Double>,
     enableSwipe: Bool = false, onMediaCompleted: @escaping (Bool) -> Void) {
    self.player = player
    self._url = url
    self._name = name
    self._startTime = startTime
    self.enableSwipe = enableSwipe
    self.onMediaCompleted = onMediaCompleted

    videoPlayerViewHelper.activatePlayer()
  }

  public var body: some View {
    GeometryReader { geometry in
      VideoPlayer(player: player.player) {
        VideoPlayerOverlay(name: $name, size: geometry.size, isFullScreen: $isFullScreen)
      }
        .fullScreen($isFullScreen)
        .if(enableSwipe) { view in
          view.onSwipe { direction in
            print("onSwipe: \(direction)")

            if direction == SwipeModifier.Directions.right {
              onMediaCompleted(false)
            } else if direction == SwipeModifier.Directions.left {
              onMediaCompleted(true)
            }
          }
        }
      .onDisappear {
        videoPlayerViewHelper.deactivatePlayer()
      }
    }
  }
}
