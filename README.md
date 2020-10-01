
# react-native-swiftui

This project is to research what we can do to take advantage of using SwiftUI as a replacement for UIKit being the iOS native framework used by React Native to render user interfaces. Especially, it would make it possible to use React Native on other Apple platforms such as macOS, watchOS, tvOS and iOS widgets.

## Implemented components

### View

- [x] Applying layout metrics calculated by Yoga from provided position-related styles
- Other styles
  - [x] `backgroundColor`
  - [x] `color`
  - [x] `opacity`
  - [x] `borderLeft` (`borderLeftWidth` and `borderLeftColor`)

### Text

- Styles excluding these inherited from `View`
  - [x] `fontSize`
- Props
  - [x] `numberOfLines` prop
  - [ ] `ellipsizeMode` prop
    - [x] `head`
    - [x] `center`
    - [x] `tail`
    - [ ] `clip` (no such equivalent in SwiftUI, but it can be implemented the other way)

### Button

- React Native's button heavily depends on Touchables relying on responder events that might be tricky to reimplement, so we have our own `Button` component instead.
- Events
  - [x] `onPress`
  - [x] `onActiveStateChange`

### TextInput

- Styles inherited from `View`
- Props
  - [x] `placeholder`
  - [x] `value`
  - [x] partially `multiline`, read more below
- Events
  - [x] `onChange`
  - [x] `onFocus`
  - [x] `onBlur`
  - [x] `onEndEditing`
- SwiftUI's `TextField` doesn't provide much functionalities yet. Under the hood it still uses `UITextField` from `UIKit` so hopefully it will be improved soon. So far it isn't yet possible to:
  - Focus/blur on demand
  - Change tappable area — the default area is very narrow and doesn't include given padding
  - Get cursor position
  - Read text selection
  - For multiline input we can use `TextEditor` however it doesn't meet our requirements even more as it doesn't support any events and placeholder text.
