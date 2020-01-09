# Dynamic Names - reads file and gets a random name
GetName:
    type: task
    script:
        - yaml "load:/Utilities/NPCNames.yml" id:NPCNames
        - narrate "<yaml[NPCNames].list_keys[]>"
        - define list:<yaml[NPCNames].list_keys[]>
        - define index:<util.random.int[1].to[<[list].size>]>
        - define name:<[list].get[<[index]>]>
        - narrate "<[name]>"
        - yaml unload id:NPCNames
GetRandomName:
    type: procedure
    speed: 0.1t
    script:
        - yaml "load:/Utilities/firstnames.yml" id:firstname
        - define list:<yaml[firstname].list_keys[]>
        - define index:<util.random.int[1].to[<[list].size>]>
        - define firstname:<[list].get[<[index]>]>
        - yaml unload id:firstname

        - yaml "load:/Utilities/lastnames.yml" id:lastname
        - define list:<yaml[lastname].list_keys[]>
        - define index:<util.random.int[1].to[<[list].size>]>
        - define lastname:<[list].get[<[index]>]>
        - yaml unload id:lastname

        - determine "<[firstname]> <[lastname]>"
DynamicNPC:
    type: command
    name: dnpc
    usage: /dnpc create
    script:
        - define args:<context.args>
        - if <[args].size> == 1:
            - create player <proc[GetRandomName]> <player.location.cursor_on.add[0,1,0]> save:temp
            - adjust <entry[temp].created_npc> lookclose:TRUE
            - run SetVulnerable npc:<entry[temp].created_npc>
            
            # set skin of DNPC
            - define npcType:<[args].get[1]>
            - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
            - define counter:0
            - define success:false
            - while <[success].matches[false]> && <[counter].as_int> <= 10:
                - define counter:<[counter].add_int[1]>
                - define url:<proc[GetTownNPCSkin].context[<[npcType]>]>
                - inject SetNPCURLSkin
        - else:
            - define name:<proc[GetRandomName]>
            - execute as_op "npc create <[name]>"
DNPCAssignment:
    type: assignment
    interact scripts:
        - 1 DNPCInteract
DNPCInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello, my name is <npc.name>"
# =================================================================================
# =================================== SKINS =======================================
# =================================================================================
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
                - determine https://i.imgur.com/zNPkKhp.png
                - determine https://i.imgur.com/LombOzu.png
                - determine https://i.imgur.com/TyugLu3.png
                - determine https://i.imgur.com/HkB9GLe.png
                - determine https://i.imgur.com/pjeJVHA.png
                - determine https://i.imgur.com/6xz0dDU.png
                - determine https://i.imgur.com/DIpz6xB.png
                - determine https://i.imgur.com/fcY6dv5.png
        - if <[type]> == miner:
            - random:
                - determine https://i.imgur.com/BjpGsf6.png
                - determine https://i.imgur.com/nO1AsGv.png
                - determine https://i.imgur.com/K61pPMU.png
        - if <[type]> == automata:
            - random:
                - determine https://i.imgur.com/xY3LOqf.png
                - determine https://i.imgur.com/ZioUK54.png
                - determine https://i.imgur.com/veIFOmY.png
                - determine https://i.imgur.com/pr6OEID.png
                - determine https://i.imgur.com/viCeTLf.png
                - determine https://i.imgur.com/yIrM2d7.png
                - determine https://i.imgur.com/OAS66Rt.png
                - determine https://i.imgur.com/L2xqwtc.png
                - determine https://i.imgur.com/0WAaBk6.png
        - if <[type]> == militia:
            - random:
                - determine https://i.imgur.com/jvZgzos.png
                - determine https://i.imgur.com/mfuUCc1.png
                - determine https://i.imgur.com/Tx1QTQm.png
                - determine https://i.imgur.com/mPwZdmX.png
                - determine https://i.imgur.com/z7nqtsU.png
                - determine https://i.imgur.com/UynrS4x.png
        - if <[type]> == bodyguard:
            - random:
                - determine https://i.imgur.com/iA8GusH.png
                - determine https://i.imgur.com/28HBsGs.png
        - random:
            - determine https://i.imgur.com/8m9UiRb.png
            - determine https://i.imgur.com/fX5LM0i.png
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