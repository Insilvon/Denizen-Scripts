#= Listens for placing of managers
TownManagerController:
    type: world
    events:
        on player clicks in NewTownManagerInventory:
            - determine cancelled passively
            - define npcType:unknown
            - foreach li@Farmer|Blacksmith|Trainer|Builder|Miner|Woodcutter|Alchemist as:Trade:
                - if <context.inventory.notable_name.contains_text[<[trade]>]>:
                    - define npcType:<[trade]>
                    - foreach stop
            - define Town:<player.flag[<player.flag[CharaterSheet_CurrentCharacter]>_Town]>
            - if <context.item.material.name||null> == player_head:
                - choose <context.click>:
                    # #= Spawn the NPC (MAKE THIS FOLLOWABLE!)
                    #= This is a problem for future me to figure out if people want it
                    # - case RIGHT:
                        # - define name:<context.item.display>
                        # - create player <[name]> <player.location.right.forward.above> save:temp
                        # - adjust <entry[temp].created_npc> lookclose:TRUE
                        # - adjust <entry[temp].created_npc> set_assignment:<[npcType]>WorkerAssignment
                        # - flag <entry[temp].created_npc> Town:<[town]>
                        # - flag <entry[temp].created_npc> Type:<[npcType]>
                        # # - narrate <[npcType]>
                        # - run SetVulnerable npc:<entry[temp].created_npc>
                        # - determine cancelled passively
                        # - take <context.item> from:<context.inventory>
                    #= Show the Stats for this worker!
                    - case LEFT:
                        - define name:<context.item.display>
                        - if <server.has_flag[Town_<[Town]>_Worker_<[npcType]>_<[Name]>]>:
                            - inventory open d:<[town]>_worker_<[npcType]>_<[name]>
                    #= Fire the worker.
                    - case DROP:
                        - define NPC:<context.item>
                        - define sItem:<context.item.script.name||null>
                        - if <[sItem]> != null:
                            - determine cancelled
                        - define name:<context.item.display>
                        - take <context.item> from:<context.inventory>
                        - flag server Town_<[Town]>_Worker_<[npcType]>_<[name]>:!
                        - narrate "You have fired this <[npcType]>." format:TownFormat
                        - run SetTownYAML def:<[Town]>|NPCs.<[npcType]>|--
                        - run SetTownYAML def:<[Town]>|NPCs.Total|--
                        - define inv:in@<[town]>_worker_<[npcType]>_<[name]>

                        #= Adjust bonus per manager
                        # Get the bonus that NPC earned
                        - define bonus:<[inv].slot[2].lore.get[4]>
                        # - flag server Town_<[Town]>_<[npcType]>_Bonus:-:<[bonus]>
                        # Remove that
                        - flag npc Bonus:-:<[bonus]>
                        - flag npc Resources:-:5
                        
                        
                        - note remove as:<[town]>_worker_<[npcType]>_<[name]>
        #= Handle spawning in a new Manager
        on player right clicks with FarmerManagerVoucher|BlacksmithManagerVoucher|MinerManagerVoucher|TrainerManagerVoucher|BuilderManagerVoucher|WoodcutterManagerVoucher|AlchemistManagerVoucher:
            - inject ManagerSpawnTask
        
        #= Handle upgrading a worker
        on player clicks TownWorkerUpgradeItem in TownWorkerStats:
            - determine cancelled passively
            - define npcType:<context.inventory.slot[2].lore.get[1]||null>
            - define prod:<context.inventory.slot[2].lore.get[4]||null>
            - define prod:<[prod].add_int[5]>
            - define "cost:<context.inventory.slot[7].lore.get[3].before[ emerald]>"
            - if <player.inventory.contains[emerald].quantity[<[cost]>]>:
                - define character:<player.flag[CharaterSheet_CurrentCharacter]>
                #= this adjusts the friggin thing

                # - flag server Town_<player.flag[<[character]>_Town]>_<[npcType]>_Bonus:+:5
                - flag <player.target> Bonus:+:5
                
                - inventory adjust d:<context.inventory> s:2 "lore:<[npcType]>|<&e>Produces Food Every day.|<&e>Current Amount<&co>|<[prod]>"
                - inventory adjust d:<context.inventory> s:7 "lore:Upgrades this worker.|<&e>Current cost to upgrade<&co>|<[cost].mul_int[2]> emerald."
                - take emerald quantity:<[cost]>
            - else:
                - narrate "You do not have enough emeralds to upgrade that worker!" format:TownFormat


#= Inventories
TownManagerInventory:
    type: inventory
    inventory: chest
    title: WIP
    size: 27
    slots:
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] [TownInventoryHelpItem]"
NewTownManagerInventory:
    type: inventory
    inventory: chest
    title: WIP
    size: 9
    slots:
    - "[] [] [] [] [] [] [] [] [TownInventoryHelpItem]"



#= Helper Scripts
ManagerClickEvent:
    type: task
    script:
        - if <player.has_flag[Town_NPC_Cooldown]>:
            - narrate "You must wait 5 seconds before adding another NPC!" format:TownFormat
            - stop
        - else:
            - flag player Town_NPC_Cooldown d:5s
        - define npcType:<npc.flag[Type]>
        # - define npcType:<npc.flag[Type]||null>
        - if <player.item_in_hand.script.name||null> == <[npcType]>WorkerVoucher:
            - define character:<player.flag[CharaterSheet_CurrentCharacter]>
            - if <npc.flag[Town]||null> != <player.flag[<[character]>_Town]||none>:
                - narrate "You are not a member of this worker's town!"
                - stop
            - narrate "You're holding a voucher!" format:TownFormat
            - define inv:in@<npc.flag[Inventory]>
            #= let's see if we can actually add another worker
            - if <[npcType]> != Farmer:
                - define town:<player.flag[<[character]>_Town]>
                # - inject TownFoodCheck
                - inject TownSpaceCheck
            - if <[inv].can_fit[player_head]>:
                - take <player.item_in_hand>
                - define town:<npc.flag[Town]>
                - define name:<proc[GetRandomName]>
                - give "player_head[display_name=<[name]>;lore=A dedicated <[npcType]>|sworn to help|<[town]>]" to:<npc.flag[Inventory]>
                - run TownAddNPC def:<[Town]>|<[npcType]>
                - flag server Town_<[Town]>_Worker_<[npcType]>_<[name]>
                
                #= Increment the resources for the npc
                # - flag server Town_<[Town]>_<[npcType]>_Resources:+:5
                - flag npc Resources:+:5

                - note in@TownWorkerStats as:<[town]>_worker_<[npcType]>_<[name]>
                - inventory adjust d:in@<[town]>_worker_<[npcType]>_<[name]> s:2 "lore:<[npcType]>|<&e>Generates material every day.|<&e>Current Rate<&co>|5"
            - else:
                - narrate "This manager cannot hold any more workers!" format:TownFormat
        - inventory open d:<npc.flag[Inventory]>

ManagerSpawnTask:
    type: task
    script:
        # - execute as_op "denizen debug -r"
        - define locale:<player.location.cursor_on.relative[0,1,0]>
        - define scriptname:<context.item.script>
        - define npcType:<proc[GetNPCType].context[<[scriptname]>]>
        - define character:<player.flag[CharaterSheet_CurrentCharacter]>
        - define town:<player.flag[<[character]>_Town]||null>
        
        # Are you a member of a town?
        - if !<server.flag[Town_List].contains[<[town]>]>:
            - narrate "You must be a member of a town to do this!" format:TownFormat
            - stop
        # Are you in the town?
        - if !<player.location.cuboids.contains_text[<[town]>]>:
            - narrate "You must be within your town to do this!" format:TownFormat
            - stop

        - narrate "Spawning a manager." format:TownFormat
        
        # create DNPC
        - create player <proc[GetRandomName]> <[locale]> save:temp
        - adjust <entry[temp].created_npc> lookclose:TRUE
        - adjust <entry[temp].created_npc> set_assignment:<[npcType]>ManagerAssignment
        - flag <entry[temp].created_npc> Town:<[town]>
        - run SetVulnerable npc:<entry[temp].created_npc>
        
        # Notable Inventory/Flag Setup
        - if !<server.has_flag[Town_<[Town]>_<[npcType]>_Manager]>:
            - flag server Town_<[Town]>_<[npcType]>_Manager:0
        - flag server Town_<[Town]>_<[npcType]>_Manager:++
        - define ID:<server.flag[Town_<[Town]>_<[npcType]>_Manager]>
        - define inv:<[town]>_<[npcType]>_Manager_<[ID]>
        - note in@NewTownManagerInventory as:<[inv]>
                    
        # Run your flags
        - flag <entry[temp].created_npc> Inventory:<[inv]>
        - flag <entry[temp].created_npc> Manager
        - flag <entry[temp].created_npc> ID:<[ID]>
        - flag <entry[temp].created_npc> Type:<[npcType]>
        
        - flag <entry[temp].created_npc> Resources:5
        - flag <entry[temp].created_npc> Bonus:0

        # - wait 4s
        # - execute as_op "denizen submit"
        # - flag server Town_<[Town]>_Managers:->:<entry[temp].created_npc>

        #YAML Town Stats
        - run TownAddNPC def:<[Town]>|<[npcType]>
        # - run SetTownYAML def:<[Town]>|NPCs.<[npcType]>|++
        # - run SetTownYAML def:<[Town]>|NPCs.Total|++

        # set skin of DNPC
        - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
        - define counter:0
        - define success:false
        - while <[success].matches[false]> && <[counter].as_int> <= 10:
            - define counter:<[counter].add_int[1]>
            - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
            - inject SetNPCURLSkin
        - take <[npcType]>ManagerVoucher
        # - run TownAddNewNPC instantly def:<[town]>|<entry[temp].created_npc>/<[npcType]>|<[npcType]>

TownWorkerStats:
    type: inventory
    inventory: chest
    title: Worker Stats
    size: 9
    slots:
        - "[] [TownWorkerStatHead] [] [] [] [] [TownWorkerUpgradeItem] [] []"
TownWorkerStatHead:
    type: item
    material: player_head[skull_skin=7e6ca713-93c6-474a-bec6-94f04e138d6f|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvN2VkNTE5OGRkY2RkODliZTkxYzY5ZmU5YWJmZTJjYTRjMTk0N2M3ZTJlYWMxMWYxODQ2YmQzMTIyY2E1YjhjNiJ9fX0=]
    display name: <&e>Worker Stats
    lore:
    # - Produces Food Every day.|Current Amount<&co>|3
        - Error
        - <&e>Generates material every day.
        - <&e>Current Rate<&co>
        - 5
    
TownWorkerUpgradeItem:
    type: item
    material: green_stained_glass
    display name: <&a>Upgrade Worker
    lore:
        - Upgrades this worker.
        - <&e>Current cost to upgrade<&co>
        - 100 emerald.
TownInventoryHelpItem:
    type: Item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: Help
    lore:
        - <&a>Left click: Show Stats
        - <&c>Right click: Spawn Worker
        - <&e>Drop click: Fire Worker

InventoryWithAllDiscoveredNodes:
    type: inventory
    inventory: chest
    size: 45
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"


AllTownManagerWorld:
    type: world
    events:
        on player clicks item in InventoryWithAllDiscoveredNodes:
            - determine cancelled passively
            - define node:<context.item.script.name||null>
            - if <[node]> != null:
                - define target:<player.flag[TownSelectedManager]||null>
                - if <[target]> == null:
                    - narrate "You must have talked to a manager to use this!"
                    - stop
                - else:
                    - run SetNodeManager def:<[node]>|<[target]>

