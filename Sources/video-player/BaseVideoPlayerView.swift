// import SwiftUI
// import AVKit
// import media_player
//
// public struct BaseVideoPlayerView: UIViewControllerRepresentable {
//   @ObservedObject var player: MediaPlayer
//
//   public func makeUIViewController(context: Context) -> AVPlayerViewController {
//     let videoController = AVPlayerViewController()
//
//     videoController.player = player.player
//     videoController.delegate = context.coordinator
//
// #if os(iOS)
//     videoController.canStartPictureInPictureAutomaticallyFromInline = true
// #endif
//
//     return videoController
//   }
//
//   public func updateUIViewController(_ videoController: AVPlayerViewController, context: Context) {}
//
//   public func makeCoordinator() -> Coordinator {
//     Coordinator(self)
//   }
//
//   public class Coordinator: NSObject, AVPlayerViewControllerDelegate {
//     let parent: BaseVideoPlayerView
//
//     public init(_ parent: BaseVideoPlayerView) {
//       self.parent = parent
//     }
//
//     public func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
//       parent.player.pipStatus = .willStart
//     }
//
//     public func playerViewControllerDidStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
//       parent.player.pipStatus = .didStart
//     }
//
//     public func playerViewControllerWillStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
//       parent.player.pipStatus = .willStop
//     }
//
//     public func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
//       parent.player.pipStatus = .didStop
//     }
//   }
// }
