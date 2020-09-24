
@objc
public class RSUIEventEmitter: RSUIEventEmitterObjC {
  public func dispatchEvent(_ eventName: String) {
    dispatchEvent(eventName, payload: [:])
  }
}
