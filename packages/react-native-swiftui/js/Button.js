import React from 'react';

import * as ReactNativeViewViewConfig from 'react-native/Libraries/Components/View/ReactNativeViewViewConfig';
import { register } from 'react-native/Libraries/Renderer/shims/ReactNativeViewConfigRegistry';

const ButtonNativeComponent = register('RSUIButton', () => {
  return {
    uiViewClassName: 'RSUIButton',
    bubblingEventTypes: {},
    directEventTypes: {
      topPress: {
        registrationName: 'onPress',
      },
      topActiveStateChange: {
        registrationName: 'onActiveStateChange',
      },
    },
    validAttributes: {
      ...ReactNativeViewViewConfig.validAttributes,
    },
  };
});

class Button extends React.PureComponent {
  render() {
    return <ButtonNativeComponent {...this.props} />;
  }
}

export default Button;
