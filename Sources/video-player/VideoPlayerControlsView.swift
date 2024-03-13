// import SwiftUI
// import media_player
//
// public struct VideoPlayerControlsView: View {
//   @ObservedObject var player: MediaPlayer
//   @State var duration: Double?
//
//   public var body: some View {
//     HStack {
//       playButton()
//
// #if os(iOS)
//       slider()
// #endif
//     }
//       .padding()
//       .background(.thinMaterial)
//   }
//
//   @ViewBuilder
//   private func playButton() -> some View {
//     if player.isPlaying == false {
//       Button(action: {
//         player.player.play()
//       }, label: {
//         Image(systemName: "play.circle")
//           .imageScale(.large)
//       })
//     } else {
//       Button(action: {
//         player.player.pause()
//       }, label: {
//         Image(systemName: "pause.circle")
//           .imageScale(.large)
//       })
//     }
//
//     //      Button(action: {
// //        withAnimation {
// //          player.isInPipMode.toggle()
// //        }
// //      }, label: {
// //        if player.isInPipMode {
// //          Label("Stop PiP", systemImage: "pip.exit")
// //        } else {
// //          Label("Start PiP", systemImage: "pip.enter")
// //        }
// //      })
// //        .padding()
//   }
//
// #if os(iOS)
//   @ViewBuilder
//   private func slider() -> some View {
//     if let duration = duration {
//       Slider(value: $player.currentTime, in: 0...duration, onEditingChanged: { isEditing in
//         player.isEditingCurrentTime = isEditing
//       })
//     }
//     else {
//       Spacer()
//     }
//   }
//
// #endif
// }
//
