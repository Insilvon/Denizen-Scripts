# /town raid|claim|invite|promote|info|
TownCommand:
    type: command
    name: town
    description: (DEV) Creates a town using active flags
    usage: /town create name
    script:
        - define pos1:<player.flag[pos1]>
        - define pos2:<player.flag[pos2]>
        - define args:<context.raw_args>
        - if <[args].size> == 1:
            - define command:<[args].get[1]>
            - if <[command]> == info:
                - inject TownInfo
            - run TownHelp
        - if <[args].size> == 2:
            - define command:<[args].get[1]>
            - if <[command]> == claim:
                - inject TownClaim
            - if <[command]> == raid:
                - inject TownRaid
            - if <[command]> == invite:
                - inject TownInvite
            - if <[command]> == create:
                - define name:<[args].get[2]>
                - if !<server.has_file[/Towns/<[name]>.yml]>:
                    - inject TownCreate
                - else:
                    - narrate "Town - Town already exists!"
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
        - stop
TownClaim:
    type: task
    script:
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
        - yaml create id:<[name]>
        - yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
        - yaml "load:/Towns/<[name]>.yml" id:<[name]>

        - yaml id:<[name]> set Town.Name:<[name]>
        - yaml id:<[name]> set Town.Level:0
        - yaml id:<[name]> set Town.Owner:none

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