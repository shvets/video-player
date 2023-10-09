import SwiftUI
import AVKit
import media_player
import swiper

public struct VideoPlayerView: View {
  private var mediaPlayerViewModifier: CommandCenterHandler {
    CommandCenterHandler(player: player, stopOnLeave: stopOnLeave, playImmediately: playImmediately,
        commandCenterManager: CommandCenterManager(player: player))
  }

  @ObservedObject private var player: MediaPlayer
  @Binding private var mediaSource: MediaSource
  private var stopOnLeave: Bool = true
  private var displayPip: Bool = false
  private var enableSwipe: Bool = false
  private var playImmediately: Bool = true
  @Binding private var startTime: Double

  public var swipeChanged: (SwipeModifier.Directions) -> Void = {_ in }

  public init(@ObservedObject player: MediaPlayer, mediaSource: Binding<MediaSource>, stopOnLeave: Bool = true, displayPip: Bool = false,
              enableSwipe: Bool = false, playImmediately: Bool = true, startTime: Binding<Double>,
              swipeChanged: @escaping (SwipeModifier.Directions) -> Void = {_ in }) {
    self.player = player
    self._mediaSource = mediaSource
    self.stopOnLeave = stopOnLeave
    self.displayPip = displayPip
    self.enableSwipe = enableSwipe
    self.playImmediately = playImmediately
    self._startTime = startTime
    self.swipeChanged = swipeChanged
  }

  public var mediaPlayer: MediaPlayer {
    player
  }

#if os(iOS)
  public var body: some View {
    if displayPip {
      videoPlayerWithPip()
    }
    else {
      videoPlayer()
    }
  }

  @ViewBuilder
  public func videoPlayerWithPip() -> some View {
    VStack {
      VStack {
        PipVideoPlayer(player: player)
            //.overlay(VideoPlayerControlsView(player: player), alignment: .bottom)
          .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
      }
        .padding()
        .overlay(player.isInPipMode ?
            Button("Title") {
              reload(with: mediaSource)

              player.play()
            } : nil)

      Button(action: {
        withAnimation {
          player.isInPipMode.toggle()
        }

      }, label: {
        if player.isInPipMode {
          Label("Stop PiP", systemImage: "pip.exit")
        } else {
          Label("Start PiP", systemImage: "pip.enter")
        }
      })
        .padding()
    }
      .padding()
      .overlay(VideoPlayerControlsView(player: player, duration: player.duration), alignment: .bottom)
      .onAppear {
        player.update(mediaSource: mediaSource, startTime: startTime)
      }
      .modifier(mediaPlayerViewModifier)
  }

  @ViewBuilder
  public func videoPlayer() -> some View {
    //      if #available(iOS 14.0, *) {
//        VideoPlayer(player: player.player)
//          .modifier(MediaPlayerViewModifier(player: player, url: url, stopOnLeave: stopOnLeave))
//          .modifier(SwipeModifier(handler: { direction in
//            swipeChanged(direction)
//          }))
//      }
//      else {
    if enableSwipe {
      //BaseVideoPlayerView(player: player)
      VideoPlayer(player: player.player)
        .onAppear {
          player.update(mediaSource: mediaSource, startTime: startTime)
        }
        .modifier(mediaPlayerViewModifier)
        .modifier(VideoBoundsModifier())
        .modifier(SwipeModifier(handler: { direction in
          swipeChanged(direction)
        }))
    }
    else {
      //BaseVideoPlayerView(player: player)
//        .modifier(MediaPlayerViewModifier(player: player, url: url, startTime: startTime, stopOnLeave: stopOnLeave,
//            playImmediately: playImmediately, commandCenterManager: CommandCenterManager(player: player)))
//        .modifier(VideoBoundsModifier())

        VideoPlayer(player: player.player)
          .onAppear {
            player.update(mediaSource: mediaSource, startTime: startTime)
          }
          .modifier(mediaPlayerViewModifier)
        .modifier(VideoBoundsModifier())
    }

//      VideoPlayer(player: player.player)
//      //PipVideoPlayer(player: player)
//        //.overlay(VideoPlayerControlsView(player: player), alignment: .bottom)
//        .modifier(MediaPlayerViewModifier(player: player, url: url, stopOnLeave: stopOnLeave))
//        //.edgesIgnoringSafeArea(.all)
//        .modifier(SwipeModifier(handler: { direction in
//          swipeChanged(direction)
//        }))
//        .onSwiped(.up) {
//          swipeChanged(.up)
//        }
//        .onSwiped(.down) {
//          swipeChanged(.down)
//        }
//      VStack {
//        Text(player.pipStatus.rawValue)
//          .bold()
//          .frame(maxWidth: .infinity)
//          //.background(Color.green)
//
//        AVVideoPlayer(player: player)
//          .overlay(VideoPlayerControlsView(player: player), alignment: .bottom)
//          .modifier(MediaPlayerViewModifier(player: player, url: url, stopOnLeave: stopOnLeave))
//      }
  }

#else

  public var body: some View {
    videoPlayer()
  }

  @ViewBuilder
  public func videoPlayer() -> some View {
    if enableSwipe {
      VideoPlayer(player: player.player)
        .onAppear {
          player.update(mediaSource: mediaSource, startTime: startTime)
        }
        .modifier(mediaPlayerViewModifier)
        .modifier(VideoBoundsModifier())
        .modifier(SwipeModifier(handler: { direction in
          swipeChanged(direction)
        }))
        .onMoveCommand { direction in
          print("onMoveCommand: \(direction)")
          if direction == .up {
            swipeChanged(SwipeModifier.Directions.up)
          }
          else if direction == .down {
            swipeChanged(SwipeModifier.Directions.down)
          }
        }
    }
    else {
      VideoPlayer(player: player.player)
        .onAppear {
          player.update(mediaSource: mediaSource, startTime: startTime)
        }
        .modifier(mediaPlayerViewModifier)
        .modifier(VideoBoundsModifier())
    }
  }

#endif

  public func reload(with mediaSource: MediaSource) {
    self.mediaSource = mediaSource

    player.mediaSource = mediaSource
    player.setCurrentTime(.zero)
  }
}

struct VideoPlayerView_Previews: PreviewProvider {
  static var previews: some View {
    VideoPlayerView(
        player: MediaPlayer(),
        mediaSource: Binding.constant(MediaSource(url: URL(string: "https://www.etvnet.com")!, name: "")),
        stopOnLeave: false,
        displayPip: false, startTime: Binding.constant(0.0)
    )
  }
}
