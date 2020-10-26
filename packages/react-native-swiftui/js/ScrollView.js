import React from 'react';

import * as ReactNativeViewViewConfig from 'react-native/Libraries/Components/View/ReactNativeViewViewConfig';
import { register } from 'react-native/Libraries/Renderer/shims/ReactNativeViewConfigRegistry';

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
  render() {
    return (
      <ScrollViewNativeComponent {...this.props} />
    );
  }
}
