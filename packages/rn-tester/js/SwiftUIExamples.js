import React from 'react';
import { View, Text, TouchableOpacity, UIManager, NativeModules, TextInput, StyleSheet, Switch } from 'react-native';

import Button from './swiftui/Button';
import Shadow from './swiftui/Shadow';
import Mask from './swiftui/Mask';
import Rect from './swiftui/Rect';
import Circle from './swiftui/Circle';

const colors = ['black', 'blue', 'orange', 'green', 'pink', 'yellow', 'purple', 'red', 'transparent'];

class SwiftUIExamples extends React.PureComponent {
  state = {
    colorIndex: 0,
    isButtonPressed: false,
    textInputValue: '',
    switchValue: false,
  }

  componentDidMount() {
    // this.interval = setInterval(() => {
    //   const colorIndex = (this.state.colorIndex + 1) % colors.length;
    //   this.setState({ colorIndex });
    // }, 500);
  }

  componentWillUnmount() {
    this.interval = clearInterval(this.interval);
  }

  onPress = () => {
    this.setState({ isButtonPressed: false });
  }

  onActiveStateChange = ({ nativeEvent }) => {
    this.setState({ isButtonPressed: nativeEvent.state });
    // console.log('active state change:', nativeEvent.state);
  }

  onTextChange = ({ nativeEvent }) => {
    this.setState({ textInputValue: nativeEvent.text.toUpperCase() });
    console.log('text changed', nativeEvent.text);
  }

  onSwitchChange = ({ nativeEvent }) => {
    this.setState({ switchValue: nativeEvent.value });
    console.log(`switch changed to ${nativeEvent.value}`);
  }

  render() {
    return (
      <View style={{ flex: 1, justifyContent: 'flex-start', paddingTop: 44, backgroundColor: 'royalblue' }}>
        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
          <View
            style={{
              width: 60,
              height: 60,
              marginLeft: 10,
              borderWidth: 4,
              borderColor: 'white',
              backgroundColor: '#fa5637',
            }}
          />

          <View
            style={{
              flexDirection: 'row',
              alignItems: 'center',
              width: 70,
              height: 30,
              backgroundColor: colors[this.state.colorIndex],
              borderWidth: 2,
              borderColor: 'green',
              marginTop: 20,
              marginLeft: 30,
            }}
          />
        </View>

        <View style={{ marginVertical: 20, flexDirection: 'row', alignItems: 'flex-start' }}>
          <View style={{ width: 50, height: 50, backgroundColor: 'yellow' }} />
          <Text style={{ maxWidth: 100, backgroundColor: 'orange', color: 'white' }} numberOfLines={6}>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
          </Text>
          <View style={{ width: 50, height: 50, backgroundColor: 'yellow' }} />
          <Text style={{ flex: 1, backgroundColor: 'green', color: 'white' }} numberOfLines={2}>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
          </Text>
          <View style={{ width: 50, height: 50, backgroundColor: 'yellow' }} />
        </View>

        <View style={{ backgroundColor: 'orange', alignItems: 'center', marginBottom: 10 }}>
          <Button style={{ backgroundColor: 'green' }} onPress={this.onPress} onActiveStateChange={this.onActiveStateChange}>
            <Text style={{
              margin: 15,
              color: this.state.isButtonPressed ? 'black' : 'white',
              fontSize: 20,
            }}>
              Press me!
            </Text>
          </Button>
        </View>

        <TextInput
          style={{ minWidth: 150, padding: 10, backgroundColor: 'white', color: 'red' }}
          placeholder="How are you doing?"
          value={this.state.textInputValue}
          onChange={this.onTextChange}
          onFocus={() => console.log('focus')}
          onBlur={() => console.log('blur')}
          onEndEditing={() => console.log('end editing')} />

        <Switch
          style={{ margin: 10 }}
          trackColor={{ false: 'red' }}
          value={this.state.switchValue}
          onChange={this.onSwitchChange} />

        <View style={{ flexDirection: 'row' }}>
          <Shadow radius={20} offsetX={-10} offsetY={50}>
            <View style={{ margin: 10, width: 100, height: 50, backgroundColor: 'magenta' }}>
              <Text numberOfLines={3}>Rectangle with shadow</Text>
            </View>
          </Shadow>

          <View style={{ width: 100, height: 100, backgroundColor: 'gray' }}>
            <Rect
              fill="pink"
              width={50}
              height={60}
              stroke="black"
              strokeWidth={4}
              strokeDashes={[3, 8]}
              strokeLineCap="round"
              offsetX={5}
              offsetY={5}
              alignment="topLeft">
              <Shadow radius={5} opacity={0.5} offsetX={5} style={StyleSheet.absoluteFill}>
                <Circle fill="#7c238c" radius={10} />
              </Shadow>
            </Rect>
            <Circle
              fill="cyan"
              stroke="black"
              strokeWidth={2}
              strokeDashes={[12, 5]}
              strokeDashPhase={-30}
              radius={25}
              offsetX={-5}
              offsetY={-5}
              alignment="bottomRight">
              <Circle radius={18} fill="white" stroke="red" strokeDashes={[1, 8]}>
                <Circle radius={8} fill="orange" stroke="green" />
              </Circle>
            </Circle>
          </View>

          <Shadow radius={2} offsetX={20} offsetY={20} style={{ marginLeft: 10 }}>
            <Mask
              shape={
                <Circle radius={20} alignment="left">
                  <Circle radius={34} alignment="right" offsetX={50} />
                </Circle>
              }>
              <View style={{ height: 50, justifyContent: 'center', backgroundColor: 'black', borderWidth: 2, borderColor: 'red' }}>
                <Text style={{ fontSize: 9 }}>View masked by circles</Text>
              </View>
            </Mask>
          </Shadow>
        </View>
      </View>
    );
  }
}

export default SwiftUIExamples;
