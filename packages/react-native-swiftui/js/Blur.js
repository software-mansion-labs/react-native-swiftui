import React from 'react';

import * as ReactNativeViewViewConfig from 'react-native/Libraries/Components/View/ReactNativeViewViewConfig';
import { register } from 'react-native/Libraries/Renderer/shims/ReactNativeViewConfigRegistry';

const BlurNativeComponent = register('RSUIBlur', () => {
  return {
    uiViewClassName: 'RSUIBlur',
    bubblingEventTypes: {},
    directEventTypes: {},
    validAttributes: {
      ...ReactNativeViewViewConfig.validAttributes,
      radius: true,
    },
  };
});

export default class Blur extends React.PureComponent {
  render() {
    return (
      <BlurNativeComponent {...this.props} />
    );
  }
}
