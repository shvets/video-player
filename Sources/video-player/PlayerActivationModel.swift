import Foundation

open class PlayerActivationModel: ObservableObject {
  @Published public var playerActivated: Bool = false

  public init() {}

  public func activated() {
    playerActivated = true
  }

  public func deactivated() {
    playerActivated = false
  }
}
