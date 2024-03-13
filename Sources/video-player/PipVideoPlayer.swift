// import SwiftUI
// import AVKit
// import Combine
// import media_player
//
// public struct PipVideoPlayer: UIViewRepresentable {
//   @ObservedObject var player: MediaPlayer
//
//   public func makeUIView(context: Context) -> PlayerView {
//     let view = PlayerView()
//
//     view.player = player.player
//     context.coordinator.setController(view.playerLayer)
//
//     return view
//   }
//
//   public func updateUIView(_ uiView: PlayerView, context: Context) {}
//
//   public func makeCoordinator() -> Coordinator {
//     Coordinator(self)
//   }
//
//   public class Coordinator: NSObject, AVPictureInPictureControllerDelegate {
//     private let parent: PipVideoPlayer
//     private var controller: AVPictureInPictureController?
//     private var cancellable: AnyCancellable?
//
//     public init(_ parent: PipVideoPlayer) {
//       self.parent = parent
//       super.init()
//
//       cancellable = parent.player.$isInPipMode
//         .sink { [weak self] in
//           guard let self = self,
//                 let controller = self.controller
//           else {
//             return
//           }
//
//           if $0 {
//             if controller.isPictureInPictureActive == false {
//               controller.startPictureInPicture()
//             }
//           } else if controller.isPictureInPictureActive {
//             controller.stopPictureInPicture()
//           }
//         }
//     }
//
//     public func setController(_ playerLayer: AVPlayerLayer) {
//       controller = AVPictureInPictureController(playerLayer: playerLayer)
//
// #if os(iOS)
//       controller?.canStartPictureInPictureAutomaticallyFromInline = true
// #endif
//
//       controller?.delegate = self
//     }
//
//     public func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
//       parent.player.isInPipMode = true
//     }
//
//     public func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
//       parent.player.isInPipMode = false
//     }
//   }
// }
