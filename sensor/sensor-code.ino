#include <RFM69.h>
#include <RFM69registers.h>
#include <RFM69_ATC.h>
#include <SPI.h>

// Addresses for this node. CHANGE THESE FOR EACH NODE!
#define NETWORKID     0   // Must be the same for all nodes
#define MYNODEID      2   // My node ID
#define TONODEID      1   // Destination node ID

// RFM69 frequency, uncomment the frequency of your module:
#define FREQUENCY     RF69_915MHZ

// Use ACKnowledge when sending messages (or not):
#define USEACK        true // Request ACKs or not

// Packet sent/received indicator LED (optional):

#define LED           9 // LED positive pin
#define GND           8 // LED ground pin

// Create a library object for our RFM69HCW module:
RFM69 radio;

void setup() {
  // Open a serial port so we can send keystrokes to the module:
  Serial.begin(9600);
  Serial.print("Node ");
  Serial.print(MYNODEID,DEC);
  Serial.println(" ready");  

  // Set up the indicator LED (optional):
  pinMode(LED,OUTPUT);
  digitalWrite(LED,LOW);
  pinMode(GND,OUTPUT);
  digitalWrite(GND,LOW);

  // Initialize the RFM69HCW:
  radio.initialize(FREQUENCY, MYNODEID, NETWORKID);
  radio.setHighPower(); // Always use this for RFM69HCW
}

void loop() {
  // Set up a "buffer" for characters that we'll send:
  static char sendbuffer[62];
  static int sendlength = 0;

  // SENDING

  // In this section, we'll gather serial characters and
  // send them to the other node if we (1) get a carriage return,
  // or (2) the buffer is full (61 characters).

  // If there is any serial input, add it to the buffer:
  if (Serial.available() > 0) {
    char input = Serial.read();

    // not a carriage return
    if (input != '\r') {
      sendbuffer[sendlength] = input;
      sendlength++;
    }

    // If the input is a carriage return, or the buffer is full:
    if ((input == '\r') || (sendlength == 61)){
      // Send the packet!
      Serial.print("sending to node ");
      Serial.print(TONODEID, DEC);
      Serial.print(", message [");
      
      for (byte i = 0; i < sendlength; i++)
        Serial.print(sendbuffer[i]);
      Serial.println("]");
      // There are two ways to send packets. If you want
      // acknowledgements, use sendWithRetry():

      if (USEACK) {
        if (radio.sendWithRetry(TONODEID, sendbuffer, sendlength))
          Serial.println("ACK received!");
        else
          Serial.println("no ACK received");
      }
      
      sendlength = 0; // reset the packet
      Blink(LED,10);
    }
  }
}

// Blink an LED for a given number of ms
void Blink(byte PIN, int DELAY_MS) {
  digitalWrite(PIN,HIGH);
  delay(DELAY_MS);
  digitalWrite(PIN,LOW);
}
