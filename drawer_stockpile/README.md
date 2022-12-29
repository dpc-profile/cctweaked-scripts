# Drawer StockPile Switch
## About:
Works like the StockPile Switch from Create Mod, **send a Redstone signal** on the side defined in "sideOutput", **when the storage percent is lower** than the value in "minPercent", and **stop sending signal then the storage percent is greater** than the value in "maxPercent".

## More technical:
Unfortunately, the script can not read the max capacity of the drawer, the measure is made:

by multiplying the "maxStack" of the item(the majority is 64, but the Ender Perl for example is 16), 

by the quantity of stack that the drawer can hold (32 btw), 

by the "upgradeMultiplier", which must be set depending on the upgrades applied on the drawer.

For example, the "Storage Upgrade II" increase by 4 the max storage, so you must manually change the value to 4, if the drawer have more than 1 upgrade, add the value by sum then, example: upgradeMultiplier = 4 + 4 + 8


## Compatibility:
- Storage Drawers only (Only with the drawer 1x1)


