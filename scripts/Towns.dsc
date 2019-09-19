# /town raid|claim|invite|promote|info|
TownCommand:
    type: command
    name: town
    description: (DEV) Creates a town using active flags
    usage: /town create name
    script:
        - define pos1:<player.flag[pos1]>
        - define pos2:<player.flag[pos2]>
        - define args:<context.args>
        - if <[args].size> == 1:
            - define command:<[args].get[1]>
            - if <[command]> == info:
                - inject TownInfo
            - run TownHelp
        - if <[args].size> == 2:
            - foreach claim|raid|invite|create as:switch:
                - if <[args].get[1]> == <[switch]>:
                    - inject Town<[switch]>
        - if <[args].size> == 3:
            - define command:<[args].get[1]>
            - if <[command]> == promote:
                - inject TownPromote
        - run TownHelp
TownHelp:
    type: task
    script:
        - narrate "/town claim <name>"
        - narrate "/town raid <townname>"
        - narrate "/town invite <username>"
        - narrate "/town promote <username>"
        - narrate "/town info"
TownInfo:
    type: task
    script:
        - define name:SilTown
        - ~yaml "load:/Towns/<[name]>.yml" id:<[name]>
        - narrate "[Town] - Showing info for <[name]>"
        - narrate "<&b>[<[name]>] - RESOURCES"
        - narrate "<&b>[<[name]>] -    Building Materials: <&f><yaml[<[name]>].read[Resources.BuildingMaterials]>"
        - narrate "<&b>[<[name]>] -    Crafting Materials: <&f><yaml[<[name]>].read[Resources.CraftingMaterials]>"
        - narrate "<&b>[<[name]>] -    Food: <&f><yaml[<[name]>].read[Resources.Food]>"
        - narrate "<&b>[<[name]>] -    Minerals: <&f><yaml[<[name]>].read[Resources.Minerals]>"
        - narrate "<&b>[<[name]>] -    Weapons: <&f><yaml[<[name]>].read[Resources.Weapons]>"
        - narrate "<&a>[<[name]>] - MILITIA"
        - narrate "<&a>[<[name]>] -    Infantry: <&f><yaml[<[name]>].read[Militia.Infantry]>"
        - narrate "<&a>[<[name]>] -    Sentry: <&f><yaml[<[name]>].read[Militia.Sentry]>"
        - narrate "<&a>[<[name]>] -    Archer: <&f><yaml[<[name]>].read[Militia.Archer]>"
        - narrate "<&a>[<[name]>] -    Mage: <&f><yaml[<[name]>].read[Militia.Mage]>"
        - narrate "<&a>[<[name]>] -    Miniboss: <&f><yaml[<[name]>].read[Militia.Miniboss]>"
        - narrate "<&a>[<[name]>] -    Boss: <&f><yaml[<[name]>].read[Militia.Boss]>"
        - ~yaml unload id:<[name]>
        - stop
TownClaim:
    type: task
    script:
        - define name:<[args].get[2]>
        - yaml "load:/Towns/<[name]>.yml" id:<[name]>
        - define owner:<yaml[<[name]>].read[Town.Owner]>
        - if <[owner]> == none:
            - yaml id:<[name]> set Town.Owner:<player.uuid>
            - yaml id:<[name]> set Town.OwnerName:<player.name.display>
            - yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
            - yaml unload id:<[name]>
            - execute as_server "denizen save"
        - stop
# Command which lets players invite other players to their town
# TODO: Prevent players from inviting themselves
TownInvite:
    type: task
    script:
        - stop
# /town promote name rank
# Command which lets players promote other members of the town to specific titles
TownPromote:
    type: task
    script:
        - stop
# Developer Command which creates a new town at the given location. Uses Denizen
# pos1/pos2 flags to identify the cuboid.
TownCreate:
    type: task
    script:
        - define name:<[args].get[2]>
        - if !<server.has_file[/Towns/<[name]>.yml]>:
            - inject TownCreateHelper
        - else:
            - narrate "Town - Town already exists!"
TownCreateHelper:
    type: task
    script:
        - yaml create id:<[name]>
        - yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
        - yaml "load:/Towns/<[name]>.yml" id:<[name]>

        - yaml id:<[name]> set Town.Name:<[name]>
        - yaml id:<[name]> set Town.Level:0
        - yaml id:<[name]> set Town.Owner:none
        - yaml id:<[name]> set Town.Ownername:none

        - yaml id:<[name]> set Inhabitants.list:null
        - yaml id:<[name]> set Militia.Infantry:0
        - yaml id:<[name]> set Militia.Sentry:0
        - yaml id:<[name]> set Militia.Archer:0
        - yaml id:<[name]> set Militia.Mage:0
        - yaml id:<[name]> set Militia.Miniboss:0
        - yaml id:<[name]> set Militia.Boss:0

        - yaml id:<[name]> set Resources.BuildingMaterials:0
        - yaml id:<[name]> set Resources.Food:0
        - yaml id:<[name]> set Resources.Weapons:0
        - yaml id:<[name]> set Resources.Minerals:0
        - yaml id:<[name]> set Resources.CraftingMaterials:0

        - yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
        - yaml unload id:<[name]>


TownModifyResource:
    type: task
    definitions: name|resource|amount
    script:
        - ~yaml "load:/Towns/<[name]>.yml" id:<[name]>
        - define resourceValue:<yaml[<[name]>].read[Resources.<[resource]>]>
        - ~yaml id:<[name]> set Resources.<[resource]>:<[resourceValue].add_int[<[amount].as_int>]>
        - ~yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
        - ~yaml unload id:<[name]>