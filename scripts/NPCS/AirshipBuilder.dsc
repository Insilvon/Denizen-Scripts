AirshipMerchant:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - define inv:AirshipMerchantInventory
            - inject NewMerchantFlagSetup
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 AirshipMerchantI
AirshipMerchantI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Greetings. You looking for a ship?"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Aye, these are the blueprints I've got."
                        - wait 1s
                        - define inv:AirshipMerchantInventory
                        - inject NewMerchantFlagSetup




AirshipBuilderController:
    type: world
    events:
        on player right clicks with SkippyVoucher:
            - define ship:Skippy
            - inject ShipBuilder
        on player right clicks with LoachVoucher:
            - define ship:Loach
            - inject ShipBuilder
        on player right clicks with SplinterVoucher:
            - define ship:Splinter
            - inject ShipBuilder
        on player right clicks with TetraVoucher:
            - define ship:Tetra
            - inject ShipBuilder
        on player right clicks with ThingVoucher:
            - define ship:Thing
            - inject ShipBuilder
ShipBuilder:
    type: task
    speed: instant
    script:
        - if !<player.has_flag[<[ship]>Construction]>:
            - flag player <[ship]>Construction
            - narrate "You are about to begin building a <[ship]>! Make sure you are in a clear area!"
            - narrate "Right click again to start building."
            - stop
        - flag player <[ship]>Construction:!
        - take <[ship]>Voucher
        - create Player Bob traits:Builder <player.location> save:theNPC
        - execute as_op "npc select <entry[theNPC].created_npc.id>"
        - execute as_op "builder load <[ship]>"
        - execute as_op "builder build"
        - wait 30m
        - remove <entry[theNPC].created_npc.id>
AirshipVoucher:
    type: item
    material: paper
    display name: Airship Voucher
    lore:
        - A voucher for an airship.
        - Right click with this voucher
        - while in an open, clear area
        - to begin construction.
SkippyVoucher:
    type: item
    material: paper
    display name: Skippy Voucher
    lore:
        - A voucher for an airship.
        - Right click with this voucher
        - while in an open, clear area
        - to begin construction.
LoachVoucher:
    type: item
    material: paper
    display name: Loach Voucher
    lore:
        - A voucher for an airship.
        - Right click with this voucher
        - while in an open, clear area
        - to begin construction.
SplinterVoucher:
    type: item
    material: paper
    display name: Splinter Voucher
    lore:
        - A voucher for an airship.
        - Right click with this voucher
        - while in an open, clear area
        - to begin construction.
TetraVoucher:
    type: item
    material: paper
    display name: Tetra Voucher
    lore:
        - A voucher for an airship.
        - Right click with this voucher
        - while in an open, clear area
        - to begin construction.
ThingVoucher:
    type: item
    material: paper
    display name: Thing Voucher
    lore:
        - A voucher for an airship.
        - Right click with this voucher
        - while in an open, clear area
        - to begin construction.