import React from 'react';
import { processColor, StyleSheet } from 'react-native';

import * as ReactNativeViewViewConfig from 'react-native/Libraries/Components/View/ReactNativeViewViewConfig';
import { register } from 'react-native/Libraries/Renderer/shims/ReactNativeViewConfigRegistry';

const RectNativeComponent = register('RSUIRect', () => {
  return {
    uiViewClassName: 'RSUIRect',
    bubblingEventTypes: {},
    directEventTypes: {},
    validAttributes: {
      ...ReactNativeViewViewConfig.validAttributes,
      fill: { process: processColor },
      width: true,
      height: true,
      stroke: { process: processColor },
      strokeWidth: true,
      strokeDashes: true,
      strokeDashPhase: true,
      strokeLineCap: true,
      strokeLineJoin: true,
      offsetX: true,
      offsetY: true,
      alignment: true,
    },
  };
});

export default class ShadowView extends React.PureComponent {
  render() {
    return (
      <RectNativeComponent {...this.props} style={StyleSheet.absoluteFill} />
    );
  }
}
