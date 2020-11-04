import React from 'react';

import * as ReactNativeViewViewConfig from 'react-native/Libraries/Components/View/ReactNativeViewViewConfig';
import { register } from 'react-native/Libraries/Renderer/shims/ReactNativeViewConfigRegistry';

const AnimationNativeComponent = register('RSUIAnimation', () => {
  return {
    uiViewClassName: 'RSUIAnimation',
    bubblingEventTypes: {},
    directEventTypes: {},
    validAttributes: {
      ...ReactNativeViewViewConfig.validAttributes,
      type: true,
      duration: true,
    },
  };
});

export default class Animation extends React.PureComponent {
  render() {
    return (
      <AnimationNativeComponent {...this.props} />
    );
  }
}
