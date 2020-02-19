# Allows players to claim towns, manage their resources, and dominate their enemies
# = Server Flags: 
#- <Town>:TownOwner (Character)
#- Town_<Town>_Plots:ID
#- Town_<Town>_Total_Plots
#- Town_<Town>_Members
#- Town_<Town>_Members_ID
#- Town_List
#- Town_<Town>_Corners: <x> <y> <z> <world>
# = Player Flags: 
#- <character>_Town:<Town>
#- <character>_Town_Leader

TownFormat:
    type: format
    format: "<&3>[Towns]<&co><&f> <text>"

TownWorld:
    type: world
    debug: true
    events:
        on player right clicks with TownTestVoucher:
            - define character:<proc[GetCharacterName].context[<player>]>
            - define town:<player.flag[<[character]>_Town]||null>
            # If you have no town or aren't placing your NPC in a town...
            - if <[town]> == null || !<player.location.cuboids.contains_text[<[town]>]>:
                - narrate "To use this item you must be both a member of a town as well as placing them in it!" format:TownFormat
                - stop
            #== Add spawning in/redirect of various vouchers
        #what voucher it is
        #== Add spawning in/redirect of various vouchers
        on player enters notable cuboid:
            - foreach <server.flag[Town_List]> as:Town:
                # Is your new cuboid in a town?
                - define from:<context.from.cuboids||none>
                - if <context.cuboids.get[1].contains_text[<[Town]>]>:
                # Was the old one???
                    - if !<[from].contains_text[<[Town]>]>:
                        - define message:<proc[GetTownYAML].context[<[Town]>|Town.WelcomeMessage]||<&lt><&gt>>
                        - title "title:<green><[Town]>" "subtitle:<gold><[message]>"
        # on player clicks in TownInventoryObject:
        #     - determine cancelled
TownCommand:
    type: command
    debug: true
    name: town
    description: (DEV) Creates a town using active flags
    usage: /town
    aliases:
    - t
    script:
        - define args:<context.args>
        - define arg:<context.args.get[1]||null>
        - define easy:li@Info|Create|Claim|Expand|recede|Invite|Kick|Promote|Demote|Join|Store|Welcome|members|inventory|stats|rename
        - if <[easy].contains[<[arg]>]>:
            - inject Town<[arg]>
            - stop
        - choose <[arg]>:
            - case leave:
                - define temp:<context.args.get[2]||null>
                - if <[temp]> == confirm:
                    - inject TownLeaveConfirm
                    - stop
                - inject TownLeave
                - stop
            - case disband:
                - define temp:<context.args.get[2]||null>
                - if <[temp]> == confirm:
                    - inject TownDisbandConfirm
                    - stop
                - inject TownDisband
                - stop
            - case raid:
                - define temp:<context.args.get[2]||null>
                - if <[temp]> == stop:
                    # kill the raid
                    - inject TownRaidStop
                    - stop
                - inject TownRaid
                - stop
            - case help:
                - define temp:<context.args.get[2]||null>
                - if <[temp]> == 2:
                    - inject TownHelp2
                    - stop
                - if <[temp]> == 3:
                    - inject TownHelp3
                    - stop
                - if <[temp]> == 4:
                    - inject TownHelp4
                    - stop
                - inject TownHelp
                - stop
            - default:
                - inject TownHelp
                - stop
TownRename:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - if <[town]> == null:
            - narrate "You must be a member of a town to view this!" format:TownFormat
            - stop
        - define target:<player.target||null>
        - if <[target]> == null:
            - narrate "You must be looking at a worker or manager to do this!" format:TownFormat
            - stop
        - if !<[target].has_flag[Town]>:
            - narrate "This person is not a member of a town!"
            - stop
        - if <[town]> != <[target].flag[Town]>:
            - narrate "This person is not a member of your town!"
            - stop
        - define arg:<context.args.get[2]||null>
        - if <[arg]> == null:
            - adjust <[target]> name:<proc[RandomColor]><proc[GetRandomName]>
        - else:
            - adjust <[target]> name:<proc[RandomColor]><context.args.get[2].to[<context.args.size>].space_separated>
        
TownInventory:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - if <[town]> == null:
            - narrate "You must be a member of a town to view this!" format:TownFormat
            - stop
        - inventory open d:<[town]>_inventory
TownStats:
    type: task
    debug: true
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - if <[town]> == null:
            - narrate "You must be a member of a town to view this!" format:TownFormat
            - stop
        #- Can we place this npc? How many farmers do we have?
        - yaml "load:/Towns/<[town]>.yml" id:<[town]>
        - define townFarmers:<yaml[<[town]>].read[NPCs.Farmer]>
        #- Okay. So they each produce 3 food.
        - define production:<[townFarmers].mul_int[3]>
        #- How many NPCS do we have to feed?
        - define totalNPCs:<yaml[<[town]>].read[NPCs.Total]>
        - if <[production]> <= <[totalNPCs]>:
            - narrate "You can't add another worker! Your town does not produce enough food to feed them." format:TownFormat
        - else:
            - narrate "You produce enough food for a new worker." format:TownFormat
        - define land:<server.flag[Town_<[Town]>_Total_Plots]>
        - define totalNPCs:<yaml[<[town]>].read[NPCs.Total]>
        - define max:<[land].mul_int[3]>
        - if <[totalNPCs]> >= <[max].sub_int[1]>:
            - narrate "You don't have enough space! Expand your town!" format:TownFormat
            - stop
        - else:
            - narrate "You have enough land to hire more workers." format:TownFormat

TownInfo:
    type: task
    debug: true
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - if <[town]> == null:
            - narrate "You must be a member of a town to view this!" format:TownFormat
            - stop
        # Now list all details of the town
        - ~yaml "load:/Towns/<[town]>.yml" id:<[town]>
        - narrate "Showing info for <[town]><&co>" format:TownFormat
        - narrate "Satisfaction - <yaml[<[town]>].read[Town.Satisfaction]>" format:TownFormat
        - wait 2s
        - narrate "<&b>RESOURCES"
        - narrate "<&b>   Building Materials: <&f><yaml[<[town]>].read[Resources.BuildingMaterials]>"
        - narrate "<&b>   Crafting Materials: <&f><yaml[<[town]>].read[Resources.CraftingMaterials]>"
        - narrate "<&b>   Food: <&f><yaml[<[town]>].read[Resources.Food]>"
        - narrate "<&b>   Minerals: <&f><yaml[<[town]>].read[Resources.Minerals]>"
        - narrate "<&b>   Weapons: <&f><yaml[<[town]>].read[Resources.Weapons]>"
        - wait 2s
        - narrate "<&e>VILLAGERS"
        - narrate "<&e>   Farmers: <&f><yaml[<[town]>].read[NPCs.Farmer]>"
        - narrate "<&e>   Blacksmiths: <&f><yaml[<[town]>].read[NPCs.Blacksmith]>"
        - narrate "<&e>   Miners: <&f><yaml[<[town]>].read[NPCs.Miner]>"
        - narrate "<&e>   Woodcutters: <&f><yaml[<[town]>].read[NPCs.Woodcutter]>"
        - narrate "<&e>   Trainers <&f><yaml[<[town]>].read[NPCs.Trainer]>"
        - narrate "<&e>   Alchemists: <&f><yaml[<[town]>].read[NPCs.Alchemist]>"
        - wait 2s
        - narrate "<&a>MILITIA"
        - narrate "<&a>   Infantry: <&f><yaml[<[town]>].read[Militia.Infantry]>"
        - narrate "<&a>   Sentry: <&f><yaml[<[town]>].read[Militia.Sentry]>"
        - narrate "<&a>   Archer: <&f><yaml[<[town]>].read[Militia.Archer]>"
        - narrate "<&a>   Mage: <&f><yaml[<[town]>].read[Militia.Mage]>"
        - narrate "<&a>   Miniboss: <&f><yaml[<[town]>].read[Militia.Miniboss]>"
        - narrate "<&a>   Boss: <&f><yaml[<[town]>].read[Militia.Boss]>"
        - wait 2s
        - narrate "<&3>SPACE"

        - define townFarmers:<yaml[<[town]>].read[NPCs.Farmer]>
        - define production:<[townFarmers].mul_int[3]>
        - define totalNPCs:<yaml[<[town]>].read[NPCs.Total]>
        - define land:<server.flag[Town_<[Town]>_Total_Plots]>
        - define totalNPCs:<yaml[<[town]>].read[NPCs.Total]>
        - define max:<[land].mul_int[3]>
        
        - narrate "<&3>   Food Production: <&f><[production]>"
        - narrate "<&3>   Food Consumption: <&f><[totalNPCs]>"
        - narrate "<&3>   Total Villagers: <&f><[totalNPCs]>"
        - narrate "<&3>   Max Villagers: <&f><[max]>"
        - ~yaml unload id:<[town]>
TownCreate:
    type: task
    debug: false
    script:
        - define Character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        # Are they a member of a town already?
        - if <[Town]> != null:
            - narrate "You cannot create a town while a member of another!" format:TownFormat
            - stop
        # Now create the town - claim the chunk.
        - define name:<[args].get[2].to[<[args].size>].space_separated||null>
        - if <[name]> == null:
            - narrate "You must specify a name to create a town!" format:TownFormat
            - stop
        # Does the Town already exist?
        - if <server.has_file[/Towns/<[name]>.yml]>:
            - narrate "The specified town name already exists! Try another." format:TownFormat
            - stop
        # Are you in somewhere you're not supposed to be?
        - if <player.location.cuboids.size> != 0:
            - narrate "There is currently a zone in your area. You cannot claim this area." format:TownFormat
            - stop
        # All looks good
        - define chunk:<player.location.chunk>
        - inject TownCreateYAML
        - define cuboid:<[chunk].cuboid>
        # Flag the Server Town_Townname:x, where X is the ID of the next plot to claim
        - flag server Town_<[name]>_Plots:2
        - flag server Town_<[name]>_Total_Plots:1
        - flag server Town_<[name]>_Members:->:<[character]>
        - flag server Town_<[name]>_Members_Users:->:<player>
        - flag server Town_List:->:<[name]>
        - flag server <[name]>:<[character]>
        - note <[cuboid]> as:<[name]>_1
        - note in@TownInventoryObject as:<[name]>_Inventory
        - flag player <[character]>_Town:<[name]>
        - narrate "The town of <[name]> has been created." format:TownFormat
        # - run TownAddToDynmap def:<player.location.chunk>|<[name]>|1

# Helper for TownCreate
# TODO: Generalize this and fit it into /town claim
TownCreateYAML:
    type: task
    script:
        - yaml create id:<[name]>
        - ~yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
        - ~yaml "load:/Towns/<[name]>.yml" id:<[name]>

        - ~yaml id:<[name]> set Town.Name:<[name]>
        - ~yaml id:<[name]> set Town.Level:0
        - ~yaml id:<[name]> set Town.Owner:none
        - ~yaml id:<[name]> set Town.Ownername:none
        - ~yaml id:<[name]> set Town.Satisfaction:none
        - ~yaml id:<[name]> set Town.OriginChunk:<[chunk]>
        - ~yaml id:<[name]> set "Town.WelcomeMessage:Welcome to <[name]>."
        
        - ~yaml id:<[name]> set NPCs.Farmer:0
        - ~yaml id:<[name]> set NPCs.Blacksmith:0
        - ~yaml id:<[name]> set NPCs.Trainer:0
        - ~yaml id:<[name]> set NPCs.Alchemist:0
        - ~yaml id:<[name]> set NPCs.Woodcutter:0
        - ~yaml id:<[name]> set NPCs.Miner:0
        - ~yaml id:<[name]> set NPCs.Total:0

        - ~yaml id:<[name]> set Militia.Infantry:0
        - ~yaml id:<[name]> set Militia.Sentry:0
        - ~yaml id:<[name]> set Militia.Archer:0
        - ~yaml id:<[name]> set Militia.Mage:0
        - ~yaml id:<[name]> set Militia.Miniboss:0
        - ~yaml id:<[name]> set Militia.Boss:0

        - ~yaml id:<[name]> set Resources.BuildingMaterials:0
        - ~yaml id:<[name]> set Resources.Food:0
        - ~yaml id:<[name]> set Resources.Weapons:0
        - ~yaml id:<[name]> set Resources.Minerals:0
        - ~yaml id:<[name]> set Resources.CraftingMaterials:0

        - ~yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
        #- yaml unload id:<[name]>

TownWelcome:
    type: task
    debug: true
    script:
        - define Character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - define message:<context.args.get[2].to[<context.args.size>]||null>
        - if <[Town]> == null:
            - narrate "You must be a member of a town to do this!" format:TownFormat
            - stop
        - if !<player.has_flag[<[character]>_Town_Leader]> && <server.flag[<[Town]>]> != <[character]>:
            - narrate "You do not have enough permissions to do that!" format:TownFormat
            - stop
        - if <[message]> == null:
            - narrate "You must set a message!" format:TownFormat
            - stop
        - run SetTownYAML def:<[Town]>|Town.WelcomeMessage|<[message].space_separated>
        - narrate "Your town welcome message has been set to <&e><[message].space_separated>." format:TownFormat
TownMembers:
    type: task
    debug: false
    script:
        - define Character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - if <[Town]> == null:
            - narrate "You must be a member of a town to do this!" format:TownFormat
            - stop
        - narrate "<server.flag[Town_<[Town]>_Members].comma_separated>" format:TownFormat
#== WAIT ON THIS UNTIL RAIDING SYSTEM COMPLETE
TownClaim:
    type: task
    debug: false
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define PlayerTown:<player.flag[<[character]>_Town]||null>
        - define Town:<context.args.get[2]||null>
        - if <[PlayerTown]> != null:
            - narrate "You cannot claim a town while a member of another!" format:TownFormat
            - stop
        - if <server.flag[<[Town]>]> == None && !<server.has_flag[Town_<[Town]>_Unclaimable]>:
            # set new owner
            - flag server <[Town]>:<[character]>
            # set character town
            - flag player <[character]>_Town:<[Town]>
            # add member
            - flag server Town_<[Town]>_Members:->:<[character]>
            # add username
            - flag server Town_<[Town]>_Members_Users:->:<player>
            - narrate "You are now the owner of <[Town]>." format:TownFormat
            - stop
        - narrate "This town is already owned by someone. You cannot claim it." format:TownFormat
        # Make this player the owner of this town

# Adds the current chunk to your claim.
#== TODO: Add proximity check to other chunks!
#== TODO: Add check to see if you have enough resources/people!
TownExpand:
    type: task
    debug: false
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - define TownOwner:<server.flag[<[Town]>]||null>
        - if <[TownOwner]> != <proc[GetCharacterName].context[<player>]>:
            - narrate "You are not the owner of this town. You cannot expand the territory." format:TownFormat
            - stop
        # Is this already claimed?
        - if <player.location.cuboids.size> != 0:
            - narrate "There is currently a zone in your area. You cannot claim this area." format:TownFormat
            - stop
        # Are we adjacent?
        - define chunk:<player.location.chunk>
        - define north:<[chunk].add[1,0].cuboid.center>
        - define south:<[chunk].add[-1,0].cuboid.center>
        - define west:<[chunk].add[0,-1].cuboid.center>
        - define east:<[chunk].add[0,1].cuboid.center>
        - define pass:false
        - foreach li@<[north]>|<[south]>|<[west]>|<[east]> as:direction:
            - if <[direction].cuboids.contains_text[<[Town]>]>:
                - define pass:true
        - if <[pass]> == false:
            - narrate "You can only expand adjacent to your town! Claims must be connected!"
            - stop
        # Run the expand and take the juice
        - if !<player.inventory.contains[emerald].quantity[100]>:
            - narrate "You do not have enough emeralds to do this!"
            - stop
        - else:
            - take emerald quantity:100
            - define plot:<server.flag[Town_<[Town]>_Plots]>
            - flag server Town_<[Town]>_Plots:++
            - flag server Town_<[Town]>_Total_Plots:++
            - note <player.location.chunk.cuboid> as:<[Town]>_<[plot]>
            - narrate "This chunk has been claimed for <[Town]>." format:TownFormat
        # - run TownAddToDynmap def:<player.location.chunk>|<[Town]>|<[Plot]>

GetChunkCorners:
    type: procedure
    definitions: chunk
    debug: true
    script:
        - define cube:<[chunk].cuboid>
        - define max:<[cube].max>
        - define maxX:<[max].x>
        - define maxZ:<[max].z>
        # - narrate <[max]>
        - define min:<[cube].min>
        - define minX:<[min].x>
        - define minZ:<[min].z>
        # - narrate <[min]>
        - define world:<[max].world.name>
        - define "list:li@<[maxX]> 255 <[maxZ]> <[world]>|<[minX]> 255 <[maxZ]> <[world]>|<[minX]> 255 <[minZ]> <[world]>|<[maxX]> 255 <[minZ]> <[world]>"
        - determine <[list]>
TownAddToDynmap:
    type: task
    definitions: chunk|Town|ID
    debug: true
    speed: instant
    script:
        - define data:<proc[GetChunkCorners].context[<[chunk]>]>
        - define c1:<[data].get[1]>
        - define c2:<[data].get[2]>
        - define c3:<[data].get[3]>
        - define c4:<[data].get[4]>
        
        - foreach li@<[c1]>|<[c2]>|<[c3]>|<[c4]> as:corner:
            - execute as_server "dmarker addcorner <[corner]>"
        - execute as_server "dmarker addarea id:<[town]>_<[ID]> <[Town]>_<[ID]>"

TownRemoveFromDynmap:
    type: task
    definitions: chunk|Town|ID
    debug: true
    speed: instant
    script:
        - define data:<proc[GetChunkCorners].context[<[chunk]>]>
        - define c1:<[data].get[1]>
        - define c2:<[data].get[2]>
        - define c3:<[data].get[3]>
        - define c4:<[data].get[4]>
        # - foreach li@<[c1]>|<[c2]>|<[c3]>|<[c4]> as:corner:
        #     - flag server Town_<[Town]>_Corners:<-:<[corner]>
        - execute as_server "dmarker deletearea <[Town]>_<[ID]>"
# Removes the current chunk from your control
#== TOOD: MAKE IT RETURN RESOURCES
Townrecede:
    type: task
    debug: true
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - define TownOwner:<server.flag[<[Town]>]||null>
        # Are they the owner?
        - if <[TownOwner]> != <proc[GetCharacterName].context[<player>]>:
            - narrate "You are not the owner of this town. You cannot reduce the territory." format:TownFormat
            - stop
        # Is this the origin chunk?
        - if <player.location.chunk> == <proc[GetTownYAML].context[<[town]>|Town.OriginChunk]>:
            - narrate "You cannot remove your origin chunk!" format:TownFormat
            - stop
        # All things look good - remove the chunk
        - define chunk:<player.location>
        - foreach <[chunk].cuboids> as:cube:
            - if <[cube].contains_text[<[Town]>]>:
                - note remove as:<[cube].notable_name>
        - flag server Town_<[name]>_Total_Plots:--
        - narrate "You have receded this chunk." format:TownFormat
        - run TownRemoveFromDynmap def:<player.location.chunk>|<[Town]>
# Invite another Character to your town.
TownInvite:
    type: task
    debug: false
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - define TownOwner:<server.flag[<[Town]>]>
        - if <[town]> == null:
            - narrate "You must be a member of a town to do this!" format:TownFormat
            - stop
        # Check that the other player exists. Do we do this per-character or per-player???
        - if <[TownOwner]> != <proc[GetCharacterName].context[<player>]>:
            - narrate "You are not the owner of this town. You cannot promote members." format:TownFormat
            - stop
        - define target:<player.target||null>
        - if <[target]> == null || !<[target].is_player>:
            - narrate "To invite a Character to your town, you must be looking at them!" format:TownFormat
            - stop
        - define targetCharacter:<proc[GetCharacterName].context[<[target]>]>
        - define targetTown:<[target].flag[<[targetCharacter]>_Town]||null>
        - if <[targetTown]> != <[Town]> && <[targetTown]> != null:
            - narrate "Error! You cannot invite someone from another town!" format:TownFormat
            - stop
        # All checks passed, invite them
        # - flag <[target]> <[targetCharacter]>_Town_Leader
        - narrate "<proc[GetCharacterDisplayName].context[<[target]>]> Has been invited to join the town." format:TownFormat
        - narrate "You have been invited to join <[town]>." format:TownFormat target:<[target]>
        - flag <[target]> Town_Invite:<[Town]> d:5m
TownJoin:
    type: task
    debug: true
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - define TownOwner:<server.flag[<[Town]>]>
        - if <[town]> != null:
            - narrate "You cannot accept an invitation while a member of a town!" format:TownFormat
            - stop
        - if !<player.has_flag[Town_Invite]>:
            - narrate "You do not have a pending invitation from a town." format:TownFormat
            - stop
        - define town:<player.flag[Town_Invite]>
        - flag server Town_<[town]>_Members:->:<[character]>
        - flag server Town_<[town]>_Members_Users:->:<player>
        - flag player <[character]>_Town:<[town]>
        - narrate "You have joined <[town]>"
# Removes a character from your town. Offline compatibility.
TownKick:
    type: task
    debug: true
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - define TownOwner:<server.flag[<[Town]>]||null>
        - if <[TownOwner]> != <proc[GetCharacterName].context[<player>]>:
            - narrate "You are not the owner of this town. You cannot promote members." format:TownFormat
            - stop
        - define arg:<context.args.get[2]||null>
        - if <[arg]> == null:
            - narrate "You must provide the Username of the player to kick!" format:TownFormat
            - stop
        # =- Enable offline kicking?
        - define targetPlayer:<server.match_offline_player[<[arg]>]||null>
        - if <[targetPlayer]> == null:
            - narrate "Error! No Username on record with that name. Are they online?" format:TownFormat
            - stop

        - foreach <server.flag[Town_<[Town]>_Members_Users]> as:member:
            - if <[member]> == <[targetPlayer]>:
                - define targetCharacter:<server.flag[Town_<[Town]>_Members].get[<[loop_index]>]>

                - if <[targetPlayer].flag[<[targetCharacter]>_Town]> != <[Town]>:
                    - narrate "Error! You cannot kick someone who is not in your town!" format:TownFormat
                    - stop
                
                - if <[targetCharacter]> == <server.flag[<[Town]>]>:
                    - narrate "Woah! You cannot kick the owner of the town!" format:TownFormat
                    - stop
                
                - flag <[targetPlayer]> <[targetCharacter]>_Town:!
                - flag <[targetPlayer]>_<[Town]>_Leader:!

                - flag server Town_<[Town]>_Members:<-:<[targetCharacter]>
                - flag server Town_<[Town]>_Members_Users:<-:<[targetPlayer]>
                
                - narrate "<proc[GetCharacterDisplayName].context[<[targetPlayer]>]> Has been kicked from the town." format:TownFormat
                - narrate "You are no longer a member of <[Town]>. You have been removed by its owner." format:TownFormat target:<[targetPlayer]>
                - stop
        - narrate "No member of your town has the specified username. Are you sure it's correct?" format:TownFormat
# Give a town member leadership perms for your town
TownPromote:
    type: task
    debug: false
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - define TownOwner:<server.flag[<[Town]>]||null>
        - if <[TownOwner]> != <proc[GetCharacterName].context[<player>]>:
            - narrate "You are not the owner of this town. You cannot promote members." format:TownFormat
            - stop
        - define target:<player.target||null>
        - if <[target]> == null || !<[target].is_player>:
            - narrate "To invite a Character to your town, you must be looking at them!" format:TownFormat
            - stop
        - define targetCharacter:<proc[GetCharacterName].context[<[target]>]>
        - if <[target].flag[<[targetCharacter]>_Town]> != <[Town]>:
            - narrate "Error! You cannot promote someone not in your town!" format:TownFormat
            - stop
        - flag <[target]> <[targetCharacter]>_Town_Leader
        - narrate "<proc[GetCharacterDisplayName].context[<[target]>]> Has been promoted to Leader." format:TownFormat
        - narrate "You have been promoted to a leader of your town." format:TownFormat target:<[target]>
# Remove leadership perms from someone in your town
TownDemote:
    type: task
    debug: false
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - define TownOwner:<server.flag[<[Town]>]||null>
        - if <[TownOwner]> != <proc[GetCharacterName].context[<player>]>:
            - narrate "You are not the owner of this town. You cannot demote members." format:TownFormat
            - stop
        - define arg:<context.args.get[2]||null>
        - if <[arg]> == null:
            - narrate "You must provide the Username of the player to demote!" format:TownFormat
            - stop
        - define target:<server.match_player[<[arg]>]||null>
        - if <[target]> == null:
            - narrate "Error! No Username on record with that name. Are they online?" format:TownFormat
            - stop
        - define targetCharacter:<proc[GetCharacterName].context[<[target]>]>
        - if <[target].flag[<[targetCharacter]>_Town]> != <[Town]>:
            - narrate "Error! You cannot demote someone not in your town!" format:TownFormat
            - stop
        - if <[targetCharacter]> == <server.flag[<[Town]>]>:
            - narrate "Woah! You cannot kick the owner of the town!" format:TownFormat
            - stop
        - flag <[target]> <[targetCharacter]>_Town_Leader:!
        - narrate "<proc[GetCharacterDisplayName].context[<[target]>]> Has been demoted from leader." format:TownFormat
        - narrate "You are no longer a leader of your town." format:TownFormat target:<[target]>
TownLeave:
    type: task
    debug: false
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define town:<player.flag[<[character]>_Town]||null>
        - if <[town]> == null:
            - narrate "You are not a member of a town!" format:TownFormat
            - stop
        - if <server.flag[<[Town]>]> == <[character]>:
            - narrate "You are the owner of this town! Are you sure you wish to leave it ownerless?" format:TownFormat
            - narrate "<&hover[Click to leave.]><&click[/town leave confirm]><&f>/town leave confirm<&f><&end_click><&end_hover>" format:TownFormat
            - stop
        - flag server Town_<[Town]>_Members:<-:<[character]>
        - flag server Town_<[Town]>_Members_Users:<-:<player>
        - flag player <[character]>_Town:!
        - flag player <[character]>_Town_Leader:!
        - narrate "You have left your town." format:TownFormat
        - foreach <server.flag[Town_<[Town]>_Members_Users]> as:member:
            - narrate "<[character]> has left the town." format:TownFormat target:<[member]>
TownLeaveConfirm:
    type: task
    debug: false
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define town:<player.flag[<[character]>_Town]||null>
        - if <[town]> == null:
            - narrate "You are not a member of a town!" format:TownFormat
            - stop
        - if <server.flag[<[Town]>]> == <[character]>:
            - flag server <[Town]>:None
            - flag player <[character]>_Town:!
            - flag player <[character]>_Town_Leader:!
            - flag server Town_<[Town]>_Members:<-:<[character]>
            - flag server Town_<[Town]>_Members_Users:<-:<player>
            - narrate "You have left your town." format:TownFormat
            - foreach <server.flag[Town_<[Town]>_Members_Users]> as:member:
                - narrate "The owner of your town has stepped down." format:TownFormat target:<[member]>
TownDisband:
    type: task
    debug: false
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - define TownOwner:<server.flag[<[Town]>]||null>
        - if <[TownOwner]> != <proc[GetCharacterName].context[<player>]>:
            - narrate "You are not the owner of this town. You cannot disband it!" format:TownFormat
            - stop
        - narrate "<&4>You are about to disband your town." format:TownFormat
        - wait 2s
        - narrate "<&4>This will completely remove all information about your town from the server." format:TownFormat
        - wait 2s
        - narrate "<&4>Your builds will be left behind, however your statistics, banked units, and NPC progress will be lost." format:TownFormat
        - wait 2s
        - narrate "<&4>If this is what you wish to do, please type <&c>/town disband confirm." format:TownFormat
TownDisbandConfirm:
    type: task
    debug: false
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - define TownOwner:<server.flag[<[Town]>]||null>
        - if <[TownOwner]> != <proc[GetCharacterName].context[<player>]>:
            - narrate "You are not the owner of this town. You cannot disband it!" format:TownFormat
            - stop
        - repeat <server.flag[Town_<[Town]>_Plots]> as:loop:
            - note remove as:<[Town]>_<[loop]>
        - foreach <server.flag[Town_<[Town]>_Members_Users]> as:member:
            - define characters:<server.flag[Town_<[Town]>_Members].get[<[loop_index]>]>
            - flag <[member]> <[characters]>_Town:!
            - narrate "Your town has been disbanded." format:TownFormat target:<[member]>
        - foreach <server.list_notables[cuboids]> as:cuboid:
            - if <[cuboid].contains_text[<[Town]>]>:
                - note remove as:<[cuboid]>
        - foreach <server.list_flags> as:flag:
            - if <[flag].contains_text[<[Town]>]>:
                - flag server <[flag]>:!
        - flag server Town_List:<-:<[Town]>
        - flag server <[Town]>:!
        - flag server Town_<[Town]>_Total_Plots:!
        - flag server Town_<[Town]>_Plots:!
        - flag server Town_<[Town]>_Members:!
        - flag server Town_<[Town]>_Members_Users:!
        - note remove as:<[Town]>_Inventory
        # NPC HANDLING
        - flag server Town_<[Town]>_Farmer_Manager:!
        - note remove as:<[Town]>_Farmer_Manager:
        - adjust server delete_file:/Towns/<[Town]>.yml
        
TownRaid:
    type: task
    debug: false
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - define TownOwner:<server.flag[<[Town]>]||null>
        - if <[TownOwner]> != <proc[GetCharacterName].context[<player>]>:
            - narrate "You are not the owner of this town. You cannot instigate a raid!" format:TownFormat
            - stop
TownRaidStop:
    type: task
    debug: false
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - define TownOwner:<server.flag[<[Town]>]||null>
        - if <[TownOwner]> != <proc[GetCharacterName].context[<player>]>:
            - narrate "You are not the owner of this town. You cannot instigate a raid!" format:TownFormat
            - stop
TownStore:
    type: task
    debug: false
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - if <[town]> == null:
            - narrate "You are not a member of a town!" format:TownFormat
TownSurrender:
    type: task
    debug: false
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define Town:<player.flag[<[character]>_Town]||null>
        - define TownOwner:<server.flag[<[Town]>]||null>
        - if <[TownOwner]> != <proc[GetCharacterName].context[<player>]>:
            - narrate "You are not the owner of this town. You cannot surrender it." format:TownFormat
            - stop
        - define arg:<context.args.get[2]||null>
        - if <[arg]> == null:
            - narrate "You must provide the Username of the player to give the town to!" format:TownFormat
            - stop
        - define target:<server.match_player[<[arg]>]||null>
        - if <[target]> == null:
            - narrate "Error! No Username on record with that name. Are they online?" format:TownFormat
            - stop
        - define targetCharacter:<proc[GetCharacterName].context[<[target]>]>
        - if <[target].flag[<[targetCharacter]>_Town]> != <[Town]>:
            - narrate "Error! You cannot surrender to someone not in your town!" format:TownFormat
            - stop
        - flag server <[Town]>:<[targetCharacter]>
        - narrate "<proc[GetCharacterDisplayName].context[<[target]>]> is now the leader of <[town]>." format:TownFormat
        - narrate "You are still a member of <[town]>. If you wish to leave, do so with /town leave."
TownHelp:
    type: task
    debug: false
    script:
        - narrate "<&e>Help Menu - Page One-----------<&gt>" format:TownFormat
        - narrate "<&3><&hover[Click Me!]><&click[/town]>/town<&end_click><&end_hover>: <&f>Displays this list!"
        - narrate "<&3><&hover[Click Me!]><&click[/town info]>/town info<&end_click><&end_hover>: <&f>Displays information and stats about your town."
        - narrate "<&3>/town create <&lt>Name<&gt>: <&f>Creates a new town at your location. (Different than claim!)"
        - narrate "<&3>/town claim <&lt>Name<&gt>: <&f>Claims an inactive or ownerless town as your own. (You can only have one town.)"
        - narrate "<&3><&hover[Click Me!]><&click[/town expand]>/town expand<&end_click><&end_hover>: <&f>Adds the current chunk to your land claim, depending on your resources and number of villagers"
        - narrate "<&3><&hover[Click Me!]><&click[/town recede]>/town recede<&end_click><&end_hover>: <&f>Removes the current chunk from your control"
        - narrate "<&hover[Click Me!]><&click[/town help 2]><&e>Page 2<&f><&end_click><&end_hover>"
TownHelp2:
    type: task
    debug: false
    script:
        - narrate "<&e>Help Menu - Page Two-----------<&gt>" format:TownFormat
        - narrate "<&3><&hover[Click Me!]><&click[/town invite]>/town invite<&end_click><&end_hover>: <&f>Invites the Character you are currently looking at to your town."
        - narrate "<&3>/town kick <&lt>Player Name<&gt> <&lt>Character Name<&gt>: <&f>Removes that troublesome Character from your town."
        - narrate "     If you do not know the full Character's name, a partial match is fine. Works offline."
        - narrate "<&3><&hover[Click Me!]><&click[/town promote]>/town promote<&end_click><&end_hover>: <&f>Gives another player leadership perms in your town. (Does not make them the true owner.) Must be looking at them."
        - narrate "<&3>/town demote <&lt>Player Name<&gt> <&lt>Character Name<&gt>: <&f>Removes leadership perms of your town from the player."
        - narrate "     If you do not know the full Character's name, a partial match is fine. Works offline."
        - narrate "<&hover[Click Me!]><&click[/town help 3]><&e>Page 3<&f><&end_click><&end_hover>"
TownHelp3:
    type: task
    debug: false
    script:
        - narrate "<&e>Help Menu - Page Three-----------<&gt>" format:TownFormat
        - narrate "<&3><&hover[Click Me!]><&click[/town leave]>/town Leave<&end_click><&end_hover>: <&f>Leaves your current Town. If you are the owner of the town, use /town disband to delete it."
        - narrate "<&3><&hover[Click Me!]><&click[/town disband]>/town Disband<&end_click><&end_hover>: <&f>If you are the owner of a town, then this will remove your town completely."
        - narrate "<&3>/town Disband (Ct.):<&f>Your NPCs will remain there and will be recruitable for others."
        - narrate "<&3>/town Raid <&lt>Town Name<&gt>: <&f>Instigates a raid on another Town."
        - narrate "<&3><&hover[Click Me!]><&click[/town store]>/town Store<&end_click><&end_hover>: <&f>Will store a Militia Voucher (must be holding to work) in the town militia."
        - narrate "<&3>/town Surrender <&lt>Player Name<&gt> <&lt>Character Name<&gt>: <&f>Gives another player ownership of your town."
        - narrate "     If you do not know the full Character's name, a partial match is fine. Works offline."
        - narrate "<&hover[Click Me!]><&click[/town help 4]><&e>Page 4<&f><&end_click><&end_hover>"

TownHelp4:
    type: task
    debug: false
    script:
        - narrate "<&e>Help Menu - Page Four-----------<&gt>" format:TownFormat
        - narrate "<&3>/town welcome <&lt>Your welcome message<&gt>: <&f>Sets the welcome message players see when they walk into your town."
        - narrate "<&3>/town rename <&lt>First Last<&gt>: <&f>Sets the display name of the NPC you're looking at. If blank, a random name is added."
# Helper Scripts =====================================
# Checks if the player is the owner of their town
# GetTownOriginChunk:
#     type: procedure
#     debug: false
#     definitions: name
#     script:
#         - yaml "load:/Towns/<[name]>.yml" id:<[name]>
#         - determine <yaml[<[name]>].read[Town.OriginChunk]||null>
#         - yaml unload id:<[name]>

TownFoodCheck:
    type: task
    script:
        #- Can we place this npc? How many farmers do we have?
        - yaml "load:/Towns/<[town]>.yml" id:<[town]>
        - define townFarmers:<yaml[<[town]>].read[NPCs.Farmer]>
        #- Okay. So they each produce 3 food.
        - define production:<[townFarmers].mul_int[3]>
        #- How many NPCS do we have to feed?
        - define totalNPCs:<yaml[<[town]>].read[NPCs.Total]>
        - if <[production]> <= <[totalNPCs]>:
            - narrate "You can't add another worker! Your town does not produce enough food to feed them." format:TownFormat
            - determine cancelled
TownSpaceCheck:
    type: task
    script:
        - define land:<server.flag[Town_<[Town]>_Total_Plots]>
        - yaml "load:/Towns/<[town]>.yml" id:<[town]>
        - define totalNPCs:<yaml[<[town]>].read[NPCs.Total]>
        - define max:<[land].mul_int[3]>
        - if <[totalNPCs]> >= <[max].sub_int[1]>:
            - narrate "You don't have enough space! Expand your town!" format:TownFormat
            - stop

# TownCalcResources:
#     type: world
#     events:
#         on system time hourly every:12:
#             - run TownResourceLoop

TownResourceLoop:
    type: task
    speed: instant
    script:
        - foreach <server.flag[Town_List]> as:town:
            - narrate "Checking <[town]>"
            - ~yaml load:Towns/<[town]>.yml id:<[town]>
            - define type:li@Farmer|Blacksmith|Trainer|Builder|Miner|Woodcutter|Alchemist
            - foreach <[type]> as:npcType:
                #- Farmers and food management
                - define bonus:<server.flag[Town_<[town]>_<[npcType]>_Bonus]||0>
                - if <[npcType]> == Farmer:
                    - define townFarmers:<yaml[<[town]>].read[NPCs.<[npcType]>]>
                    - define addition:<[townFarmers].mul_int[3]>
                    - define townFood:<yaml[<[town]>].read[Resources.Food].add_int[<[addition]>].add_int[<[bonus]>]>
                    - define totalNPCs:<yaml[<[town]>].read[NPCs.Total]>
                    - define hunger:<[totalNPCs]>
                    - define townFood:<[townFood].sub_int[<[hunger]>]>
                    - if <[townFood]> < 0:
                        - yaml id:<[town]> set Town.Satisfaction:-:1
                    - else:
                        - yaml id:<[town]> set Town.Satisfaction:+:1
                    - yaml id:<[town]> set Resources.Food:<[townFood]>
                - inject TownRewardHandler
                    
            #- Blacksmiths
            - ~yaml "savefile:/Towns/<[town]>.yml" id:<[town]>
            # - yaml unload id:<[town]>

TownRewardHandler:
    type: task
    speed: instant
    script:
        - if <[town]> == MysticTown:
            - execute as_op "denizen debug -r"
        - define base:<server.flag[Town_<[Town]>_<[npcType]>_Resources]||0>
        - define amount:<[base].add_int[<[bonus]>]>
        - repeat 7 as:no:
            - define level:lvl<[no]>
            - define <[level]>_goods:<script[Town<[npcType]>Rewards].yaml_key[lvl<[no]>]>
            - define <[level]>_amount:0
            - define target:<[no].mul_int[5]>
            - if <[amount]> >= <[target]>:
                - define <[level]>_amount:<[amount].div_int[<[target]>]>
            - if <[no]> == 1:
                - define <[level]>_amount:<[amount]>
            - define list:<[<[level]>_goods]>
            - define slot:<util.random.int[1].to[<[list].size>]>
            - if <[<[level]>_amount]> != 0:
                - give <[list].get[<[slot]>]> quantity:<[<[level]>_amount]> to:<[Town]>_Inventory
        - if <[town]> == MysticTown:
            - execute as_op "denizen submit"

TownInventoryObject:
    type: inventory
    inventory: chest
    title: Town Treasury
    size: 54
    slots:
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"

GetTownYAML:
    type: procedure
    debug: true
    definitions: name|key
    script:
        - yaml "load:/Towns/<[name]>.yml" id:<[name]>
        - define result:<yaml[<[name]>].read[<[key]>]||null>
        # - yaml unload id:<[name]>
        - determine <[result]>

SetTownYAML:
    type: task
    debug: true
    definitions: name|key|value
    speed: instant
    script:
        - ~yaml "load:/Towns/<[name]>.yml" id:<[name]>
        - yaml id:<[name]> set <[key]>:<[value]>
        - ~yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
        #- yaml unload id:<[name]>

TownAddNPC:
    type: task
    debug: true
    definitions: name|npcType
    script:
        - ~yaml "load:/Towns/<[name]>.yml" id:<[name]>
        - yaml id:<[name]> set NPCs.<[npcType]>:++
        - yaml id:<[name]> set NPCs.Total:++
        - ~yaml "savefile:/Towns/<[name]>.yml" id:<[name]>

TownResetWorkers:
    type: task
    debug: false
    script:
        - run SetTownYaml def:SilVille|NPCs.Farmer|0
        - run SetTownYaml def:SilVille|NPCs.Blacksmith|0
        - run SetTownYaml def:SilVille|NPCs.Total|0