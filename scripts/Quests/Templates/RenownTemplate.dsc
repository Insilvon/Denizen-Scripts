# Quest Template - Renown Inclusion
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.0
# Quest Template Prototype
# Allows for quick and easy setup of Quests

#====================================================#
#======================NPC Container=================#
#====================================================#
YourQuestAssignment:
    type: assignment
    actions:
        on assignment:
        - narrate "Assignment set!"
        - trigger name:proximity state:true
        on click:
        - narrate "Hello!" targets:<server.match_player[Insilvon]>
        on enter proximity:
        - narrate "See you! Your character is <proc[GetCharacterName].context[<player>]>" targets:<server.match_player[Insilvon]>
        - define step:<player.flag[<proc[GetCharacterName].context[<player>]>_<npc>]||1>
        - narrate "Zapping to step <[step]>"
        - zap step:<[step]> s@YourQuestInteract player:<player>
    default constants:
        faction:<THISFACTION>
    interact scripts:
    - 1 YourQuestInteract

YourQuestInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - define renown:<proc[GetRenownStatus].context[Faction]||null>
                        - inject YourQuestHello1
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                2:
                    trigger: /Regex:Goodbye/
                    script:
                        - define renown:<proc[GetRenownStatus].context[Faction]||null>
                        - inject YourQuestGoodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                3:
                    trigger: /Regex:Quest/
                    script:
                        - define renown:<proc[GetRenownStatus].context[Faction]||null>
                        - inject YourQuestPitch
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2
                        - zap 2
        2:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - define renown:<proc[GetRenownStatus].context[Faction]||null>
                        - inject YourQuestHello2
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2
                2:
                    trigger: /Regex:Accept/
                    script:
                        - define renown:<proc[GetRenownStatus].context[Faction]||null>
                        - inject YourQuestAccept
                        - run AddActiveQuest def:<player>|YourQuestGuideBook
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                        - zap 3
                3:
                    trigger: /Regex:Decline/
                    script:
                        - define renown:<proc[GetRenownStatus].context[Faction]||null>
                        - inject YourQuestDecline
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                        - zap 1
                4:
                    trigger: /Regex:Goodbye/
                    script:
                        - define renown:<proc[GetRenownStatus].context[Faction]||null>
                        - inject YourQuestGoodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2

        3:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - define renown:<proc[GetRenownStatus].context[Faction]||null>
                        - inject YourQuestHello3
                        - run AddCompletedQuest def:<player>|YourQuestQuestCompleted
                        - run RemoveActiveQuest def:<player>|YourQuestGuideBook
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                        - zap 1
                2:
                    trigger: /Regex:Remind/
                    script:
                        - define renown:<proc[GetRenownStatus].context[Faction]||null>
                        - inject YourQuestRemind
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                3:
                    trigger: /Regex:Goodbye/
                    script:
                        - define renown:<proc[GetRenownStatus].context[Faction]||null>
                        - inject YourQuestGoodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
#====================================================#
#=====================Quest Items====================#
#====================================================#
YourQuestGuideBook:
    type: book
    author: Active Quest
    title: YourQuest Title
    signed: yes
    text:
        - "This is what you were asked to do"
        - "Should be the same as your quest remind"
YourQuestQuestCompleted:
    type: book
    author: Completed Quest
    title: YourQuest Title
    signed: yes
    text:
        - "This is a one-page description of the quest. Do not exceed one page."
#====================================================#
#=====================Quest Responses================#
#====================================================#
YourQuestHello1:
    type: task
    script:
        - if <[renown]> == unknown:
            - random:
                - chat ""
            - stop
        - if <[renown]> == liked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == admired:
            - random:
                - chat ""
            - stop
        - if <[renown]> == hero:
            - random:
                - chat ""
            - stop
        - if <[renown]> == disliked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == shunned:
            - random:
                - chat ""
            - stop
        - if <[renown]> == despised:
            - random:
                - chat ""
            - stop
YourQuestHello2:
    type: task
    script:
        - if <[renown]> == unknown:
            - random:
                - chat ""
            - stop
        - if <[renown]> == liked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == admired:
            - random:
                - chat ""
            - stop
        - if <[renown]> == hero:
            - random:
                - chat ""
            - stop
        - if <[renown]> == disliked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == shunned:
            - random:
                - chat ""
            - stop
        - if <[renown]> == despised:
            - random:
                - chat ""
            - stop
YourQuestHello3:
    type: task
    script:
        - if <[renown]> == unknown:
            - random:
                - chat ""
            - stop
        - if <[renown]> == liked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == admired:
            - random:
                - chat ""
            - stop
        - if <[renown]> == hero:
            - random:
                - chat ""
            - stop
        - if <[renown]> == disliked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == shunned:
            - random:
                - chat ""
            - stop
        - if <[renown]> == despised:
            - random:
                - chat ""
            - stop
YourQuestGoodbye:
    type: task
    script:
        - if <[renown]> == unknown:
            - random:
                - chat ""
            - stop
        - if <[renown]> == liked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == admired:
            - random:
                - chat ""
            - stop
        - if <[renown]> == hero:
            - random:
                - chat ""
            - stop
        - if <[renown]> == disliked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == shunned:
            - random:
                - chat ""
            - stop
        - if <[renown]> == despised:
            - random:
                - chat ""
            - stop
YourQuestPitch:
    type: task
    script:
        - if <[renown]> == unknown:
            - random:
                - chat ""
            - stop
        - if <[renown]> == liked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == admired:
            - random:
                - chat ""
            - stop
        - if <[renown]> == hero:
            - random:
                - chat ""
            - stop
        - if <[renown]> == disliked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == shunned:
            - random:
                - chat ""
            - stop
        - if <[renown]> == despised:
            - random:
                - chat ""
            - stop
YourQuestRemind:
    type: task
    script:
        - if <[renown]> == unknown:
            - random:
                - chat ""
            - stop
        - if <[renown]> == liked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == admired:
            - random:
                - chat ""
            - stop
        - if <[renown]> == hero:
            - random:
                - chat ""
            - stop
        - if <[renown]> == disliked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == shunned:
            - random:
                - chat ""
            - stop
        - if <[renown]> == despised:
            - random:
                - chat ""
            - stop
YourQuestAccept:
    type: task
    script:
        - if <[renown]> == unknown:
            - random:
                - chat ""
            - stop
        - if <[renown]> == liked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == admired:
            - random:
                - chat ""
            - stop
        - if <[renown]> == hero:
            - random:
                - chat ""
            - stop
        - if <[renown]> == disliked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == shunned:
            - random:
                - chat ""
            - stop
        - if <[renown]> == despised:
            - random:
                - chat ""
            - stop
YourQuestDecline:
    type: task
    script:
        - if <[renown]> == unknown:
            - random:
                - chat ""
            - stop
        - if <[renown]> == liked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == admired:
            - random:
                - chat ""
            - stop
        - if <[renown]> == hero:
            - random:
                - chat ""
            - stop
        - if <[renown]> == disliked:
            - random:
                - chat ""
            - stop
        - if <[renown]> == shunned:
            - random:
                - chat ""
            - stop
        - if <[renown]> == despised:
            - random:
                - chat ""
            - stop