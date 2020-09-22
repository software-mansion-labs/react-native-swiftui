import React from 'react';
import { View, Text } from 'react-native';

const colors = ['black', 'blue', 'orange', 'green', 'pink', 'yellow', 'purple', 'red', 'transparent'];

class SwiftUIExamples extends React.PureComponent {
  state = {
    colorIndex: 0,
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

  render() {
    return (
      <View style={{ flex: 1, flexDirection: 'row', alignItems: 'center' }}>
            {/*<View
          style={{
            width: 200,
            height: 200,
            borderLeftWidth: 30,
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
            width: 250,
            height: 300,
            backgroundColor: 'pink',
            borderLeftWidth: 50,
            borderLeftColor: 'green',
            marginTop: 50,
            marginLeft: 30,
          }}
          >

            <Text style={{ flex: 1, marginLeft: 50, marginRight: 50, backgroundColor: 'blue', color: 'black' }} numberOfLines={3}>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
            </Text>
              </View>*/}
        <Text style={{ marginLeft: 50, marginRight: 50, backgroundColor: 'orange', color: 'white' }} numberOfLines={6}>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </Text>
      </View>
    );
  }
}

export default SwiftUIExamples;
