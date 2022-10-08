# Drawer StockPile Switch(In Dev)

## About:
Works like the StockPile Switch from Create Mod, send a redstone signal on the side defined in "sideOutput", then the storage percent is lower than the value in "minPercent", and stop sending signal then the storage percent is greater than the value in "maxPercent".

Unfortunately, the script can not read the max capacity of the drawer, the measure is made by multiplying the "maxStack" of the item(the majority is 64, but the Ender Perl for example is 16) by the quantity of stack that the drawer can hold (64 always???) by the "upgradeMultiplier", which must be set depending on the upgrades applied on the drawer, for example, the "Storage Upgrade II" increase by 4 the max storage, so you must manually change the value to 4, is the drawer have more than 1 upgrade, add the value by sum then, example: upgradeMultiplier = 4 + 4 + 8


## Compatibility:
- Storage Drawers only


