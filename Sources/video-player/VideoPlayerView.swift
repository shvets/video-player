import SwiftUI
import AVKit
import media_player
import swiper

public class VideoPlayerViewHelper {
  var commandCenterManager: CommandCenterManager {
    CommandCenterManager(player: player)
  }

  public var player: MediaPlayer
  @Binding private var url: URL?
  @Binding public var name: String
  @Binding private var startTime: Double
  private var playImmediately: Bool
  private var stopOnLeave: Bool

  public init(player: MediaPlayer, url: Binding<URL?>, name: Binding<String>, startTime: Binding<Double>,
              playImmediately: Bool = true, stopOnLeave: Bool = true) {
    self.player = player
    self._url = url
    self._name = name
    self._startTime = startTime
    self.playImmediately = playImmediately
    self.stopOnLeave = stopOnLeave
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

public struct VideoPlayerView: View {
  @State private var isFullScreen = false

  public var swipeChanged: (SwipeModifier.Directions) -> Void = { _ in }

  private var videoPlayerViewHelper: VideoPlayerViewHelper
  private var enableSwipe: Bool
  private var onMediaCompleted: (Bool) -> Void

  public init(videoPlayerViewHelper: VideoPlayerViewHelper, enableSwipe: Bool = false,
              onMediaCompleted: @escaping (Bool) -> Void) {
    self.videoPlayerViewHelper = videoPlayerViewHelper
    self.enableSwipe = enableSwipe

    self.onMediaCompleted = onMediaCompleted

    videoPlayerViewHelper.activatePlayer()

    //self.parentViewActivated.deactivated()
  }

  public var body: some View {
    GeometryReader { geometry in
      VideoPlayer(player: videoPlayerViewHelper.player.player) {
        VideoPlayerOverlay(name: videoPlayerViewHelper.$name, size: geometry.size, isFullScreen: $isFullScreen)
      }
        .onDisappear {
          print("")
          //parentViewActivated.activated()
        }
        //        .onReceive(parentViewActivated.$playerActivated) { newValue in
        //          if newValue {
        //            videoPlayerViewHelper.deactivatePlayer()
        //          }
        //        }
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


// import SwiftUI
// import AVKit
// import media_player
// import swiper
//
// public struct VideoPlayerView: View {
//   var commandCenterManager: CommandCenterManager {
//     CommandCenterManager(player: player)
//   }
//
//   @State private var isFullScreen = false
//
//   public var swipeChanged: (SwipeModifier.Directions) -> Void = { _ in }
//
//   private var player: MediaPlayer
//   @Binding private var url: URL
//   @Binding private var name: String
//   @Binding private var startTime: Double
//   private var playImmediately: Bool
//   private var stopOnLeave: Bool
//   private var enableSwipe: Bool
//   var parentViewActivated: PlayerActivationModel
//   private var onMediaCompleted: (Bool) -> Void
//
//   public init(player: MediaPlayer, url: Binding<URL>, name: Binding<String>, startTime: Binding<Double>,
//               playImmediately: Bool = true, stopOnLeave: Bool = true, enableSwipe: Bool = false,
//               parentViewActivated: PlayerActivationModel, onMediaCompleted: @escaping (Bool) -> Void) {
//     self.player = player
//     self._url = url
//     self._name = name
//     self._startTime = startTime
//     self.playImmediately = playImmediately
//     self.stopOnLeave = stopOnLeave
//     self.enableSwipe = enableSwipe
//     self.parentViewActivated = parentViewActivated
//
//     self.onMediaCompleted = onMediaCompleted
//
//     activatePlayer()
//
//     self.parentViewActivated.deactivated()
//   }
//
//   public var body: some View {
//     GeometryReader { geometry in
//       VideoPlayer(player: player.player) {
//         VideoPlayerOverlay(name: $name, size: geometry.size, isFullScreen: $isFullScreen)
//       }
//         .onReceive(parentViewActivated.$playerActivated) { newValue in
//           if newValue {
//             deactivatePlayer()
//           }
//         }
//         .fullScreen($isFullScreen)
//         .if(enableSwipe) { view in
//           view.onSwipe { direction in
//             print("onSwipe: \(direction)")
//
//             if direction == SwipeModifier.Directions.right {
//               onMediaCompleted(false)
//             } else if direction == SwipeModifier.Directions.left {
//               onMediaCompleted(true)
//             }
//           }
//         }
//     }
//   }
//
//   func activatePlayer() {
//     player.update(url: url, startTime: startTime)
//
// #if os(iOS) || os(tvOS)
//     setAudioSessionCategory(to: .playback)
// #endif
//
//     commandCenterManager.start()
//
//     if playImmediately {
//       player.play()
//     }
//
//     addObserver()
//   }
//
//   func deactivatePlayer() {
//     if stopOnLeave {
//       player.pause()
//
//       commandCenterManager.stop()
//
// #if os(iOS) || os(tvOS)
//       setAudioSessionCategory(to: .ambient)
// #endif
//
//       removeObserver()
//     }
//   }
//
//   func addObserver() {
//     NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.player.currentItem, queue: nil) { _ in
// //      player.seek(to: .zero)
// //      player.play()
//     }
//   }
//
//   func removeObserver() {
//     NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
//   }
//
// #if os(iOS) || os(tvOS)
//   private func setAudioSessionCategory(to value: AVAudioSession.Category) {
//     let audioSession = AVAudioSession.sharedInstance()
//
//     do {
//       try audioSession.setCategory(value)
//       try audioSession.setMode(AVAudioSession.Mode.default)
//       //try audioSession.setMode(AVAudioSession.Mode.moviePlayback)
//       try audioSession.setActive(true)
//       try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//     } catch {
//       print("Setting category to AVAudioSessionCategoryPlayback failed.")
//     }
//   }
// #endif
//
//   public func reload(with url: URL) {
//     player.url = url
//
//     player.setCurrentTime(.zero)
//   }
// }
