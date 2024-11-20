# Define the destination network and gateway for the static route
$DestinationNetwork = "175.0.0.0"        # Replace this with the actual destination network
$NetmaskLength = 24                    # Replace this with the netmask length (e.g., 24 for /24 subnet)
$Gateway = "192.168.1.1"               # Replace this with the IP address of the gateway

# Add the static route
route /p add $DestinationNetwork mask $NetmaskLength $Gateway