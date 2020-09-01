import React from 'react';
import { View, Text } from 'react-native';

const colors = ['black', 'blue', 'orange', 'green', 'pink', 'yellow', 'purple', 'red', 'transparent'];

class SwiftUIExamples extends React.PureComponent {
  state = {
    colorIndex: 0,
  }

  componentDidMount() {
    this.interval = setInterval(() => {
      const colorIndex = (this.state.colorIndex + 1) % colors.length;
      this.setState({ colorIndex });
    }, 500);
  }

  componentWillUnmount() {
    this.interval = clearInterval(this.interval);
  }

  render() {
    return (
      <View
        style={{ width: 300, height: 400, backgroundColor: 'blue', alignSelf: 'center', marginTop: 100  }}
        accessibilityLabel="test"
        accessibilityHint={colors[this.state.colorIndex]}
      >
        <Text>SwiftUIExamples</Text>
      </View>
    );
  }
}

export default SwiftUIExamples;
