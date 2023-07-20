# Title: House Purchase Machine
# Subtitle: The house purchase machine is a useful tool that can help you determine whether a property is currently available for purchase. If the house is available, you will receive a message with all the relevant property details.
# Author: Mastrd [ /community/profile/086B/Mastrd ]
# Created: Fri Apr 28 2023 09:19:36 GMT+0000 (Coordinated Universal Time)
# Last Updated: Fri Apr 28 2023 09:19:36 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/GKV/fortnite-house-purchase-machine
# ------

# None
# Note: However, if the property is not for sale, you will be informed accordingly, consider planting the house purchase machine in front of your desired property.
var PropertyForSale: logic = true
var PropertyDetails: string = "nothing"

if (PropertyForSale?):
set PropertyDetails = "Address: 123 Main Street, City: Los Angeles, State: California, Price: M1,000"
else:
set PropertyDetails = "Sorry, this property is not currently for sale."

print("Property Details: {PropertyDetails}")
