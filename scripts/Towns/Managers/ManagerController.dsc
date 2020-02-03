#= Listens for placing of managers
TownManagerController:
    type: world
    events:
        on player clicks in TownManagerInventory:
            - determine cancelled passively
            - define npcType:unknown
            - foreach li@Farmer|Blacksmith|Trainer|Builder|Miner|Woodcutter|Alchemist as:Trade:
                - if <context.inventory.notable_name.contains_text[<[trade]>]>:
                    - define npcType:<[trade]>
                    - foreach stop
            - define Town:<player.flag[<proc[GetCharacterName].context[<player>]>_Town]>
            - if <context.item.material.name||null> == player_head:
                - choose <context.click>:
                    #= Spawn the NPC (MAKE THIS FOLLOWABLE!)
                    - case RIGHT:
                        - define name:<context.item.display>
                        - create player <[name]> <player.location.right.forward.above> save:temp
                        - adjust <entry[temp].created_npc> lookclose:TRUE
                        - adjust <entry[temp].created_npc> set_assignment:<[npcType]>WorkersAssignment
                        - flag <entry[temp].created_npc> Town:<[town]>
                        - run SetVulnerable npc:<entry[temp].created_npc>
                        - determine cancelled passively
                    #= Show the Stats for this worker!
                    - case LEFT:
                        - define name:<context.item.display>
                        - if <server.has_flag[Town_<[Town]>_Worker_<[npcType]>_<[Name]>]>:
                            - inventory open d:<[town]>_worker_<[npcType]>_<[name]>
                    #= Fire the worker.
                    - case DROP:
                        - define NPC:<context.item>
                        - define name:<context.item.display>
                        - take <context.item> from:<context.inventory>
                        - flag server Town_<[Town]>_Worker_<[npcType]>_<[name]>:!
                        - narrate "You have fired this <[npcType]>." format:TownFormat
                        - run SetTownYAML def:<[Town]>|NPCs.<[npcType]>|--
                        - run SetTownYAML def:<[Town]>|NPCs.Total|--
                        - define inv:in@<[town]>_worker_<[npcType]>_<[name]>
                        - define bonus:<[inv].slot[2].lore.get[4].sub_int[5]>
                        - flag server Town_<[Town]>_<[npcType]>_Bonus:-:<[bonus]>
                        - note remove as:<[town]>_worker_<[npcType]>_<[name]>
        on player right clicks with FarmerManagerVoucher|BlacksmithManagerVoucher|MinerManagerVoucher|TrainerManagerVoucher|BuilderManagerVoucher|WoodcutterManagerVoucher|AlchemistManagerVoucher:
            - inject ManagerSpawnTask
        on player clicks TownWorkerUpgradeItem in TownWorkerStats:
            - determine cancelled passively
            - define npcType:<context.inventory.slot[2].lore.get[1]||null>
            - define prod:<context.inventory.slot[2].lore.get[4]||null>
            - define prod:<[prod].add_int[5]>
            - define "cost:<context.inventory.slot[7].lore.get[3].before[ emerald]>"
            - if <player.inventory.contains[emerald].quantity[<[cost]>]>:
                - define character:<proc[GetCharacterName].context[<player>]>
                - flag server Town_<player.flag[<[character]>_Town]>_<[npcType]>_Bonus:+:5
                - inventory adjust d:<context.inventory> s:2 "lore:<[npcType]>|<&e>Produces Food Every day.|<&e>Current Amount<&co>|<[prod]>"
                - inventory adjust d:<context.inventory> s:7 "lore:Upgrades this worker.|<&e>Current cost to upgrade<&co>|<[cost].mul_int[2]> emerald."
                - take emerald quantity:<[cost]>
            - else:
                - narrate "You do not have enough emeralds to upgrade that worker!" format:TownFormat


#= Utilities
TownManagerInventory:
    type: inventory
    inventory: chest
    title: WIP
    size: 27
    slots:
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] [TownInventoryHelpItem]"

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


#= Helper Scripts
ManagerClickEvent:
    type: task
    script:
        - if <player.item_in_hand.script.name||null> == <[npcType]>WorkerVoucher:
            - define character:<proc[GetCharacterName].context[<player>]>
            - if <npc.flag[Town]||null> != <player.flag[<[character]>_Town]||none>:
                - narrate "You are not a member of this worker's town!"
                - stop
            - narrate "You're holding a voucher!" format:TownFormat
            - define inv:in@<npc.flag[Inventory]>
            #= let's see if we can actually add another worker
            - if <[npcType]> != Farmer:
                - define town:<player.flag[<[character]>_Town]>
                - inject TownFoodCheck
                - inject TownSpaceCheck
            - if <[inv].can_fit[player_head]>:
                - define town:<npc.flag[Town]>
                - define name:<proc[GetRandomName]>
                - give "player_head[display_name=<[name]>;lore=A dedicated <[npcType]>|sworn to help|<[town]>]" to:<npc.flag[Inventory]>
                - run TownAddNPC def:<[Town]>|<[npcType]>
                - flag server Town_<[Town]>_Worker_<[npcType]>_<[name]>
                - flag server Town_<[Town]>_<[npcType]>_Resources:+:5
                - note in@TownWorkerStats as:<[town]>_worker_<[npcType]>_<[name]>
                - inventory adjust d:in@<[town]>_worker_<[npcType]>_<[name]> s:2 "lore:<[npcType]>|<&e>Generates material every day.|<&e>Current Rate<&co>|5"
            - else:
                - narrate "This manager cannot hold any more workers!" format:TownFormat
        - inventory open d:<npc.flag[Inventory]>


ManagerSpawnTask:
    type: task
    script:
        - define locale:<player.location.cursor_on.relative[0,1,0]>
        - define scriptname:<context.item.script>
        - define npcType:<proc[GetNPCType].context[<[scriptname]>]>
        - define character:<proc[GetCharacterName].context[<player>]>
        - define town:<player.flag[<[character]>_Town]||null>
        
        # Are you a member of a town?
        - if !<server.flag[Town_List].contains[<[town]>]>:
            - narrate "You must be a member of a town to do this!" format:TownFormat
            - stop
        - narrate "Spawning a manager." format:TownFormat
        
        # create DNPC
        - create player <proc[GetRandomName]> <[locale]> save:temp
        - adjust <entry[temp].created_npc> lookclose:TRUE
        - adjust <entry[temp].created_npc> set_assignment:<[npcType]>ManagerAssignment
        - flag <entry[temp].created_npc> Town:<[town]>
        - run SetVulnerable npc:<entry[temp].created_npc>
        
        # Notable Inventory Setup
        - define inv:<[town]>_<[npcType]>_Manager
        - if !<server.has_flag[Town_<[Town]>_<[npcType]>_Manager]>:
            - note in@TownManagerInventory as:<[inv]>
            - flag server Town_<[Town]>_<[npcType]>_Manager
        
        # Run your flags
        - flag <entry[temp].created_npc> Inventory:<[inv]>
        - flag <entry[temp].created_npc> Manager
        
        # Each manager could have different inventories, but I'm lazy!
        - flag server Town_<[Town]>_<[npcType]>_Manager:++

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
        # - run TownAddNewNPC instantly def:<[town]>|<entry[temp].created_npc>/<[npcType]>|<[npcType]>

TownInventoryHelpItem:
    type: Item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: Help
    lore:
        - <&a>Left click: Show Stats
        - <&c>Right click: Spawn Worker
        - <&e>Drop click: Fire Worker