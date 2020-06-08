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

NewMerchantFlagSetup:
    type: task
    definitions: inv|host
    script:
        - flag player NPCInventory:<[inv]> d:15m
        - flag player NPCInventoryHost:<npc.id> d:15m
        - if !<player.has_flag[<npc.id>_Money]> || <player.flag[<npc.id>_Money].expiration> = d@0.0s:
            - flag player <npc.id>_Money:1000 d:20h
        - inventory open d:NewMerchantInventory
StratumTinkerer2:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
        on click:
            - define inv:StratumTinkererInventory2
            - inject NewMerchantFlagSetup
    interact scripts:
    - 1 StratumTinkererInteract2
StratumTinkererInteract2:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey|Greetings/.
                    script:
                        - random:
                            - chat "I'm a merchant. Have a look at my wares."
                            - chat "I've come from Stratum to offer these gifts."
                            - chat "Hello there. Would you like to trade?"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - wait 1s
                        - define inv:StratumTinkererInventory
                        - inject NewMerchantFlagSetup
StratumTinkererInventory2:
    type: yaml data
    # Item Set One
    1:
        item: Stone
        quantity: 1
        buyprice: 5
        sellprice: 0
    2:
        item: Grass_Block
        quantity: 1
        buyprice: 500
        sellprice: 0
    3:
        item: arrow
        quantity: 64
        buyprice: 128
        sellprice: 20
    4:
        item: Gold_ingot
        quantity: 1
        buyprice: 1500
        sellprice: 0

NewMerchantInventoryController:
    type: world
    debug: true
    events:
        on player clicks item in NewMerchantInventory:
            - determine cancelled passively
            - define click:<context.click>
            - define item:<context.item.script.name||null>
            - if <[item]> == null:
                - define item:<context.item.material.name||null>
            - if <[click]> == right && <[item]> != null && <context.item.has_lore> && <context.item.lore.contains_text[Cost]>:
                - define quantity:<context.item.lore.get[1]>
                - define "cost:<context.item.lore.get[2].after[Cost<&co> ]>"
                - if <player.money> >= <[cost]>:
                    - if <player.inventory.can_fit[<[item]>].quantity[<[quantity]>]>:
                        - money take quantity:<[cost]>
                        - define theNPC:<player.flag[NPCInventoryHost]>
                        - define theNPCMoney:<player.flag[<[theNPC]>_Money]>
                        - flag player <[theNPC]>_Money:+:<[cost]> d:<player.flag[<[theNPC]>_Money].expiration>
                        - give <[item]> quantity:<[quantity]>
                        - inventory adjust slot:54 d:<context.inventory> lore:<player.flag[<player.flag[NPCInventoryHost]>_Money]>
                        - inventory adjust slot:46 d:<context.inventory> lore:<player.money>
                    - else:
                        - inventory close
                        - narrate "<&c>You don't have enough room to fit <[quantity]> <[item]>s."
                - else:
                    - inventory close
                    - narrate "<&c>You do not have enough money to buy this!"
            - if <[click]> == left && <[item]> != null && <context.item.has_lore> && <context.item.lore.contains_text[Sell]>:
                - define quantity:<context.item.lore.get[1]>
                - define "sellprice:<context.item.lore.get[3].after[Sell Price<&co> ]>"
                - if <player.inventory.contains[<[item]>].quantity[<[quantity]>]>:
                    - define theNPC:<player.flag[NPCInventoryHost]>
                    - define theNPCMoney:<player.flag[<[theNPC]>_Money]>
                    - if <[theNPCMoney]> >= <[sellprice]>:
                        - take <[item]> quantity:<[quantity]>
                        - money give quantity:<[sellprice]>
                        # - wait 1s
                        - flag player <[theNPC]>_Money:-:<[sellprice]> d:<player.flag[<[theNPC]>_Money].expiration>
                        # - wait 1s
                        - inventory adjust slot:54 d:<context.inventory> lore:<player.flag[<player.flag[NPCInventoryHost]>_Money]>
                        - inventory adjust slot:46 d:<context.inventory> lore:<player.money>
                    - else:
                        - inventory close
                        - narrate "The Merchant does not have enough money to buy that!"
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
    - "[i@emerald[display_name=Your Balance;lore=<player.money>]] [] [] [] [] [] [] [] [i@emerald[display_name=Merchant Balance;lore=<player.flag[<player.flag[NPCInventoryHost]>_Money]>]]"

TestItem:
    type: item
    material: diamond
    display name: This is a test