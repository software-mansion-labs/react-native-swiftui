import React from 'react';
import { processColor } from 'react-native';

import * as ReactNativeViewViewConfig from 'react-native/Libraries/Components/View/ReactNativeViewViewConfig';
import { register } from 'react-native/Libraries/Renderer/shims/ReactNativeViewConfigRegistry';

const LinearGradientNativeComponent = register('RSUILinearGradient', () => {
  return {
    uiViewClassName: 'RSUILinearGradient',
    bubblingEventTypes: {},
    directEventTypes: {},
    validAttributes: {
      ...ReactNativeViewViewConfig.validAttributes,
      colors: { process: colors => colors.map(processColor) },
      locations: true,
      from: true,
      to: true,
    },
  };
});

export default class LinearGradient extends React.PureComponent {
  render() {
    return (
      <LinearGradientNativeComponent {...this.props} />
    );
  }
}
