# Quest Template - Renown Inclusion
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.0
# Quest Template Prototype
# Allows for quick and easy setup of Quests

#====================================================#
#======================NPC Container=================#
#====================================================#
ExampleRenown1Assignment:
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
        - zap step:<[step]> s@ExampleRenown1Interact player:<player>
    default constants:
        faction: Skyborne
    interact scripts:
    - 1 ExampleRenown1Interact

ExampleRenown1Interact:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - define renown:<proc[GetRenownStatus].context[<player>|<npc.constant[Faction]>]||null>
                        - inject ExampleRenown1Hello1
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                2:
                    trigger: /Regex:Goodbye/
                    script:
                        - define renown:<proc[GetRenownStatus].context[<player>|<npc.constant[Faction]>]||null>
                        - inject ExampleRenown1Goodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                3:
                    trigger: /Regex:Quest/
                    script:
                        - define renown:<proc[GetRenownStatus].context[<player>|<npc.constant[Faction]>]||null>
                        - inject ExampleRenown1Pitch
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2
                        - zap 2
        2:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - define renown:<proc[GetRenownStatus].context[<player>|<npc.constant[Faction]>]||null>
                        - inject ExampleRenown1Pitch
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2
                2:
                    trigger: /Regex:Accept/
                    script:
                        - define renown:<proc[GetRenownStatus].context[<player>|<npc.constant[Faction]>]||null>
                        - inject ExampleRenown1Accept
                        - run AddActiveQuest def:<player>|ExampleRenown1GuideBook
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                        - zap 3
                3:
                    trigger: /Regex:Decline/
                    script:
                        - define renown:<proc[GetRenownStatus].context[<player>|<npc.constant[Faction]>]||null>
                        - inject ExampleRenown1Decline
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                        - zap 1
                4:
                    trigger: /Regex:Goodbye/
                    script:
                        - define renown:<proc[GetRenownStatus].context[<player>|<npc.constant[Faction]>]||null>
                        - inject ExampleRenown1Goodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2

        3:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - define renown:<proc[GetRenownStatus].context[<player>|<npc.constant[Faction]>]||null>
                        - inject ExampleRenown1Hello3
                        - run AddCompletedQuest def:<player>|ExampleRenown1QuestCompleted
                        - run RemoveActiveQuest def:<player>|ExampleRenown1GuideBook
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                        - zap 1
                2:
                    trigger: /Regex:Remind/
                    script:
                        - define renown:<proc[GetRenownStatus].context[<player>|<npc.constant[Faction]>]||null>
                        - inject ExampleRenown1Remind
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                3:
                    trigger: /Regex:Goodbye/
                    script:
                        - define renown:<proc[GetRenownStatus].context[<player>|<npc.constant[Faction]>]||null>
                        - inject ExampleRenown1Goodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
#====================================================#
#=====================Quest Items====================#
#====================================================#
ExampleRenown1GuideBook:
    type: book
    author: Active Quest
    title: <&c>Example Renown 1
    signed: yes
    text:
        - "This is what you were asked to do"
        - "Should be the same as your quest remind"
ExampleRenown1QuestCompleted:
    type: book
    author: Completed Quest
    title: <&c>Example Renown 1
    signed: yes
    text:
        - "This is a one-page description of the quest. Do not exceed one page."
#====================================================#
#=====================Quest Responses================#
#====================================================#
ExampleRenown1Hello1:
    type: task
    script:
        - if <[renown]> == unknown:
            - random:
                - chat "Hey stranger. I'm <npc.name>."
            - stop
        - if <[renown]> == liked:
            - random:
                - chat "Oh hey, you're <proc[GetCharacterName].context[<player>]>. Some of my friends told me about you."
            - stop
        - if <[renown]> == admired:
            - random:
                - chat "Welcome <proc[GetCharacterName].context[<player>]>. You're becoming a bit of a celebrity around here aren't you?"
            - stop
        - if <[renown]> == hero:
            - random:
                - chat "Oh... my god! Welcome welcome!"
            - stop
        - if <[renown]> == disliked:
            - random:
                - chat "*Eyes you shiftily* Yeah what"
            - stop
        - if <[renown]> == shunned:
            - random:
                - chat "What are you doing around here? You've got a rep."
            - stop
        - if <[renown]> == despised:
            - random:
                - chat "GTFO of my sight I don't want to see you."
            - stop

ExampleRenown1Hello3:
    type: task
    script:
        - if <[renown]> == unknown:
            - random:
                - chat "Thanks for helping me stranger. I appreciate it."
            - stop
        - if <[renown]> == liked:
            - random:
                - chat "Thanks for helping me out."
            - stop
        - if <[renown]> == admired:
            - random:
                - chat "Thanks for spending time on a trivial task!"
            - stop
        - if <[renown]> == hero:
            - random:
                - chat "Shouldn't you be fighting crime or something?"
            - stop
        - if <[renown]> == disliked:
            - random:
                - chat "I don't know why you helped me, but I appreciate it."
            - stop
        - if <[renown]> == shunned:
            - random:
                - chat "Thanks for the help... but clean your act up. Guards might come."
            - stop
        - if <[renown]> == despised:
            - random:
                - chat "What the hell did you do? Get out of my sight. No reward for you!"
            - stop
ExampleRenown1Goodbye:
    type: task
    script:
        - if <[renown]> == unknown:
            - random:
                - chat "Bye"
            - stop
        - if <[renown]> == liked:
            - random:
                - chat "Bye"
            - stop
        - if <[renown]> == admired:
            - random:
                - chat "Bye"
            - stop
        - if <[renown]> == hero:
            - random:
                - chat "Bye"
            - stop
        - if <[renown]> == disliked:
            - random:
                - chat "Bye"
            - stop
        - if <[renown]> == shunned:
            - random:
                - chat "Bye"
            - stop
        - if <[renown]> == despised:
            - random:
                - chat "Bye"
            - stop
ExampleRenown1Pitch:
    type: task
    script:
        - if <[renown]> == unknown:
            - random:
                - chat "Come say hello to me."
            - stop
        - if <[renown]> == liked:
            - random:
                - chat "Please come say hello to me."
            - stop
        - if <[renown]> == admired:
            - random:
                - chat "Please give me your autograph."
            - stop
        - if <[renown]> == hero:
            - random:
                - chat "Please take a picture with me!"
            - stop
        - if <[renown]> == disliked:
            - random:
                - chat "Please come say hello."
            - stop
        - if <[renown]> == shunned:
            - random:
                - chat "I know you look risky, but can you come say hello."
            - stop
        - if <[renown]> == despised:
            - random:
                - chat "GTFO of my sight."
            - stop
ExampleRenown1Remind:
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
ExampleRenown1Accept:
    type: task
    script:
        - if <[renown]> == unknown:
            - random:
                - chat "Great, thanks."
            - stop
        - if <[renown]> == liked:
            - random:
                - chat "Awesome, thanks."
            - stop
        - if <[renown]> == admired:
            - random:
                - chat "Wonderful, thanks."
            - stop
        - if <[renown]> == hero:
            - random:
                - chat "Paramount! Thanks."
            - stop
        - if <[renown]> == disliked:
            - random:
                - chat "Okay... thanks."
            - stop
        - if <[renown]> == shunned:
            - random:
                - chat "I guess..."
            - stop
        - if <[renown]> == despised:
            - random:
                - chat "GTFO"
            - stop
ExampleRenown1Decline:
    type: task
    script:
        - if <[renown]> == unknown:
            - random:
                - chat "fine"
            - stop
        - if <[renown]> == liked:
            - random:
                - chat "okay"
            - stop
        - if <[renown]> == admired:
            - random:
                - chat "i get it"
            - stop
        - if <[renown]> == hero:
            - random:
                - chat "yeah, youre busy"
            - stop
        - if <[renown]> == disliked:
            - random:
                - chat "shame"
            - stop
        - if <[renown]> == shunned:
            - random:
                - chat "probably for the best, honestly"
            - stop
        - if <[renown]> == despised:
            - random:
                - chat "piss off"
            - stop