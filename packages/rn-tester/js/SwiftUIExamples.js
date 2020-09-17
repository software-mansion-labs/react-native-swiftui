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
      <View style={{ flex: 1 }}>
        <View
          style={{
            width: 200,
            height: 200,
            borderLeftWidth: 30,
            borderColor: 'white',
            backgroundColor: '#fa5637',
            marginLeft: 0,
            marginTop: 44,
          }}
        />

        <View
          style={{
            width: 250,
            height: 300,
            backgroundColor: 'pink',
            borderLeftWidth: 50,
            borderColor: 'green',
            marginTop: 50,
            marginLeft: 30,
          }}
          accessibilityHint="hint"
          accessibilityLabel="label"
          dupa="dupa"
          >
            <View style={{ width: 50, height: 50, marginTop: 50, backgroundColor: 'blue' }} />
            <Text style={{ color: 'yellow' }}>test</Text>
        </View>
      </View>
    );
  }
}

export default SwiftUIExamples;
