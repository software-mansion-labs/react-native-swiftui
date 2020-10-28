import React from 'react';

import * as ReactNativeViewViewConfig from 'react-native/Libraries/Components/View/ReactNativeViewViewConfig';
import { register } from 'react-native/Libraries/Renderer/shims/ReactNativeViewConfigRegistry';
import { dispatchCommand } from 'react-native/Libraries/Renderer/shims/ReactNative';

const ScrollViewNativeComponent = register('RSUIScrollView', () => {
  return {
    uiViewClassName: 'RSUIScrollView',
    bubblingEventTypes: {},
    directEventTypes: {},
    validAttributes: {
      ...ReactNativeViewViewConfig.validAttributes,
      axes: true,
      showsIndicators: true,
    },
  };
});

export default class ScrollView extends React.PureComponent {
  nativeRef = React.createRef();

  scrollTo(options) {
    dispatchCommand(
      this.nativeRef.current,
      'scrollTo',
      [options.x, options.y, options.animated ?? true],
    );
  }

  render() {
    return (
      <ScrollViewNativeComponent {...this.props} ref={this.nativeRef} />
    );
  }
}
