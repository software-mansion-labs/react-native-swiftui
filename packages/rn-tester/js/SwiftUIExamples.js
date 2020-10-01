import React from 'react';
import { View, Text, TouchableOpacity, UIManager, NativeModules, TextInput, Switch } from 'react-native';

import Button from './swiftui/Button';
import Shadow from './swiftui/Shadow';

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
        <View style={{ marginVertical: 20, flexDirection: 'row', alignItems: 'center' }}>
          <View
            style={{
              width: 60,
              height: 60,
              borderLeftWidth: 40,
              borderLeftColor: 'white',
              backgroundColor: '#fa5637',
              marginLeft: 0,
              marginTop: 44,
            }}
          />

          <View
            style={{
              flexDirection: 'row',
              alignItems: 'center',
              width: 70,
              height: 30,
              backgroundColor: colors[this.state.colorIndex],
              borderLeftWidth: 20,
              borderLeftColor: 'green',
              marginTop: 50,
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

        <Shadow radius={20} offsetX={0} offsetY={50}>
          <View style={{ margin: 10, width: 100, height: 50, backgroundColor: 'magenta' }}>
            <Text numberOfLines={3}>Rectangle with shadow</Text>
          </View>
        </Shadow>
      </View>
    );
  }
}

export default SwiftUIExamples;
