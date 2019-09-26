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

TownNPCController:
    type: world
    events:
        on entity death:
            - define npcID:<context.entity>
            - narrate "<context.entity> | <[npcID]>" targets:<server.match_player[Insilvon]>
            - if <[npcID].contains[n@]>:
                - define town:<proc[FindNPCTown].context[<[npcID]>]>
                - define type:<proc[GetTownNPCType].context[<[npcID]>|<[town]>]>
                - define keypair:<proc[GetTownNPCKeypair].context[<[npcID]>|<[town]>]>
                - define currentList:<proc[GetTownYAML].context[<[town]>|Inhabitants.NPCs].as_list>
                - define currentList:<[currentList].exclude[<[keypair]>]>
                - narrate "Ready to go with <[town]>|<[type]>|<[keypair]>|<[currentList]>" targets:<server.match_player[Insilvon]>

                # - ~yaml "load:/Towns/<[town]>.yml" id:<[town]>
                # - yaml id:<[town]> set Inhabitants.NPCs:<[currentList]>
                # - ~yaml "savefile:/Towns/<[town]>.yml" id:<[town]>
                
                # - ~yaml "load:/Towns/<[town]>.yml" id:<[town]>
                # - define currentValue:<yaml[<[town]>].read[NPCs.<[type]>]>
                # - yaml id:<[town]> set NPCs.<[type]>:<[currentValue].sub_int[1]>
                # - ~yaml "savefile:/Towns/<[town]>.yml" id:<[town]>

                # - narrate "Changed from <[currentValue]> to <[currentValue].sub_int[1]>" targets:<server.match_player[Insilvon]>

        on player right clicks with TownFarmerVoucher|TownBlacksmithVoucher|TownAlchemistVoucher|TownWoodcutterVoucher|TownMinerVoucher|TownTrainerVoucher:
            - if !<player.has_flag[CurrentCharacter]>:
                - narrate "You do not have an active character. Please fix this first!"
                - stop
            # permission check
            # TODO: IMPLEMENT OWNER CHECK
            - define locale:<player.location.cursor_on.relative[0,1,0]>
            - define scriptname:<context.item.script>
            - define npcType:<proc[GetNPCType].context[<[scriptname]>]>
                        # get Town Name
            - define town:<proc[GetCharacterTown].context[<player>]>
            # Modify NPC Value
            
            - run TownModifyYAML instantly def:<[town]>|NPCs.<[npcType]>|1
            # create DNPC
            - define name:<proc[GetRandomName]>
            - create player <[name]> <[locale]> save:temp
            - define npcID:<entry[temp].created_npc>

            # add the newly created NPC to the town list
            - define keypair:<[npcID]>/<[npcType]>
            
            - run TownAddNPC def:<[town]>|<[keypair]>
            # set stuff on that npc
            - adjust <entry[temp].created_npc> lookclose:TRUE
            
            - run SetVulnerable npc:<[npcID]>
            #- adjust <entry[temp].created_npc> skin:HeroicKnight -p
            - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
            - define counter:0
            - define success:false
            - while <[success].matches[false]> && <[counter].as_int> <= 10:
                - define counter:<[counter].add_int[1]>
                - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
                - inject SetNPCURLSkin
            - if <[success]> == false:
                - narrate "<&a>Failed to retrieve the skin from the provided link of <[url]>. Please notify your admin!"

            - adjust <entry[temp].created_npc> set_assignment:PlacedTown<[npcType]>Assignment
SetVulnerable:
    type: task
    script:
        - vulnerable state:true
# Based on the provided script voucher name, returns the keyword to use when
# referencing this npc type later
GetNPCType:
    type: procedure
    definitions: name
    script:
        - foreach Farmer|Blacksmith|Alchemist|Woodcutter|Trainer|Miner as:type:
            - if <[name].contains_text[<[type]>]>:
                - determine <[type]>

FindNPCTown:
    type: procedure
    script:
        - define npcID:n@342
        - foreach <server.flag[TownList]> as:town:
            - define list:<proc[GetTownYAML].context[<[town]>|Inhabitants.npcs].as_list>
            - if <[list].map_get[<[npcID]>]||null> != null:
                - determine <[town]>
        - determine failed


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
        - if <[type]> == woodcutter:
            - random:
                - determine https://i.imgur.com/nwLYKhd.png
                - determine https://i.imgur.com/eWP6rOu.png
                - determine https://i.imgur.com/lWBukOp.png
        - if <[type]> == alchemist:
            - random:
                - determine https://i.imgur.com/lyYfGkS.png
                - determine https://i.imgur.com/4P1o5Tj.png
                - determine https://i.imgur.com/SuC8B29.png
        - if <[type]> == trainer:
            - random:
                - determine https://i.imgur.com/t0LvBI6.png
                - determine https://i.imgur.com/zNPkKhp.png
                - determine https://i.imgur.com/LombOzu.png
        - if <[type]> == miner:
            - random:
                - determine https://i.imgur.com/BjpGsf6.png
                - determine https://i.imgur.com/nO1AsGv.png
                - determine https://i.imgur.com/K61pPMU.png
SetNPCURLSKin:
    type: task
    script:
        - define key <util.random.uuid>
        - run skin_url_task def:<def[key]>|<def[url]>|empty id:<def[key]> instantly
        - while <queue.exists[<def[key]>]>:
            - if <def[loop_index]> > 20:
                - queue q@<def[key]> clear
                - queue clear
            - wait 5t
        # Quick sanity check - ideally this should never be true
        - if !<server.has_flag[<def[key]>]>:
            - queue clear
        - if <server.flag[<def[key]>]> == null:
            - flag server <def[key]>:!
        - yaml loadtext:<server.flag[<def[key]>]> id:response
        - if <yaml[response].contains[data.texture]>:
            - adjust <entry[temp].created_npc> skin_blob:<yaml[response].read[data.texture.value]>;<yaml[response].read[data.texture.signature]>
            - define success:true
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

PlacedTownBlacksmithAssignment:
    type: assignment
    interact scripts:
        - 1 PlacedTownBlacksmithInteract

PlacedTownBlacksmithInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello!"