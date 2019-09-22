# Utility Town NPCs Proof of Concept
# Made and designed for AETHERIA
# @author Insilvon
# @version 2.0.0
# Allows players to recruit NPCs from the world and bring them to their town
# Special thanks to Mergu for his NPC Skin->URL script, originally found
# here: https://one.denizenscript.com/denizen/repo/entry/154, adapted for this specific task

FarmerNPCAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment Set!"
    interact scripts:
        - 1 FarmerNPCInteract
FarmerNPCInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "I am a farmer. I want to help you. Want me to help?"
                        - narrate "YES|NO"
                2:
                    trigger: /Regex:Yes/
                    script:
                        - chat "Excellent, I am now yours."
                        - chat "Take this voucher. Place it where you want me to work."
                        - give TownFarmerVoucher

TownFarmerVoucher:
    type: item
    material: paper
    display name: Town Farmer Voucher

TownNPCController:
    type: world
    events:
        on player right clicks with TownFarmerVoucher:
            # permission check
            # TODO: IMPLEMENT OWNER CHECK
            - define scriptname:<context.item.script>
            - define npcType:<proc[GetNPCType].context[<[scriptname]>]>
            - if !<player.has_flag[CurrentCharacter]>:
                - narrate "You do not have an active character. Please fix this first!"
                - stop
            # get Town Name
            - define townID:<proc[GetTownID].context[<player>]>
            # Modify NPC Value
            - run TownModifyYAML instantly def:<[townID]>|NPCs.Farmer|1
            # create DNPC
            - define name:<proc[GetRandomName]>
            - create player <[name]> <player.location> save:temp
            - adjust <entry[temp].created_npc> lookclose:TRUE
            - adjust <entry[temp].created_npc> set_sneaking:TRUE
            #- adjust <entry[temp].created_npc> skin:HeroicKnight -p
            # TODO - change this to be general!
            - define url:<proc[GetFarmerSkin].context[<[npcType]>]>
            - inject SetNPCURLSkin

            - adjust <entry[temp].created_npc> set_assignment:PlacedTownFarmerAssignment

# Based on the provided script voucher name, returns the keyword to use when
# referencing this npc type later
GetNPCType:
    type: procedure
    definitions: name
    script:
        - foreach Farmer|Blacksmith|Alchemist|Woodcutter|Trainer|Miner as:type:
            - if <[name].contains_text[<[type]>]>:
                - determine <[type]>

# Using the provided keyword, returns a random URL for a skin
# To use for that NPC
GetTownNPCSkin:
    type: procedure
    definitions: type
    script:
        - if <[type]> == farmer:
            - random:
                - determine https://i.imgur.com/MGvfad2.png
                - determine https://i.imgur.com/vC27pzA.png
                - determine https://i.imgur.com/FEKIxq9.png
                - determine https://i.imgur.com/PlWEXxe.png
        - if <[type]> == blacksmith:
            - random:
                - determine https://i.imgur.com/6xVVUEZ.png
                - determine https://i.imgur.com/Tpj5ZYR.png
                - determine https://i.imgur.com/DcHXhoD.png

SetNPCURLSKin:
    type: task
    script:
        - define key <util.random.uuid>
        - run skin_url_task def:<def[key]>|<def[url]>|empty id:<def[key]> instantly
        - while <queue.exists[<def[key]>]>:
            - if <def[loop_index]> > 20:
                - queue q@<def[key]> clear
                - narrate "<&a>The request timed out. Is the url valid?"
                - queue clear
            - wait 5t

        # Quick sanity check - ideally this should never be true
        - if !<server.has_flag[<def[key]>]>:
            - queue clear

        - if <server.flag[<def[key]>]> == null:
            - narrate "<&a>Failed to retrieve the skin from the provided link. Please notify your admin!"
            - flag server <def[key]>:!
            - queue clear

        - yaml loadtext:<server.flag[<def[key]>]> id:response

        - if !<yaml[response].contains[data.texture]>:
            - narrate "<&a>An unexpected error occurred while retrieving the skin data. Please try again."
        - else:
            #- narrate "<&e><def[npc].name><&a>'s skin set to <&e><def[url]><&a>."
            - adjust <entry[temp].created_npc> skin_blob:<yaml[response].read[data.texture.value]>;<yaml[response].read[data.texture.signature]>

        - flag server <def[key]>:!
        - yaml unload id:response

PlacedTownFarmerAssignment:
    type: assignment
    interact scripts:
        - 1 PlacedTownFarmerInteract

PlacedTownFarmerInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello!"