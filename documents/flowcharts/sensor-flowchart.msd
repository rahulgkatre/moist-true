#//# --------------------------------------------------------------------------------------
#//# Created using Sequence Diagram for Mac
#//# https://www.macsequencediagram.com
#//# https://itunes.apple.com/gb/app/sequence-diagram/id1195426709?mt=12
#//# --------------------------------------------------------------------------------------
box "Node networkedSensor"	
	participant "Device radioTransceiver" as transceiver
	participant "Device moistureSensor" as sensor
	participant "Controller arduinoProMini" as arduino
end box

loop void main()
	arduino -> arduino: void enterActionState()
	note right of arduino
		"Enter the action state.\nThis increases power draw."
	end note
	arduino -> sensor: double getMoistureData()
	note right of sensor
		"Check the current moisture reading from the sensor.\nReturn the current moisture reading."
	end note	
	
	arduino -> transceiver: void sendDataPacket(requestACK = true)
	note right of transceiver				
		"Transmit the data packet with a network ID, addressed to the base station's node ID.\nContinue transmitting until an acknowledgement is received (built-in behavior)."
	end note	
	
	arduino -> arduino: void enterPowerDownSleepState()
	note right of arduino
		"Enter power-down sleep state."	end note
end