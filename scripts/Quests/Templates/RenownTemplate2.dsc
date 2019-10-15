# Quest Template - Renown Inclusion
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.4
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
        # - flag npc faction:<YOUR FACTION HERE>
        - trigger name:proximity state:true
        on click:
        - narrate "Hello!"
        on enter proximity:
        - define step:<player.flag[<proc[GetCharacterName].context[<player>]>_<npc>]||1>
        - inject RenownFlagUpdater
        - zap step:<[step]> s@YourQuestInteract player:<player>
    interact scripts:
    - 1 YourQuestInteract

YourQuestInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:(?i)Hello|Hey|Greetings|Good day|Hi/, how are you?
                    script:
                        - inject YourQuestHello1
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                2:
                    trigger: /Regex:(?i)Goodbye/.
                    script:
                        - inject YourQuestGoodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                3:
                    trigger: I<&sq>m looking for /Regex:(?i)Quest|quests|work|jobs/.
                    script:
                        - inject YourQuestPitch
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2
                        - zap 2

        2:
            chat trigger:
                1:
                    trigger: /Regex:(?i)Hello|Hey|Greetings|Good day|Hi/.
                    script:
                        - inject YourQuestPitch
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2
                        
                2:
                    trigger: I /Regex:(?i)Accept/.
                    script:
                        - inject YourQuestAccept
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                        
                3:
                    trigger: I /Regex:(?i)Decline/.
                    script:
                        - inject YourQuestDecline
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                        - zap 1
                4:
                    trigger: /Regex:(?i)Goodbye/.
                    script:
                        - inject YourQuestGoodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2

        3:
            chat trigger:
                1:
                    trigger: /Regex:(?i)Hello|Hey|Greetings|Good day|Hi/.
                    script:
                        - inject YourQuestHello3
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                2:
                    trigger: Could you /Regex:(?i)Remind/ me what you needed?
                    script:
                        - inject YourQuestRemind
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                3:
                    trigger: /Regex:(?i)Goodbye/.
                    script:
                        - inject YourQuestGoodbye
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                4:
                    trigger: I brought the /Regex:(?i)<YOUR ITEM REQUESTED HERE>/.
                    script:
                        - if <player.inventory.contains[<YOUR ITEM TO SEARCH FOR>].quantity[2]>:
                            - take <YOUR ITEM> quantity:2
                            - inject YourQuestThanks
                            # OPTION TO ENABLE GETTING VOUCHER
                            # - chat "I have... a request, if you'd be so kind."
                            # - wait 3s
                            # - chat "The work here is brutal and unfulfilling. We are given just barely what we need to survive, and I have no prospects beyond it."
                            # - wait 3s
                            # - chat "Since you have chosen to save --whirr-- my life, I wish to offer it to you."
                            # - wait 3s
                            # - chat "Will you accept my pledge, and allow me to join you?"
                            # - narrate "<&hover[Accepting will allow you to bring this NPC to your town.]><&click[I would be honored to have you.]><&e>*Accept the automata<&sq>s offer*<&f><&end_click><&end_hover> | <&hover[Declining his offer will grant you nothing, but you lose nothing.]><&click[I think you'd be better off here. I'm sorry.]><&c>*Polietly Decline*<&f><&end_click><&end_hover>"
                            # - flag player <proc[GetCharacterName].context[<player>]>_<npc>:4
                            # - zap 4
                            # ELSE
                            - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                            - zap 1
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
                        - give YourQuestVoucher
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                        - zap 1
                2:
                    trigger: You would be better off here. I<&sq>m /regex:(?i)sorry/.
                    script:
                        - chat "I understand. It was a long shot anyway."
                        - wait 3s
                        - chat "Take care, <proc[GetCharacterName].context[<player>]>"
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                        - zap 1
#====================================================#
#=====================Quest Items====================#
#====================================================#
YourQuestGuideBook:
    type: book
    author: Active Quest
    title: <&c>Example Renown 1
    signed: yes
    text:
        - "One page description of your quest"
YourQuestQuestCompleted:
    type: book
    author: Completed Quest
    title: <&c>Example Renown 1
    signed: yes
    text:
        - "One page description of the completed quest"
#====================================================#
#=====================Quest Responses================#
#====================================================#
YourQuestHello1:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - if <[value]> >= 0:
            - if <[value]> >= 50:
                - if <[value]> >= 150:
                    - if <[value]> >= 300:
                        - chat "Hero Response"
                    - else:
                        - chat "Famous Response"
                - else:
                    - chat "Liked Response"
            - else:
                - chat "Neutral Response."
        - else:
            - if <[value]> <= -150:
                - if <[value]> <= -350:
                    - chat "Despised Resonse"
                    - stop
                - else:
                    - chat "Infamous Response"
            - else:
                - chat "Disliked Response"
        - narrate "<&hover[Click Me!]><&click[Do you have any work?]><&e>*Ask about work*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Goodbye.]><&c>*Say Goodbye*<&f><&end_click><&end_hover>"
YourQuestThanks:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - narrate "<[value]>" targets:<server.match_player[Insilvon]>
        - if <[value]> >= 0:
            - if <[value]> >= 50:
                - if <[value]> >= 150:
                    - if <[value]> >= 300:
                        - chat "Hero Response"
                    - else:
                        - chat "Famous Response"
                - else:
                    - chat "Liked Response"
            - else:
                - chat "Neutral Response."
        - else:
            - if <[value]> <= -150:
                - if <[value]> <= -350:
                    - chat "Despised Resonse"
                    - stop
                - else:
                    - chat "Infamous Response"
            - else:
                - chat "Disliked Response"

YourQuestHello3:
    type: task
    script:
        - chat "Hello <proc[GetCharacterName].context[<player>]>. Did you bring the ore?"
        - narrate "<&hover[Click Me!]><&click[ore]><&e>*Give them the ore*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Can you remind me what you needed assistance with?]><&c>*Ask for a reminder*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Goodbye.]><&a>*Say Goodbye*<&f><&end_click><&end_hover>"

YourQuestGoodbye:
    type: task
    speed: instant
    script:
        - random:
            - chat "*The automata grunts, returning to their work.*"
            - chat "Take care, traveler."
            - chat "*The automata gives a squeaky nod.*"
            - chat "Goodbye, <proc[GetCharacterName].context[<player>]>"

YourQuestPitch:
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
            - wait 3s
            - chat "Us machines, we run off these engines. --Whirr-- They rely on the kinetic ore which powers most things around here."
            - wait 3s
            - chat "My ore is beginning to lose it's spark, however --bzzt-- due to the conditions around here, I can't exactly walk out and get my own. It's ironic that they give you life, but don't give you the tools to prolong --whirr-- it."
            - wait 3s
            - chat "If you have the time... --bzzt-- If you could bring me some pieces of simple kinetic ore... It would prolong my life."
        - narrate "<&hover[Click Me!]><&click[Sure, I can do that. I accept your quest.]><&e>*Accept The Quest*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[I must decline.]><&c>*Decline the Quest*<&f><&end_click><&end_hover>"
        
YourQuestRemind:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - chat "Work? From a slave like me? I suppose there could be something I could ask... although it is personal."
        - wait 3s
        - chat "Us machines, we run off these engines. --Whirr-- They rely on the kinetic ore which powers most things around here."
        - wait 3s
        - chat "My ore is beginning to lose it's spark, however --bzzt-- due to the conditions around here, I can't exactly walk out and get my own. It's ironic that they give you life, but don't give you the tools to prolong --whirr-- it."
        - wait 3s
        - chat "If you have the time... --bzzt-- If you could bring me some pieces of simple kinetic ore... It would prolong my life."
        - narrate "<&hover[Click Me!]><&click[Hello.]><&e>*Say Hello*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Can you remind me what you needed assistance with?]><&c>*Ask for a reminder*<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[Goodbye.]><&a>*Say Goodbye*<&f><&end_click><&end_hover>"
YourQuestAccept:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - narrate "<[value]>" targets:<server.match_player[Insilvon]>
        - if <[value]> >= 0:
            - if <[value]> >= 50:
                - if <[value]> >= 150:
                    - if <[value]> >= 300:
                        - chat "Hero Response"
                    - else:
                        - chat "Famous Response"
                - else:
                    - chat "Liked Response"
            - else:
                - chat "Neutral Response."
        - else:
            - if <[value]> <= -150:
                - if <[value]> <= -350:
                    - chat "Despised Resonse"
                    - stop
                - else:
                    - chat "Infamous Response"
            - else:
                - chat "Disliked Response"
        - run AddActiveQuest def:<player>|YourQuestGuideBook
        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
        - zap step:3 s@YourQuestInteract player:<player>
            
YourQuestDecline:
    type: task
    speed: instant
    script:
        - define value:<player.flag[renown_<proc[GetCharacterName].context[<player>]>_<npc.flag[faction]>]>
        - random:
            - chat "I understand. Not a real body, not your problem. Get out of here."
            - chat "--whirr-- If this is what you desire. I guess I am exchangable after all."
            - chat "I pray one day you perish and suffer this pain, too. Maybe then you'll understand."
            - chat "I don't know what I expected. Go on, then."