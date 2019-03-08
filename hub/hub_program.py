import socket
import fcntl
import struct

import time
import busio
from digitalio import DigitalInOut, Direction, Pull
import board

# Import the SSD1306 module.
import adafruit_ssd1306
# Import the RFM69 radio module.
import adafruit_rfm69

def get_ip(ifname):
  s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  return socket.inet_ntoa(fcntl.ioctl(s.fileno(), 0x8915, struct.pack('256s', ifname[:15]))[20:24])

# Create the I2C interface.
i2c = busio.I2C(board.SCL, board.SDA)
 
# 128x32 OLED Display
display = adafruit_ssd1306.SSD1306_I2C(128, 32, i2c, addr=0x3c)
# Clear the display.
display.fill(0)
display.show()
width = display.width
height = display.height

# Configure Packet Radio
CS = DigitalInOut(board.CE1)
RESET = DigitalInOut(board.D25)
spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)
rfm69 = adafruit_rfm69.RFM69(spi, CS, RESET, 915.0)
prev_packet = None

while True:
  # Display the IP address
  eth_ip = get_ip('eth0')
  display.text('IP: ' + eth_up, 0, 0, 1)
  
  # Attempt to set up the RFM69 Module
  try:
    rfm69 = adafruit_rfm69.RFM69(spi, CS, RESET, 915.0)
    display.text('RFM69: Detected', 0, 0, 1)
  except RuntimeError:
    # Thrown on version mismatch
    display.text('RFM69: ERROR', 0, 0, 1)
  
  packet = None
  
  # check for packet rx
  packet = rfm69.receive()
  if packet is None:
    display.show()
    display.text('- Waiting for PKT -', 15, 20, 1)
  else:
    # Display the packet text and rssi
    display.fill(0)
    prev_packet = packet
    packet_text = str(prev_packet, "utf-8")
    display.text('RX: ', 0, 0, 1)
    display.text(packet_text, 25, 0, 1)
    time.sleep(1)
      
  display.show()
  time.sleep(0.1)
