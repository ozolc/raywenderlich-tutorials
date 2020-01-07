import Combine
import SwiftUI
import PlaygroundSupport

enum TimeoutError: Error {
    case timeOut
}

let subject = PassthroughSubject<Void, TimeoutError>()

let timedOutSubject = subject.timeout(.seconds(5), scheduler: DispatchQueue.main, customError: { .timeOut })

let timeline = TimelineView(title: "Button taps")

let view = VStack(spacing: 100) {
  Button(action: { subject.send() }) {
    Text("Press me within 5 seconds")
  }
  timeline
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view)

timedOutSubject.displayEvents(in: timeline)
