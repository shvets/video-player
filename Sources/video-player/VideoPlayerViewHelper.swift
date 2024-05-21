import SwiftUI
import AVKit
import media_player

public class VideoPlayerViewHelper<T> {
  var commandCenterManager: CommandCenterManager<T> {
    CommandCenterManager<T>(player: player, nextMedia: nextMedia, previousMedia: previousMedia, update: update)
  }

  public var player: MediaPlayer
  @Binding private var url: URL?
  @Binding public var name: String
  @Binding private var startTime: Double
  private var playImmediately: Bool
  private var stopOnLeave: Bool
  var nextMedia: () -> T?
  var previousMedia: () -> T?
  var update: (T, Double) -> Void

  public init(player: MediaPlayer, url: Binding<URL?>, name: Binding<String>, startTime: Binding<Double>,
              playImmediately: Bool = true, stopOnLeave: Bool = true,
              nextMedia: @escaping () -> T?, previousMedia: @escaping () -> T?, update: @escaping (T, Double) -> Void) {
    self.player = player
    self._url = url
    self._name = name
    self._startTime = startTime
    self.playImmediately = playImmediately
    self.stopOnLeave = stopOnLeave
    self.nextMedia = nextMedia
    self.previousMedia = previousMedia
    self.update = update
  }

  func activatePlayer() {
    if let url = url {
      player.update(url: url, startTime: startTime)

      #if os(iOS) || os(tvOS)
      setAudioSessionCategory(to: .playback)
      #endif

      commandCenterManager.start()

      if playImmediately {
        player.play()
      }

      addObserver()
    }
  }

  public func deactivatePlayer() {
    if stopOnLeave {
      player.pause()

      commandCenterManager.stop()

      #if os(iOS) || os(tvOS)
      setAudioSessionCategory(to: .ambient)
      #endif

      removeObserver()
    }
  }

  func addObserver() {
    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.player.currentItem, queue: nil) { _ in
//      player.seek(to: .zero)
//      player.play()
    }
  }

  func removeObserver() {
    NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
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

  public func reload(with url: URL) {
    player.url = url

    player.setCurrentTime(.zero)
  }
}
