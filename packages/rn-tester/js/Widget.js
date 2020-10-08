import React from 'react';
import { AppRegistry, Text, View } from 'react-native';

import Rect from './swiftui/Rect';
import Circle from './swiftui/Circle';
import Shadow from './swiftui/Shadow';

class RNTesterWidget extends React.PureComponent {
  render() {
    return (
      <View
        style={{
          flex: 1,
          alignItems: 'center',
          backgroundColor: 'plum',
        }}>
        <Shadow radius={1} offsetX={3} offsetY={3} color="black">
          <Text style={{ color: 'black', fontSize: 15, alignSelf: 'center', paddingHorizontal: 9, marginTop: 20 }}>
            Hello widgets!
          </Text>
        </Shadow>
        <Rect
          fill="pink"
          width={50}
          height={60}
          stroke="black"
          strokeWidth={4}
          strokeDashes={[3, 8]}
          strokeLineCap="round"
          offsetX={15}
          offsetY={10}
          alignment="left" />
        <Circle
          fill="cyan"
          stroke="black"
          strokeWidth={2}
          strokeDashes={[12, 5]}
          strokeDashPhase={-30}
          radius={25}
          offsetX={-15}
          offsetY={10}
          alignment="right">
          <Circle radius={18} fill="white" stroke="red" strokeDashes={[1, 8]}>
            <Circle radius={8} fill="orange" stroke="green" />
          </Circle>
        </Circle>
      </View>
    );
  }
}

AppRegistry.registerComponent('RNTesterWidget', () => RNTesterWidget);
