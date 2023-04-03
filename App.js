import { StatusBar } from 'expo-status-bar';
import { useRef, useState } from 'react';
import { Dimensions, StyleSheet, Text, View } from 'react-native';
import { RNCamera } from 'react-native-camera'
import { ViewPropTypes } from 'deprecated-react-native-prop-types';

export default function App() {
  const [type, setStype] = useState(RNCamera.Constants.Type.back)
  const [box, setBox] = useState(null)
  const cameraRef = useRef(null)
  const width = Dimensions.get('window').width
  const height = Dimensions.get('window').height
  return (
    <View style={styles.container}>
      <Text>Open up App.js to start working on your app!</Text>
      <RNCamera 
            
        ref={cameraRef}
        style={styles.camera}
        type={type}
        // captureAudio={false}
      />







       
      
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'grey',
  },
  camera:{
    flexGrow:1,
  }
});

App.propTypes = {
  style: ViewPropTypes.style,
};