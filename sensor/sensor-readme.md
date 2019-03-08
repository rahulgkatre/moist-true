# Sensor

This directory contains the code that will run on each of the Arduino-based deployed sensors in this network.

### Useful links:

- [RFM69HCW Hookup Guide](https://learn.sparkfun.com/tutorials/rfm69hcw-hookup-guide/running-the-example-code)
- [RFM69HCW GitHub Repository Download](https://github.com/sparkfun/RFM69HCW_Breakout/archive/master.zip)

### Other information:

The packet being transmitted should have this format before being converted into bytes for transmission:

```<senderID,moistureData>```

`senderID` is a number greater than 0 but less than (excluding) 255. This number is assigned at the beginning of the program, and is different for each sensor in the network. `moistureData` represents the reading of the moisture sensor. When this message is transmitted, the hub will receive this data and look for the less-than sign, comma, and greater-than sign as separating characters. It will also add the timestamp of when the data was received by the hub.
