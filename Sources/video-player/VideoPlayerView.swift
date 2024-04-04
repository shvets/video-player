import SwiftUI
import AVKit
import media_player
import swiper

public struct VideoPlayerView: View {
  @State private var isFullScreen = false

  public var swipeChanged: (SwipeModifier.Directions) -> Void = { _ in }

  private var videoPlayerViewHelper: VideoPlayerViewHelper
  private var enableSwipe: Bool
  private var onMediaCompleted: (Bool) -> Void

  public init(videoPlayerViewHelper: VideoPlayerViewHelper, enableSwipe: Bool = false, onMediaCompleted: @escaping (Bool) -> Void) {
    self.videoPlayerViewHelper = videoPlayerViewHelper
    self.enableSwipe = enableSwipe

    self.onMediaCompleted = onMediaCompleted

    videoPlayerViewHelper.activatePlayer()
  }

  public var body: some View {
    GeometryReader { geometry in
      VideoPlayer(player: videoPlayerViewHelper.player.player) {
        VideoPlayerOverlay(name: videoPlayerViewHelper.$name, size: geometry.size, isFullScreen: $isFullScreen)
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
    }
  }
}
