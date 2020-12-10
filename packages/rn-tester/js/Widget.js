import React from 'react';
import { AppRegistry, StyleSheet, Text, View } from 'react-native';

import { Shadow, Image, LinearGradient } from 'react-native-swiftui';

export default class RNTesterWidget extends React.PureComponent {
  render() {
    return (
      <View style={{ flex: 1, alignItems: 'stretch' }} {...this.props}>
        <View style={StyleSheet.absoluteFill}>
          <LinearGradient
            colors={['#E9D758', '#FF8552']}
            from="topLeft"
            to="bottomRight" />
        </View>
        <View style={{ marginTop: 20, paddingHorizontal: 15 }}>
          <Shadow radius={3} offsetX={3} offsetY={3} color="black">
            <Text style={{ color: 'black', fontSize: 15, fontWeight: 'bold', textAlign: 'center' }}>
              SwiftUI Widget
            </Text>
          </Shadow>
        </View>
        <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
          <Image
            style={{ width: 70, height: 70, marginHorizontal: 5 }}
            source={require('./assets/react-native.png')} />
          <Image
            style={{ width: 70, height: 70, marginHorizontal: 5 }}
            source={require('./assets/swiftui.png')} />
        </View>
      </View>
    );
  }
}

AppRegistry.registerComponent('RNTesterWidget', () => RNTesterWidget);
