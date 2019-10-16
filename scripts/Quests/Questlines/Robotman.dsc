# Quest Template - Renown Inclusion
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.4
# Quest Template Prototype
# Allows for quick and easy setup of Quests

#====================================================#
#======================NPC Container=================#
#====================================================#
RobotmanAssignment:
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
        - zap step:<[step]> s@RobotmanInteract player:<player>
    interact scripts:
    - 1 RobotmanInteract

RobotmanInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:(?i)Hello/, how are you?
                    script:
                        - inject RobotmanHello1
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                2:
                    trigger: /Regex:(?i)Goodbye/.
                    script:
                        - inject RobotmanGoodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                3:
                    trigger: I<&sq>m looking for /Regex:(?i)Quest|quests|work|jobs/.
                    script:
                        - inject RobotmanPitch
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2
                        - zap 2

        2:
            chat trigger:
                1:
                    trigger: /Regex:(?i)Hello/.
                    script:
                        - inject RobotmanPitch
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2
                        
                2:
                    trigger: I /Regex:(?i)Accept/.
                    script:
                        - inject RobotmanAccept
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                        
                3:
                    trigger: I /Regex:(?i)Decline/.
                    script:
                        - inject RobotmanDecline
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                        - zap 1
                4:
                    trigger: /Regex:(?i)Goodbye/.
                    script:
                        - inject RobotmanGoodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2

        3:
            chat trigger:
                1:
                    trigger: /Regex:(?i)Hello/.
                    script:
                        - inject RobotmanHello3
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                2:
                    trigger: Could you /Regex:(?i)Remind/ me what you needed?
                    script:
                        - inject RobotmanRemind
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                3:
                    trigger: /Regex:(?i)Goodbye/.
                    script:
                        - inject RobotmanGoodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                4:
                    trigger: I brought the /Regex:(?i)ore/.
                    script:
                        - if <player.inventory.contains[SimpleKineticOre].quantity[2]>:
                            - take SimpleKineticOre quantity:2
                            - inject RobotmanThanks
                            - run AddCompletedQuest def:<player>|YourRenownQuestQuestCompleted
                            - run RemoveActiveQuest def:<player>|YourRenownQuestGuideBook
                            - wait 1s
                            - chat "I have... a request, if you'd be so kind."
                            - wait 3s
                            - chat "The work here is brutal and unfulfilling. We are given just barely what we need to survive, and I have no prospects beyond it."
                            - wait 3s
                            - chat "Since you have chosen to save --whirr-- my life, I wish to offer it to you."
                            - wait 3s
                            - chat "Will you accept my pledge, and allow me to join you?"
                            - narrate "<&hover[Accepting will allow you to bring this NPC to your town.]><&click[I would be honored to have you.]><&e>*Accept the automata<&sq>s offer*<&f><&end_click><&end_hover> | <&hover[Declining his offer will grant you nothing, but you lose nothing.]><&click[I think you'd be better off here. I'm sorry.]><&c>*Polietly Decline*<&f><&end_click><&end_hover>"
                            - flag player <proc[GetCharacterName].context[<player>]>_<npc>:4
                            - run ModifyRenownValue def:<player>|Skyborne|1
                            - zap 4
                        - else:
                            - chat "Am I some --brrzzt-- joke to you? I just asked for simple kinetic ore. Get out of here."
                            - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                            
        4:
            chat trigger:
                1:
                    trigger: I would be /Regex:(?i)honored/ to have you.
                    script:
                        - chat "--Brzzt-- Wonderful. Take my slip - I will follow you wherever you choose to lay your head."
                        - narrate "<&lt><&lt><&a>You have been given a character voucher. If you right click this voucher in your camp or town, you will bring the NPC there to service you.<&f><&gt><&gt>"
                        - give RobotmanVoucher
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                        - zap 1
                2:
                    trigger: You would be better off here. I<&sq>m /regex:(?i)sorry/.
                    script:
                        - chat "I understand. It was a long shot anyway."
                        - wait 2s
                        - chat "Take care, <proc[GetCharacterName].context[<player>]>"
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                        - zap 1
#====================================================#
#=====================Quest Items====================#
#====================================================#
RobotmanGuideBook:
    type: book
    author: Active Quest
    title: <&c>Example Renown 1
    signed: yes
    text:
        - "A Skyborne Automata has requested you to acquire more kinetic ore for his engine. Bring it to the Oily Cog when you've acquired it."
RobotmanQuestCompleted:
    type: book
    author: Completed Quest
    title: <&c>Example Renown 1
    signed: yes
    text:
        - "An automata sympethizer provided more kinetic ore to recharge a soul engine. The automata said <&dq>I wouldn't have been able to go on without them. There's hope yet.<&dq>"
#====================================================#
#=====================Quest Responses================#
#====================================================#
RobotmanHello1:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - if <[value]> >= 0:
            - if <[value]> >= 50:
                - if <[value]> >= 150:
                    - if <[value]> >= 300:
                        - chat "What brings a famous hero like --BrZzT-- you around to a place like this? Shouldn't --Whirr-- you be afraid of getting your boots dirty?"
                    - else:
                        - chat "Welcome <proc[GetCharacterName].context[<player>]>. You're becoming a bit of a celebrity around here aren't you? You come to look at the --whirr-- slave labor?"
                - else:
                    - chat "Oh hey, you're <proc[GetCharacterName].context[<player>]>. Some of my friends told me about you - helping --brrzt-- people in the area."
            - else:
                - chat "Hey stranger. I'm <npc.name>."
        - else:
            - if <[value]> <= -150:
                - if <[value]> <= -350:
                    - chat "You've got some --zzz-- stones if you're showing your --whirr-- face around here. I'm not talking to a traitor."
                    - stop
                - else:
                    - chat "If you're coming to steal... --whirr-- you'll be disappointed."
            - else:
                - chat "--whirr-- Keep your hands to yourself and I'll keep my clamps to mine."
        - narrate "<&hover[Click Me!]><&click[Do you have any work?]><&e>*Ask about work*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Goodbye.]><&c>*Say Goodbye*<&f><&end_click><&end_hover>"
RobotmanThanks:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - if <[value]> >= 0:
            - if <[value]> >= 50:
                - if <[value]> >= 150:
                    - if <[value]> >= 300:
                        - chat "There's more like me. We're out here working every day. Use your sway... make this better for us."
                    - else:
                        - chat "Perhaps there's --brzzt-- hope for the future yet. Use your power, become the change."
                - else:
                    - chat "You have good prospects, <proc[GetCharacterName].context[<player>]>. Don't forget us when you go become famous."
            - else:
                - chat "I appreciate the help. It's not everyday we automata live longer than projected."
        - else:
            - if <[value]> <= -150:
                - if <[value]> <= -350:
                    - chat "How dare you show your face around here? We heard what --brrzzt- you did. Get out of here. Go!"
                    - stop
                - else:
                    - chat "Thanks for the help... but clean your act up. You can't go far without friends."
            - else:
                - chat "There's rumors about you. I hope you continue to prove them wrong. We need more sympathizers in the world."

RobotmanHello3:
    type: task
    script:
        - chat "Hello <proc[GetCharacterName].context[<player>]>. Did you bring the ore?"
        - narrate "<&hover[Click Me!]><&click[ore]><&e>*Give them the ore*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Can you remind me what you needed assistance with?]><&c>*Ask for a reminder*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Goodbye.]><&a>*Say Goodbye*<&f><&end_click><&end_hover>"

RobotmanGoodbye:
    type: task
    speed: instant
    script:
        - random:
            - chat "*The automata grunts, returning to their work.*"
            - chat "Take care, traveler."
            - chat "*The automata gives a squeaky nod.*"
            - chat "Goodbye, <proc[GetCharacterName].context[<player>]>"

RobotmanPitch:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - if <[value]> <= -350:
            - chat "Work? Why don't you --bzzt-- just seal my coin from me, thief. We've heard about you."
            - wait 3s
            - chat "Go on. Get out of here."
            - stop
        - else:
            - chat "Work? From a slave like me? I suppose there could be something I could ask... although it is personal."
            - wait 1s
            - chat "Us machines, we run off these engines. --Whirr-- They rely on the kinetic ore which powers most things around here."
            - wait 1s
            - chat "My ore is beginning to lose it's spark, however --bzzt-- due to the conditions around here, I can't exactly walk out and get my own. It's ironic that they give you life, but don't give you the tools to prolong --whirr-- it."
            - wait 1s
            - chat "If you have the time... --bzzt-- If you could bring me some pieces of simple kinetic ore... It would prolong my life."
        - narrate "<&hover[Click Me!]><&click[Sure, I can do that. I accept your quest.]><&e>*Accept The Quest*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[I must decline.]><&c>*Decline the Quest*<&f><&end_click><&end_hover>"
        
RobotmanRemind:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - chat "Work? From a slave like me? I suppose there could be something I could ask... although it is personal."
        - wait 1s
        - chat "Us machines, we run off these engines. --Whirr-- They rely on the kinetic ore which powers most things around here."
        - wait 1s
        - chat "My ore is beginning to lose it's spark, however --bzzt-- due to the conditions around here, I can't exactly walk out and get my own. It's ironic that they give you life, but don't give you the tools to prolong --whirr-- it."
        - wait 1s
        - chat "If you have the time... --bzzt-- If you could bring me some pieces of simple kinetic ore... It would prolong my life."
        - narrate "<&hover[Click Me!]><&click[Hello.]><&e>*Say Hello*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Can you remind me what you needed assistance with?]><&c>*Ask for a reminder*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Goodbye.]><&a>*Say Goodbye*<&f><&end_click><&end_hover>"
RobotmanAccept:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - if <[value]> >= 0:
            - if <[value]> >= 50:
                - if <[value]> >= 150:
                    - if <[value]> >= 300:
                        - chat "I don't know why you wish to help me, as --whirr-- I'm sure you have better things, but I appreciate it, <proc[GetCharacterName].context[<player>]>"
                    - else:
                        - chat "I have full --bzzt-- faith in you. Please, do what you can."
                - else:
                    - chat "I wish not to get my spirits, or whatever spirit I have, up. However, your actions bring me hope."
            - else:
                - chat "I appreciate this, traveler. I will pay you what I can for this task."
        - else:
            - if <[value]> <= -150:
                - if <[value]> <= -350:
                    - chat "Even though I am just some physical --whirr-- slave, I refuse to provide to a criminal like you. Clean yourself up."
                    - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                    - zap step:1 s@RobotmanInteract player:<player>
                    - stop
                - else:
                    - chat "I wish not to get my spirits, or whatever spirit I have, up. However, your actions bring me hope."
            - else:
                - chat "I appreciate this, traveler. I will pay you what I can for this task."
        - run AddActiveQuest def:<player>|RobotmanGuideBook
        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
        - zap step:3 s@RobotmanInteract player:<player>
            
RobotmanDecline:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - random:
            - chat "I understand. Not a real body, not your problem. Get out of here."
            - chat "--whirr-- If this is what you desire. I guess I am exchangable after all."
            - chat "I pray one day you perish and suffer this pain, too. Maybe then you'll understand."
            - chat "I don't know what I expected. Go on, then."