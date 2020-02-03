NewMerchantData:
    type: yaml data
    # Item Set One
    1:
        item: stone
        quantity: 1
        buyprice: 2
        sellprice: 3
    2:
        item: diamond
        quantity: 1
        buyprice: 2
        sellprice: 3
    3:
        item: emerald
        quantity: 1
        buyprice: 2
        sellprice: 3

NewMerchantInventoryController:
    type: world
    events:
        on player clicks item in NewMerchantInventory:
            - determine cancelled passively
            - define click:<context.click>
            - define item:<context.item.script.name||null>
            - if <[item]> == null:
                - define item:<context.item.material.name||null>
            - if <[click]> == right && <[item]> != null:
                - define quantity:<context.item.lore.get[1]>
                - define "cost:<context.item.lore.get[2].after[Cost<&co> ]>"
                - if <player.inventory.contains[emerald].quantity[<[cost]>]> && <player.inventory.can_fit[<[item]>].quantity[<[quantity]>]>:
                    - take emerald quantity:<[cost]>
                    - give <[item]> quantity:<[quantity]>
                - else:
                    - inventory close
                    - narrate "<&c>You either do not have enough emeralds or room for that!"
            - if <[click]> == left && <[item]> != null:
                - define quantity:<context.item.lore.get[1]>
                - define "sellprice:<context.item.lore.get[3].after[Sell Price<&co> ]>"
                - if <player.inventory.contains[<[item]>].quantity[<[quantity]>]>:
                    - take <[item]> quantity:<[quantity]>
                    - give emerald quantity:<[sellprice]>
                - else:
                    - inventory close
                    - narrate "<&c>You do not have enough supply for that!"

NewMerchantInventory:
    type: inventory
    inventory: chest
    size: 54
    title: Merchant Inventory
    procedural items:
        - if <player.has_flag[NpcInventory]>:
            - define file:<player.flag[NpcInventory]>
            - define spacers:li@1|5|9|10|14|18|19|23|27|28|32|36|37|41|45|46|50|54
            - flag player NpcInventory:!
            - define list:->:air
            - define list:->:air
            - define list:->:air
            - define list:->:air
            - define list:->:QuestionMarkItem
            - define list:->:air
            - define list:->:air
            - define list:->:air
            - define list:->:air
            - define slot:10

            - define data:<script[<[file]>].list_keys.exclude[type]>
            - foreach <[data].numerical> as:key:
                - if <[spacers].contains[<[slot]>]>:
                    - define list:->:air
                    - define slot:++
                - if <[spacers].contains[<[slot]>]>:
                    - define list:->:air
                    - define slot:++
    
                - define material:<script[<[file]>].yaml_key[<[key]>.item]>
                - define quantity:<script[<[file]>].yaml_key[<[key]>.quantity]>
                - define buy:<script[<[file]>].yaml_key[<[key]>.buyprice]>
                - define sell:<script[<[file]>].yaml_key[<[key]>.sellprice]>
                - define "item:<[material]>[lore=<[quantity]>|<&e>Cost<&co> <[buy]>|<&a>Sell Price<&co> <[sell]>]"
                - define list:->:<[item]>
                
                - define slot:++
            - determine <[list]>
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"

