import React from 'react';
import { processColor } from 'react-native';

import * as ReactNativeViewViewConfig from 'react-native/Libraries/Components/View/ReactNativeViewViewConfig';
import { register } from 'react-native/Libraries/Renderer/shims/ReactNativeViewConfigRegistry';

const ShadowNativeComponent = register('RSUIShadow', () => {
  return {
    uiViewClassName: 'RSUIShadow',
    bubblingEventTypes: {},
    directEventTypes: {},
    validAttributes: {
      ...ReactNativeViewViewConfig.validAttributes,
      radius: true,
      offsetX: true,
      offsetY: true,
      color: { process: processColor },
    },
  };
});

export default class Shadow extends React.PureComponent {
  render() {
    return (
      <ShadowNativeComponent {...this.props} />
    );
  }
}
