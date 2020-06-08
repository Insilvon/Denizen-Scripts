BuilderWorkerVoucher:
    type: item
    material: paper
    display name: Builder Voucher
    lore:
        - Right click to spawn
        - a Builder
        - for your town.

BuilderWorkerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
            - trait state:true Builder
            - define inv:<npc>_Inventory
            - note in@BuilderInventory as:<[inv]>
            - flag <npc> Inventory:<[inv]>
        on click:
            - if <player.is_sneaking>:
                - execute as_op "npc select"
                - if <npc.has_flag[Building]>:
                    - execute as_op "builder cancel"
                    - flag <npc> Building:!
                    - flag <npc> Blueprint:!
                - else:
                    - flag <npc> Building
                    - if <npc.has_flag[Blueprint]>:
                        - execute as_op "builder load <npc.flag[Blueprint]>"
                        - execute as_op "builder build"
            - else:
                - inject BuilderClickEvent
    interact scripts:
    - 1 BuilderWorkerInteract
BuilderWorkerInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello"
                2:
                    trigger: /Regex:Follow/
                    script:
                        - if <npc.has_flag[Follow]>:
                            - follow stop
                            - flag npc Follow:!
                        - else:
                            - follow speed:1.5
                            - flag npc Follow


# = Helper Scripts
BuilderWorld:
    type: world
    events:
        on player clicks item in BuilderInventory:
            - determine cancelled passively
            - define item:<context.item||null>
            - if <[item]> != null:
                - choose <context.click>:
                    - case LEFT:
                        - define target:<player.flag[BuilderInventory]||null>
                        - if <[target]> != null:
                            - flag player BuildSelect d:5m
                            - flag <[target]> Blueprint:<context.item.display>
                            - inventory close
                            - chat "You want me to build <context.item.display>?" talker:<[target]>
                            
                            - define req:null
                            - define req_no:null
                            - inject CheckBuildStock
                            
                            - wait 1s
                            - chat "I can do that. Where do you want to build it?" talker:<[target]>
                            - follow followers:<[target]> target:<player> speed:1.5
                            - narrate "Walk to the location you'd like the Builder to begin. Command them to build when you are ready by shift+rightclicking"
                    - case DROP:
                        - define target:<player.flag[BuilderInventory]||null>
                        - narrate "This Builder has forgotten this schematic."
                        - inventory close
                        - take <context.item> from:<context.inventory>
                        - drop <context.item> <[target].location>


CheckBuildStock:
    type: task
    script:
        - define item <context.item.script.name>
        - define file:/CustomData/BuilderStock.dsc
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - define req:<script[<[file]>].yaml_key[<[item]>.req]||null>
        - define req_no:<script[<[file]>].yaml_key[<[item]>.req_no]||null>
        - if <[req]> == null:
            - chat "ERROR!"
        - else:
            - 

BuilderClickEvent:
    type: task
    script:
        - define item:<player.item_in_hand||null>
        - if <[item]> != null:
            - if <player.item_in_hand.script.name.contains_text[blueprint]>:
                
                - if <player.has_flag[Town_NPC_Cooldown]>:
                    - narrate "You must wait 5 seconds before adding another NPC!" format:TownFormat
                    - stop
                - else:
                    - flag player Town_NPC_Cooldown d:5s
                
                - define npcType:<npc.flag[Type]||null>
                - define character:<player.flag[CharaterSheet_CurrentCharacter]>
                - if <npc.flag[Town]||null> != <player.flag[<[character]>_Town]||none>:
                    - narrate "You are not a member of this worker's town!"
                    - stop
                
                - narrate "You're holding a voucher!" format:TownFormat
                - define inv:in@<npc.flag[Inventory]>
                #= let's see if we can actually add another worker
                
                - if <[inv].contains[<player.item_in_hand>]>:
                    - narrate "This Builder already knows that schematic!"
                    - stop
                
                - if <[inv].can_fit[<player.item_in_hand>]>:
                    - give <player.item_in_hand.script.name> to:<npc.flag[Inventory]>
                - else:
                    - narrate "This worker cannot learn any more blueprints!" format:TownFormat
            - flag player BuilderInventory:<npc> d:1m
        - inventory open d:<npc.flag[Inventory]>

BuilderInventory:
    type: inventory
    inventory: CHEST
    size: 54
    slots:
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"