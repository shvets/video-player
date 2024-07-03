import SwiftUI
import AVKit
import media_player
import item_navigator

public struct VideoPlayerView<T: Identifiable>: View {
  var commandCenterManager: CommandCenterManager<T> {
    CommandCenterManager<T>(player: player, navigator: navigator)
  }

  @State private var isFullScreen = false

  public var player: MediaPlayer
  var navigator: ItemNavigator<T>
  @Binding public var name: String

  public init(player: MediaPlayer, navigator: ItemNavigator<T>, name: Binding<String>) {
    self.player = player
    self.navigator = navigator
    self._name = name
  }

  public var body: some View {
    VideoPlayer(player: player.player) {
      VideoPlayerOverlay(name: $name, isFullScreen: $isFullScreen)
    }
      .onAppear {
        activatePlayer()
      }
      .onDisappear {
        deactivatePlayer()
      }
      .fullScreen($isFullScreen)
  }

  public func activatePlayer() {
    #if os(iOS) || os(tvOS)
    setAudioSessionCategory(to: .playback)
    #endif

    commandCenterManager.start()
  }

  public func deactivatePlayer() {
    commandCenterManager.stop()

    #if os(iOS) || os(tvOS)
    setAudioSessionCategory(to: .ambient)
    #endif
  }

  #if os(iOS) || os(tvOS)
  private func setAudioSessionCategory(to value: AVAudioSession.Category) {
    let audioSession = AVAudioSession.sharedInstance()

    do {
      try audioSession.setCategory(value)
      try audioSession.setMode(AVAudioSession.Mode.default)
      //try audioSession.setMode(AVAudioSession.Mode.moviePlayback)
      try audioSession.setActive(true)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
      print("Setting category to AVAudioSessionCategoryPlayback failed.")
    }
  }
  #endif
}
