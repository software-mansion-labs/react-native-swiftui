import React from 'react';
import { StyleSheet, View } from 'react-native';

import * as ReactNativeViewViewConfig from '../../../../Libraries/Components/View/ReactNativeViewViewConfig';
import { register } from '../../../../Libraries/Renderer/shims/ReactNativeViewConfigRegistry';

const MaskNativeComponent = register('RSUIMask', () => {
  return {
    uiViewClassName: 'RSUIMask',
    bubblingEventTypes: {},
    directEventTypes: {},
    validAttributes: {
      ...ReactNativeViewViewConfig.validAttributes,
      shape: true,
    },
  };
});

export default class MaskView extends React.PureComponent {
  render() {
    const { children, shape, ...props } = this.props;

    return (
      <MaskNativeComponent {...props}>
        <View style={StyleSheet.absoluteFill}>
          {shape}
        </View>
        {children}
      </MaskNativeComponent>
    );
  }
}
