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
        
        