import SwiftUI
import AVKit
import media_player
import item_navigator

public struct VideoPlayerView<T: Identifiable>: View {
  var videoPlayerViewHelper: VideoPlayerViewHelper<T> {
    VideoPlayerViewHelper<T>(player: player, navigator: navigator, url: $url, name: $name, startTime: $startTime)
  }

  @State private var isFullScreen = false

  public var player: MediaPlayer
  var navigator: ItemNavigator<T>
  var size: CGSize
  @Binding private var url: URL?
  @Binding public var name: String
  @Binding private var startTime: Double

  public init(player: MediaPlayer, navigator: ItemNavigator<T>, size: CGSize, url: Binding<URL?>,
              name: Binding<String>, startTime: Binding<Double>) {
    self.player = player
    self.navigator = navigator
    self.size = size
    self._url = url
    self._name = name
    self._startTime = startTime

    videoPlayerViewHelper.activatePlayer()
  }

  public var body: some View {
    VideoPlayer(player: player.player) {
      VideoPlayerOverlay(name: $name, size: size, isFullScreen: $isFullScreen)
    }
      .fullScreen($isFullScreen)
    .onDisappear {
      videoPlayerViewHelper.deactivatePlayer()
    }
  }
}
