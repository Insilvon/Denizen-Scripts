#Node_List
#Character_Discovered_Nodes


NodeWand:
    type: item
    material: diamond_axe
    display name: Node Tool

NodeController:
    type: world
    debug: false
    events:
        on player left clicks block with NodeWand:
            - determine cancelled passively
            - narrate "Pos1 Saved at <context.location>!"
            - flag player NodePos1:<context.location>
        on player right clicks block with NodeWand:
            - determine cancelled passively
            - narrate "Pos2 Saved at <context.location>!"
            - flag player NodePos2:<context.location>
        # on player enters notable cuboid:
        #     - if <context.cuboids.contains_text[Node]>:
        #         - define NodeName:<context.cuboids.after[cu@Node_]>
        #         # - narrate <[NodeName]>
        #         - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        #         - if !<player.has_flag[<[character]>_Discovered_Nodes]> || !<player.flag[<[character]>_Discovered_Nodes].contains[<[NodeName]>]>:
        #             - narrate "You have discovered the node <[NodeName]>." format:TownFormat
        #             - flag player <[character]>_Discovered_Nodes:->:<[NodeName]>
        on player clicks item in DiscoveredNodeInventory:
            - determine cancelled passively
            - define name:<context.item.display>
            # - narrate "<[name]>"
            - define character <player.flag[CharacterSheet_CurrentCharacter]>
            - run SetNodeManager def:<[name]>

Node:
    type: command
    debug: false
    name: node
    description: (DEV) Creates a node using active flags
    usage: /node
    script:
        - if <player.has_flag[NodePos1]> && <player.has_flag[NodePos2]>:
            - if <context.args.get[1]||null> == null:
                - narrate "/node create Name Miner|Woodcutter|Farmer"
                - stop
            - if <context.args.get[1]||null> == create:
                - if <context.args.get[2]||null> == null:
                    - narrate "/node create Name Miner|Woodcutter|Farmer"
                    - stop
                - inject NodeCreate
        - if <context.args.get[1]||null> == delete:
            - if <player.location.cuboids.contains_text[Node]>:
                - define theCube:unknown
                - foreach <player.location.cuboids> as:cube:
                    - if <[cube].contains_text[Node]>:
                        - define theCube:<[cube]>
                        - foreach stop
                - inject NodeDelete

NodeCreate:
    type: task
    debug: off
    speed: instant
    debug: true
    script:
        - define size:<context.args.size>
        # Allow for whitespace in names
        - if <[size].sub_int[1]> == 2:
            - define name:<context.args.get[2]>
        - else:
            - define name:<context.args.get[2].to[<[size]>-1]>
        - if <server.has_file[/CustomData/Nodes/<[name]>.yml]>:
            - narrate "The specified node name already exists! Try another."
            - stop
        # - if <player.location.cuboids.size> != 0:
        #     - narrate "There is currently a zone in your area. You cannot create a node in this area."
        #     - stop
        - define type:<context.args.get[3]||null>
        - if <[type]> == null:
            - narrate "You must specify a node type. /node create Name Mine|Forest|Farm"
            - stop
        - define pos1:<player.flag[NodePos1]>
        - narrate <[pos1]>
        - define pos2:<player.flag[NodePos2]>
        - narrate <[pos2]>
        - note cu@<[pos1].world>,<[pos1].xyz>,<[pos2].xyz> as:Node_<context.args.get[2]>
        - narrate "Node named <context.args.get[2]> created"
        
        - flag player NodePos1:!
        - flag player NodePos2:!

        - yaml create id:<[name]>
        - ~yaml "savefile:/CustomData/Nodes/<[name]>.yml" id:<[name]>
        - ~yaml "load:/CustomData/Nodes/<[name]>.yml" id:<[name]>
        
        - ~yaml id:<[name]> set Node.Name:<[name]>
        - ~yaml id:<[name]> set Node.OriginChunk:<player.location.chunk>
        - ~yaml id:<[name]> set Node.Location:<player.location>
        - ~yaml id:<[name]> set Node.Owner:none
        - ~yaml id:<[name]> set Node.Manager:none
        - ~yaml id:<[name]> set Node.Type:none
        - if <[type]> == Mine:
            - ~yaml id:<[name]> set Node.ManagerType:Miner
        - if <[type]> == Farm:
            - ~yaml id:<[name]> set Node.ManagerType:Farmer
        - if <[type]> == Forest:
            - ~yaml id:<[name]> set Node.ManagerType:Woodcutter
        - ~yaml id:<[name]> set Node.WelcomeMessage:<[name]>
        - ~yaml id:<[name]> set Node.Cuboid:cu@Node_<[name]>
        
        - ~yaml "savefile:/CustomData/Nodes/<[name]>.yml" id:<[name]>

        - flag server Node_List:->:<[name]>

NodeDelete:
    type: task
    debug: off
    speed: instant
    debug: true
    script:
        - define name:<[theCube].after[cu@node_]>
        # Remove the node from the node list
        - flag server Node_List:<-:<[name]>
        # Remove the cuboid
        - note remove as:<[theCube]>
        - narrate "<[name]> has been removed."
        # Handle the managers that were at the node

GetNodeOwner:
    type: procedure
    debug: false
    definitions: node
    script:
        - yaml "load:/CustomData/Nodes/<[node]>.yml" id:<[node]>
        - define result:<yaml[<[node]>].read[Node.Owner]||null>
        - determine <[result]>

SetNodeOwner:
    type: task
    debug: false
    definitions: node|town
    script:
        - yaml "load:/CustomData/Nodes/<[node]>.yml" id:<[node]>
        - ~yaml id:<[node]> set Node.Owner:<[town]>
        - ~yaml "savefile:/CustomData/Nodes/<[node]>.yml" id:<[node]>

GetNodeYAML:
    type: procedure
    debug: false
    definitions: node|key
    script:
        - define node:<[node]>
        - yaml "load:/CustomData/Nodes/<[node]>.yml" id:<[node]>
        - define result:<yaml[<[node]>].read[<[key]>]>
        - determine <[result]>

RemoveNodeManager:
    type: task
    debug: false
    speed: instant
    script:
        - define character:<player.flag[CharaterSheet_CurrentCharacter]>
        - define Town:<player.flag[<[character]>_Town]||null>
        
        - if <npc.flag[Town]> != <[town]>:
            - narrate "You can only set managers in your town!"
            - stop

        - define locale:<proc[GetTownYAML].context[<[town]>|Town.OriginLocation]||null>

        - if <[locale]> == null:
            - chat "ERROR - No Home Town. Message Sil!"
            - stop
        - else:
            - define node:<npc.flag[Node]>
            - yaml "load:/CustomData/Nodes/<[node]>.yml" id:<[node]>
            - ~yaml id:<[node]> set Node.Manager:none
            - ~yaml "savefile:/CustomData/Nodes/<[node]>.yml" id:<[node]>
            - teleport <npc> <[locale]>


SetNodeManager:
    type: task
    debug: false
    speed: instant
    definitions: node
    script:
        - define target:<player.target||null>
        - if <[target]> == null || !<[target].is_NPC>:
            - narrate "You must be looking at one of your NPC Managers!"
            - stop
        
        - define character:<player.flag[CharaterSheet_CurrentCharacter]>
        - define Town:<player.flag[<[character]>_Town]||null>
        
        - if <[target].flag[Town]> != <[town]>:
            - narrate "You can only set managers in your town!"
            - stop
        
        # - narrate "<proc[GetNodeYAML].context[<[node]>|Node.ManagerType]>"
        # - narrate "<proc[GetNodeYAML].context[<[node]>|Node.ManagerType]>"

        - if <[target].flag[Type]> != <proc[GetNodeYAML].context[<[node]>|Node.ManagerType]>:
            - narrate "Only a <proc[GetNodeYAML].context[<[node]>|Node.ManagerType]> can work there!"
            - stop

        - define current:<proc[GetNodeYAML].context[<[node]>|Node.Manager]>
        - if  <[current]> != none:
            - if <[current].flag[Town]> != <[Town]>:
                - narrate "Another town is currently in control of this node."
                - stop
            - else:
                - narrate "There is already a worker there! Swapping them."
                - teleport <[current]> <[target].location>
            
        - flag <[target]> Node:<[node]>
        - flag <[target]> Home:<proc[GetTownYAML].context[<[target].flag[Town]>|Town.OriginLocation]>
        - yaml "load:/CustomData/Nodes/<[node]>.yml" id:<[node]>
        - ~yaml id:<[node]> set Node.Manager:<[target]>
        - ~yaml "savefile:/CustomData/Nodes/<[node]>.yml" id:<[node]>
        
        - chat "Understood. I'll head there now." talkers:<[target]>
        - teleport <[target]> <proc[GetNodeYAML].context[<[node]>|Node.Location]>

ClearNodeManager:
    type: task
    debug: false
    speed: instant
    definitions: node|target
    script:
        - flag <[target]> node:!
        - yaml "load:/CustomData/Nodes/<[node]>.yml" id:<[node]>
        - ~yaml id:<[node]> set Node.Manager:none
        - ~yaml "savefile:/CustomData/Nodes/<[node]>.yml" id:<[node]>
        - while !<[target].is_spawned||true>:
            - wait 1s
        - teleport <[target]> <npc.flag[Home]>

DiscoveredNodeInventory:
    type: inventory
    inventory: chest
    size: 54
    procedural items:
        - define character:<player.flag[CharaterSheet_CurrentCharacter]>
        - define list:<player.flag[<[character]>_Discovered_Nodes]||null>
        - if <[list]> != null:
            - foreach <[list]> as:node:
                - define list2:->:i@<[node]>Item
        - determine <[list2]>
    slots:
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"

TestNodeItem:
    type: item
    material: nether_star
    display name: Test Node

MirkItem:
    type: item
    material: nether_star
    display name: Mirk

DeltaFarm1Item:
    type: item
    material: nether_star
    display name: DeltaFarm1

DeltaFarm2Item:
    type: item
    material: nether_star
    display name: DeltaFarm2

HytheFarm1Item:
    type: item
    material: nether_star
    display name: HytheFarm1

HytheFarm2Item:
    type: item
    material: nether_star
    display name: HytheFarm2

LapidasFarm1Item:
    type: item
    material: nether_star
    display name: LapidasFarm1

MiasmyynCoveFarm1Item:
    type: item
    material: nether_star
    display name: MiasmyynCoveFarm1

LapidasMine1Item:
    type: item
    material: nether_star
    display name: LapidasMine1

MidclawMineNode1:
    type: item
    material: nether_star
    display name: MidclawMineNode1

MidclawMineNode2:
    type: item
    material: nether_star
    display name: MidclawMineNode2

EldhamMine1:
    type: item
    material: nether_star
    display name: EldhamMine1