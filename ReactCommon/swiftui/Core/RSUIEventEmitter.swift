
public enum RSUIEventPriority: Int {
  case SynchronousUnbatched = 0
  case SynchronousBatched = 1
  case AsynchronousUnbatched = 2
  case AsynchronousBatched = 3
}

@objc
public class RSUIEventEmitter: RSUIEventEmitterObjC {
  public func dispatchEvent(_ eventName: String, payload: [AnyHashable : Any] = [:], priority: RSUIEventPriority = .AsynchronousUnbatched) {
    dispatchEvent(eventName, payload: payload, priority: Int32(truncatingIfNeeded: priority.rawValue))
  }
}
