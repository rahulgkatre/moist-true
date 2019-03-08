#//# --------------------------------------------------------------------------------------
#//# Created using Sequence Diagram for Mac
#//# https://www.macsequencediagram.com
#//# https://itunes.apple.com/gb/app/sequence-diagram/id1195426709?mt=12
#//# --------------------------------------------------------------------------------------
box "Node hub"
	participant "Device transceiverDisplayBonnet" as bonnet
	participant "Controller raspberryPi" as pi
end box


loop main()
	loop waitForNetworkConnection()
		pi -> pi: boolean checkNetworkConnection()
		note right of pi
			"Check the eth0 for an IP adress.
		end note
				
		alt checkNetworkConnection() is true
			pi -> bonnet: void displayIPAddress()
			note right of bonnet
				"If there is an IP address, display it on the OLED."
			end note
			
			pi -> pi: break
			note right of pi
				"Exit the loop."
			end note
		else checkNetworkConnection() is false
			pi -> bonnet: void displayDisconnectedMessage()
			note right of bonnet
				"Else, display a disconnected message on the OLED."
			end note
			
			pi -> pi: continue
			note right of pi
				"Continue waiting for a network."
			end note
		end
	end
	
	alt dataReceived is true
		note right of bonnet
			"Wait until a packet is received."
		end note
		
		pi -> pi: RawData unpackPacket()
		note right of pi
			"Unpack the packet to get a decimal and sender ID.\nStore this data and a timestamp in an object."
		end note
		
		pi -> bonnet: void displayReceivedMessage()
		note right of bonnet
			"Display a message on the OLED stating that data has been received."
		end note
		
		pi -> bonnet: void sendACKMessage()
		note right of bonnet
			"Send a message to the sender acknowledging receipt of the packet.
		end note	
			
		
		pi -> pi: void addDataToTable()
		note right of pi
			"Add the decimal, sender ID, and timestamp to a table."
		end note
		
		pi -> pi: void graphAndPublishData()
		note right of pi
			"Update the plot.ly graph with the new data.\nUpdate the Apache webserver's index.html file. "
		end note

	end
end