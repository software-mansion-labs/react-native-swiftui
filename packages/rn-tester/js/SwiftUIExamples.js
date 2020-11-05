import React from 'react';
import { View, Text, TextInput, StyleSheet, Switch } from 'react-native';

import { Button, Shadow, Mask, Rect, Circle, ScrollView, Image, Animation, Blur, LinearGradient } from 'react-native-swiftui';

const colors = ['black', 'blue', 'orange', 'green', 'pink', 'yellow', 'purple', 'red'];

class ExampleSection extends React.PureComponent {
  render() {
    return (
      <View style={[styles.exampleSection, this.props.style]}>
        <View style={styles.exampleSectionHeader}>
          <Text style={styles.exampleSectionHeaderText}>
            {this.props.header}
          </Text>
        </View>
        <View style={[styles.exampleSectionContent, { flexDirection: this.props.direction ?? 'row', alignItems: this.props.align ?? 'stretch' }]}>
          {this.props.children}
        </View>
      </View>
    );
  }
}

class SwiftUIExamples extends React.PureComponent {
  scrollRef = React.createRef()

  state = {
    colorIndex: 0,
    isButtonPressed: false,
    textInputValue: '',
    switchValue: false,
  }

  componentDidMount() {
    this.interval = setInterval(() => {
      const colorIndex = (this.state.colorIndex + 1) % colors.length;
      this.setState({ colorIndex });
    }, 1000);
  }

  componentWillUnmount() {
    this.interval = clearInterval(this.interval);
  }

  onPress = () => {
    this.setState({ isButtonPressed: false });
    alert('Button has been pressed');
  }

  onRandomScroll = () => {
    const scrollX = Math.round(Math.random() * 500);
    const scrollY = Math.round(Math.random() * 500);
    this.scrollRef.current.scrollTo({ x: scrollX, y: scrollY, animated: true });
  }

  onActiveStateChange = ({ nativeEvent }) => {
    this.setState({ isButtonPressed: nativeEvent.state });
  }

  onTextChange = ({ nativeEvent }) => {
    this.setState({ textInputValue: nativeEvent.text.toUpperCase() });
    console.log('text changed', nativeEvent.text);
  }

  onSwitchChange = ({ nativeEvent }) => {
    this.setState({ switchValue: nativeEvent.value });
    alert(`Switch value changed to ${nativeEvent.value}`);
  }

  render() {
    return (
      <ScrollView style={styles.scrollView} axes="both" showsIndicators={true} ref={this.scrollRef}>
        <ExampleSection header="View">
          <View style={{ width: 50, height: 70, backgroundColor: 'yellow', textAlign: 'center' }}>
            <Text style={{ color: 'black' }}>50x70</Text>
          </View>

          <View
            style={{
              width: 200,
              marginLeft: 10,
              paddingHorizontal: 5,
              paddingVertical: 15,
              borderWidth: 5,
              borderColor: 'royalblue',
              borderLeftWidth: 3,
              borderRightWidth: 1,
              backgroundColor: 'orange',
            }}>
            <Text>View with specified width, margins, border and background</Text>
          </View>
        </ExampleSection>

        <ExampleSection header="Animation">
          <Animation type="easeInOut" duration={0.5} style={{ width: 400, height: 60, justifyContent: 'center' }}>
            <View
              style={{
                flexDirection: 'row',
                justifyContent: 'center',
                alignItems: 'center',
                width: 200 + 200 * Math.random(),
                height: 30 + 30 * Math.random(),
                backgroundColor: colors[this.state.colorIndex],
                borderWidth: 1,
                borderColor: 'black',
              }}>
              <Text>View with animated changes</Text>
            </View>
          </Animation>
        </ExampleSection>

        <ExampleSection header="Text" direction="column">
          <View style={{ flexDirection: 'row', alignItems: 'flex-start', marginBottom: 10 }}>
            <Text style={{ width: 120, backgroundColor: 'pink' }} numberOfLines={6}>
              (up to 6 lines, width 120) Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
            </Text>
            <Text style={{ flex: 1, backgroundColor: 'green' }} numberOfLines={2}>
              (up to 2 lines, flex width) Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
            </Text>
          </View>
          <View style={{ flexDirection: 'row' }}>
            <Text style={{ flex: 1, textAlign: 'left', color: 'black', borderWidth: 1, borderColor: 'gray', margin: 5 }}>
              textAlign = left
            </Text>
            <Text style={{ flex: 1, textAlign: 'center', color: 'black', borderWidth: 1, borderColor: 'gray', margin: 5 }}>
              textAlign = center
            </Text>
            <Text style={{ flex: 1, textAlign: 'right', color: 'black', borderWidth: 1, borderColor: 'gray', margin: 5 }}>
              textAlign = right
            </Text>
          </View>
          <View style={{ flexDirection: 'row', marginVertical: 5 }}>
            <Text style={{ width: 170, color: 'black' }}>ellipsizeMode = head:</Text>
            <Text style={{ width: 250, color: 'black', fontStyle: 'italic' }} numberOfLines={1} ellipsizeMode="head">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</Text>
          </View>
          <View style={{ flexDirection: 'row', marginVertical: 5 }}>
            <Text style={{ width: 170, color: 'black' }}>ellipsizeMode = middle:</Text>
            <Text style={{ width: 250, color: 'black', fontStyle: 'italic' }} numberOfLines={1} ellipsizeMode="middle">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</Text>
          </View>
          <View style={{ flexDirection: 'row', marginVertical: 5 }}>
            <Text style={{ width: 170, color: 'black' }}>ellipsizeMode = tail:</Text>
            <Text style={{ width: 250, color: 'black', fontStyle: 'italic' }} numberOfLines={1} ellipsizeMode="tail">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</Text>
          </View>
        </ExampleSection>

        <ExampleSection header="Button">
          <Button onPress={this.onPress} onActiveStateChange={this.onActiveStateChange}>
            <Text style={{
              margin: 10,
              color: this.state.isButtonPressed ? 'gray' : 'black',
              fontSize: 18,
            }}>
              Press me!
            </Text>
          </Button>
          <Button onPress={this.onRandomScroll}>
            <Text style={{ margin: 10, color: 'blue', fontSize: 18 }}>
              Scroll to random
            </Text>
          </Button>
        </ExampleSection>

        <ExampleSection header="Switch">
          <Switch
            trackColor={{ false: 'red' }}
            value={this.state.switchValue}
            onChange={this.onSwitchChange} />
          <Text style={{ color: 'black', marginVertical: 6, marginHorizontal: 20 }}>
            Current value: {`${this.state.switchValue}`}
          </Text>
        </ExampleSection>

        <ExampleSection header="TextInput" direction="column">
          <TextInput
            style={{ minWidth: 150, padding: 10, marginVertical: 5, color: 'royalblue', borderWidth: 1, borderColor: 'lightgray' }}
            placeholder="Uncontrolled TextInput"
            onChange={this.onTextChange}
            onFocus={() => console.log('focus')}
            onBlur={() => console.log('blur')}
            onEndEditing={() => console.log('end editing')} />

          <TextInput
            style={{ minWidth: 150, padding: 10, marginVertical: 5, color: 'royalblue', borderWidth: 1, borderColor: 'lightgray' }}
            placeholder="Controlled TextInput"
            value={this.state.textInputValue} />
        </ExampleSection>

        <ExampleSection header="Image">
          <View style={{ alignItems: 'center' }}>
            <Text style={{ color: 'black', marginBottom: 5 }}>from external server</Text>
            <Image
              style={{ width: 156, height: 104, marginHorizontal: 10 }}
              source={{ uri: 'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/BBKHUZJ.img?h=104&w=199&m=6&q=60&u=t&o=f&l=f&x=1700&y=1854' }} />
          </View>
          <View style={{ alignItems: 'center' }}>
            <Text style={{ color: 'black', marginBottom: 5 }}>local asset</Text>
            <Image
              style={{ width: 120, height: 120, marginHorizontal: 10 }}
              source={require('./assets/bunny.png')} />
          </View>
        </ExampleSection>

        <ExampleSection header="Shapes">
          <View style={{ width: 100, height: 100, marginHorizontal: 10 }}>
            <Circle
              fill="lavender"
              stroke="purple"
              strokeWidth={7}
              strokeDashes={[16, 13]}
              strokeLineCap="round"
              radius={32} />
          </View>
          <View style={{ width: 100, height: 100, marginHorizontal: 10, borderWidth: 1, borderColor: 'lightgray' }}>
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
              <Circle fill="#7c238c" radius={10} />
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
        </ExampleSection>

        <ExampleSection header="Shadow" style={{ paddingBottom: 55 }}>
          <Shadow radius={20} offsetX={-10} offsetY={50}>
            <View style={{ margin: 10, width: 100, height: 50, backgroundColor: 'magenta' }}>
              <Text numberOfLines={3}>Rectangle with shadow</Text>
            </View>
          </Shadow>
        </ExampleSection>

        <ExampleSection header="Mask">
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
        </ExampleSection>

        <ExampleSection header="Blur">
          <Blur radius={5.0}>
            <Image
              style={{ width: 120, height: 120, marginHorizontal: 10 }}
              source={require('./assets/bunny.png')} />
          </Blur>
        </ExampleSection>

        <ExampleSection header="LinearGradient">
          <View style={{ width: 150, height: 100 }}>
            {/* This gradient fills in the entire parent's frame */}
            <LinearGradient
              colors={['#EE6352', '#59CD90', '#3FA7D6', '#FAC05E', '#F79D84']}
              locations={[0.2, 0.5, 0.6, 0.9, 1.0]}
              from="topLeft"
              to="bottomRight" />
            <Text style={{ fontSize: 18, textAlign: 'center' }}>Linear gradient inside a view</Text>
          </View>

          <View style={{ width: 90, marginLeft: 25 }}>
            <Circle radius={45}>
              {/* Linear gradient masked by circle shape */}
              <LinearGradient colors={['#CF9893', '#BC7C9C', '#A96DA3', '#7A5980', '#3B3B58']} />
              <Text style={{ textAlign: 'center' }}>Gradient in the circle</Text>
            </Circle>
          </View>
        </ExampleSection>

        <View style={{ height: 100 }} />
      </ScrollView>
    );
  }
}

const styles = StyleSheet.create({
  scrollView: {
    flex: 1,
    justifyContent: 'flex-start',
    paddingTop: 44,
    backgroundColor: 'white',
  },
  exampleSection: {
    borderTopColor: '#00000030',
    borderTopWidth: StyleSheet.hairlineWidth,
  },
  exampleSectionHeader: {
    paddingVertical: 7,
    paddingHorizontal: 10,
    backgroundColor: '#00000008',
  },
  exampleSectionHeaderText: {
    fontSize: 18,
    fontWeight: '700',
    color: 'black',
  },
  exampleSectionContent: {
    marginVertical: 10,
    marginHorizontal: 10,
  },
});

export default SwiftUIExamples;
