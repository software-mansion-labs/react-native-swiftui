
# react-native-swiftui

This project is to research what we can do to take advantage of using SwiftUI as a replacement for UIKit being the iOS native framework used by React Native to render user interfaces. Especially, it would make it possible to use React Native on other Apple platforms such as macOS, watchOS, tvOS and iOS widgets.

## Reimplemented React Native components

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
  - [x] `textAlign` (no `justify` support)
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

### Switch

- Props
  - [x] `value`
  - [x] partially `trackColor` (only `false` state is supported by SwiftUI yet)
- Events
  - [x] `onChange`

### ScrollView

- A lot of properties known from `UIScrollView` are missing in SwiftUI, so we have our own `ScrollView` component.
- There is no convenient way to get `onScroll` event other than just adding drag gesture.
- Scroll to specified point within the view is not provided yet. However, as it let us scroll to a subview with specified ID, we can omit this limitation by rendering empty points filling the entire axis with an ID being its (X,Y) position which is how `scrollTo` command is implemented.
- Props
  - [x] `axes` that takes `vertical`/`horizontal`/`both` as an argument.
  - [x] `showsIndicators` — as opposed to `UIScrollView`, for 2-directional scroll views, we cannot specify different arguments for specific axis.
- Commands
  - `scrollTo(options: { y: number, animated: boolean })` — works only for vertical scrolls, as it would be a significant performance hit in the current implementation to support both axes.

### Image

- Implemented only for network assets.
- Only `source` property is supported. Accepts the same value types as `Image` from React Native.

## Graphical Effects

### Shadow

Adds a shadow with given `radius`, `offsetX`, `offsetY`, `opacity` and `color` to children views.

### Mask

Masks children views using the alpha channel of the views provided by `shape` prop.

## Shapes

SVG-like shape components. Shapes are not managed by Yoga which means they have their own layouting mechanism (configurable with `alignment`, `offsetX` and `offsetY` props) that makes them positioned absolutely to the parent view.
As opposed to SVG, our shapes can contain children.

Common shape props: `fill`, `alignment`, `offsetX`, `offsetY`, `stroke`, `strokeWidth`, `strokeLineCap`, `strokeLineJoin`, `strokeDashes`, `strokeDashPhase`.

### Rect

Additional props: `width`, `height`

### Circle

Additional props: `radius`
