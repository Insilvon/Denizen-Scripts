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
            - define entity:<context.entity>
            - if <[entity].contains_text[n@]>:
                - define town:<proc[TownFindNPC].context[<[entity]>]||null>
                - if <[town]> != null:
                    - run TownRemoveNPC instantly def:<[entity]>|<[town]>
        on player right clicks with TownFarmerVoucher|TownBlacksmithVoucher|TownAlchemistVoucher|TownWoodcutterVoucher|TownMinerVoucher|TownTrainerVoucher:
            # permission check
            # TODO: IMPLEMENT OWNER CHECK
            - define locale:<player.location.cursor_on.relative[0,1,0]>
            - define scriptname:<context.item.script>
            - define npcType:<proc[GetNPCType].context[<[scriptname]>]>
            - define townID:<proc[GetCharacterTown].context[<player>]>
            - define name:<proc[GetRandomName]>

            - if !<player.has_flag[CurrentCharacter]>:
                - narrate "You do not have an active character. Please fix this first!"
                - stop
            # Modify NPC Value
            #- run TownModifyYAML instantly def:<[townID]>|NPCs.<[npcType]>|1
            
            # create DNPC
            - create player <[name]> <[locale]> save:temp
            - define keypair:<entry[temp].created_npc>/<[npcType]>
            - adjust <entry[temp].created_npc> lookclose:TRUE
            - adjust <entry[temp].created_npc> set_assignment:PlacedTown<[npcType]>Assignment
            - run SetVulnerable npc:<entry[temp].created_npc>
            #- adjust <entry[temp].created_npc> skin:HeroicKnight -p
            
            # set skin of DNPC
            - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
            - define counter:0
            - define success:false
            - while <[success].matches[false]> && <[counter].as_int> <= 10:
                - define counter:<[counter].add_int[1]>
                - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
                - inject SetNPCURLSkin
            # - if <[success]> == false:
            #     - narrate "<&a>Failed to retrieve the skin from the provided link of <[url]>. Please notify your admin!"
            # - narrate "Controller - adding <[keypair]> to <[townID]>" targets:<server.match_player[Insilvon]>

            - run TownAddNPC instantly def:<[townID]>|<[keypair]>|<[npcType]>

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