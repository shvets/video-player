import AVFoundation
import UIKit

public class PlayerView: UIView {
  override public static var layerClass: AnyClass {
    AVPlayerLayer.self
  }

  var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }

  var player: AVPlayer? {
    get {
      playerLayer.player
    }
    set {
      playerLayer.videoGravity = .resizeAspectFill
      playerLayer.player = newValue
    }
  }
}
