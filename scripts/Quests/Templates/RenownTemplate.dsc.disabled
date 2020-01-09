# Quest Template - Renown Inclusion
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.2
# Quest Template Prototype
# Allows for quick and easy setup of Quests

#====================================================#
#======================NPC Container=================#
#====================================================#
YourRenownQuestAssignment:
    type: assignment
    actions:
        on assignment:
        - narrate "Assignment set!"
        - flag npc faction:Skyborne
        - trigger name:proximity state:true
        on click:
        - narrate "Hello!"
        on enter proximity:
        - define step:<player.flag[<proc[GetCharacterName].context[<player>]>_<npc>]||1>
        - narrate "Zapping to step <[step]>"
        - inject RenownFlagUpdater
        - zap step:<[step]> s@YourRenownQuestInteract player:<player>
    interact scripts:
    - 1 YourRenownQuestInteract

YourRenownQuestInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:(?i)Hello/, how are you?
                    script:
                        - inject YourRenownQuestHello1
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                2:
                    trigger: /Regex:(?i)Goodbye/.
                    script:
                        - inject YourRenownQuestGoodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                3:
                    trigger: I<&sq>m looking for /Regex:(?i)Quest|quests|work|jobs/.
                    script:
                        - inject YourRenownQuestPitch
        2:
            chat trigger:
                1:
                    trigger: /Regex:(?i)Hello/.
                    script:
                        - inject YourRenownQuestPitch
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2
                2:
                    trigger: I /Regex:(?i)Accept/.
                    script:
                        - inject YourRenownQuestAccept
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2
                        
                3:
                    trigger: I /Regex:(?i)Decline/.
                    script:
                        - inject YourRenownQuestDecline
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                        - zap 1
                4:
                    trigger: /Regex:(?i)Goodbye/.
                    script:
                        - inject YourRenownQuestGoodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2

        3:
            chat trigger:
                1:
                    trigger: /Regex:(?i)Hello/.
                    script:
                        - inject YourRenownQuestHello3
                        - run AddCompletedQuest def:<player>|YourRenownQuestQuestCompleted
                        - run RemoveActiveQuest def:<player>|YourRenownQuestGuideBook
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                        - zap 1
                2:
                    trigger: Could you /Regex:(?i)Remind/ me what you needed?
                    script:
                        - inject YourRenownQuestRemind
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                3:
                    trigger: /Regex:(?i)Goodbye/.
                    script:
                        - inject YourRenownQuestGoodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
#====================================================#
#=====================Quest Items====================#
#====================================================#
YourRenownQuestGuideBook:
    type: book
    author: Active Quest
    title: <&c>Example Renown 1
    signed: yes
    text:
        - "This is what you were asked to do"
        - "Should be the same as your quest remind"
YourRenownQuestQuestCompleted:
    type: book
    author: Completed Quest
    title: <&c>Example Renown 1
    signed: yes
    text:
        - "This is a one-page description of the quest. Do not exceed one page."
#====================================================#
#=====================Quest Responses================#
#====================================================#
YourRenownQuestHello1:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - if <[value]> >= 0:
            - if <[value]> <= 50:
                - random:
                    - chat "Hey stranger. I'm <npc.name>."
            - if <[value]> <= 150:
                - random:
                    - chat "Oh hey, you're <proc[GetCharacterName].context[<player>]>. Some of my friends told me about you."
            - if <[value]> <= 300:
                - random:
                    - chat "Welcome <proc[GetCharacterName].context[<player>]>. You're becoming a bit of a celebrity around here aren't you?"
            - else:
                - random:
                    - chat "Oh... my god! Welcome welcome!"
        - else:
            - if <[value]> >= -50:
                - random:
                    - chat "*Eyes you shiftily* Yeah what"
            - if <[value]> >= -150:
                - random:
                    - chat "What are you doing around here? You've got a rep."
            - if <[value]> >= -350:
                - random:
                    - chat "GTFO of my sight I don't want to see you."
                - stop
        - narrate "<&hover[Click Me!]><&click[Do you have any work?]><&e>*Ask about work*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Goodbye.]><&c>*Say Goodbye*<&f><&end_click><&end_hover>"

YourRenownQuestHello3:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - if <[value]> >= 0:
            - if <[value]> <= 50:
                - random:
                    - chat "Thanks for helping me stranger. I appreciate it."
            - if <[value]> <= 150:
                - random:
                    - chat "Thanks for helping me out."
            - if <[value]> <= 300:
                - random:
                    - chat "Thanks for spending time on a trivial task!"
            - else:
                - random:
                    - chat "Shouldn't you be fighting crime or something?"
        - else:
            - if <[value]> >= -50:
                - random:
                    - chat "I don't know why you helped me, but I appreciate it."
            - if <[value]> >= -150:
                - random:
                    - chat "Thanks for the help... but clean your act up. Guards might come."
            - if <[value]> >= -350:
                - random:
                    - chat "What the hell did you do? Get out of my sight. No reward for you!"
                - stop

YourRenownQuestGoodbye:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - if <[value]> >= 0:
            - if <[value]> <= 50:
                - random:
                    - chat "Bye"
            - if <[value]> <= 150:
                - random:
                    - chat "Bye"
            - if <[value]> <= 300:
                - random:
                    - chat "Bye"
            - else:
                - random:
                    - chat "Bye"
        - else:
            - if <[value]> >= -50:
                - random:
                    - chat "Bye"
            - if <[value]> >= -150:
                - random:
                    - chat "Bye"
            - if <[value]> >= -350:
                - random:
                    - chat "Bye"
                - stop

YourRenownQuestPitch:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - if <[value]> >= 0:
            - if <[value]> <= 50:
                - random:
                    - chat "Come say hello to me."
            - if <[value]> <= 150:
                - random:
                    - chat "Please come say hello to me."
            - if <[value]> <= 300:
                - random:
                    - chat "Please give me your autograph."
            - else:
                - random:
                    - chat "Please take a picture with me!"
        - else:
            - if <[value]> >= -50:
                - random:
                    - chat "Please come say hello."
            - if <[value]> >= -150:
                - random:
                    - chat "I know you look risky, but can you come say hello."
            - if <[value]> >= -350:
                - random:
                    - chat "GTFO of my sight."
                - stop
        - narrate "<&hover[Click Me!]><&click[Sure, I can do that. I accept your quest.]><&e>*Accept The Quest*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[I must decline.]><&c>*Decline the Quest*<&f><&end_click><&end_hover>"
        - zap step:2 s@YourRenownQuestInteract player:<player>

YourRenownQuestRemind:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - if <[value]> >= 0:
            - if <[value]> <= 50:
                - random:
                    - chat ""
            - if <[value]> <= 150:
                - random:
                    - chat ""
            - if <[value]> <= 300:
                - random:
                    - chat ""
            - else:
                - random:
                    - chat ""
        - else:
            - if <[value]> >= -50:
                - random:
                    - chat ""
            - if <[value]> >= -150:
                - random:
                    - chat ""
            - if <[value]> >= -350:
                - random:
                    - chat ""
                - stop
        - narrate "<&hover[Click Me!]><&click[Hello.]><&e>*Say Hello*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Can you remind me what you needed assistance with?]><&c>*Ask for a reminder*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Goodbye.]><&a>*Say Goodbye*<&f><&end_click><&end_hover>"

YourRenownQuestAccept:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - if <[value]> >= 0:
            - if <[value]> <= 50:
                - random:
                    - chat "Great, thanks."
            - if <[value]> <= 150:
                - random:
                    - chat "Awesome, thanks."
            - if <[value]> <= 300:
                - random:
                    - chat "Wonderful, thanks."
            - else:
                - random:
                    - chat "Paramount! Thanks."
        - else:
            - if <[value]> >= -50:
                - random:
                    - chat "Okay... thanks."
            - if <[value]> >= -150:
                - random:
                    - chat "I guess..."
            - if <[value]> >= -350:
                - random:
                    - chat "GTFO"
                - stop
        - run AddActiveQuest def:<player>|YourRenownQuestGuideBook
        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
        - zap step:3 s@YourRenownQuestInteract player:<player>

YourRenownQuestDecline:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - if <[value]> >= 0:
            - if <[value]> <= 50:
                - random:
                    - chat "fine"
            - if <[value]> <= 150:
                - random:
                    - chat "okay"
            - if <[value]> <= 300:
                - random:
                    - chat "i get it"
            - else:
                - random:
                    - chat "yeah, youre busy"
        - else:
            - if <[value]> >= -50:
                - random:
                    - chat "shame"
            - if <[value]> >= -150:
                - random:
                    - chat "probably for the best, honestly"
            - if <[value]> >= -350:
                - random:
                    - chat "piss off"
                - stop