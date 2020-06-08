# Quest Template
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.0
# Quest Template Prototype
# Allows for quick and easy setup of Quests

#====================================================#
#======================NPC Container=================#
#====================================================#
CoalRunning1Assignment:
    type: assignment
    actions:
        on assignment:
        - narrate "Assignment set!"
        - trigger name:proximity state:true
        on click:
        - narrate "Hello!" targets:<server.match_player[Insilvon]>
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 CoalRunning1Interact

CoalRunning1Interact:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hey there stranger. You looking for work?"
                        - narrate "<&click[Yes]><&a>[Yes]<&end_click><&f> | <&click[No.]><&a>[No]<&end_click><&f>"
                2:
                    trigger: /Regex:No|Goodbye/.
                    script:
                        - chat "Understood. Take it easy, traveler."
                3:
                    trigger: /Regex:Yes|Yeah/, I'm looking for work.
                    script:
                        - chat "Glad to hear it. We're storing some supplies for an upcoming settlement."
                        - wait 1s
                        - chat "I need you to bring me a stack of coal. I'll pay you better than the market rate for it."
                        - narrate "<&click[Accept]><&a>[Accept the Quest]<&end_click><&f> | <&click[Decline]><&a>[Decline the Quest]<&end_click><&f>"
                        - zap 2
        2:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "I need you to bring me a stack of coal. I'll pay you better than the market rate for it."
                        - narrate "<&click[Accept]><&a>[Accept the Quest]<&end_click><&f> | <&click[Decline]><&a>[Decline the Quest]<&end_click><&f>"
                2:
                    trigger: I /Regex:Accept/.
                    script:
                        - chat "Wonderful. I look forward to your goods."
                        - run AddActiveQuest def:<player>|CoalRunning1ActiveItem
                        - zap 3
                3:
                    trigger: I /Regex:Decline/
                    script:
                        - chat "Understood. We'll be here. Take it easy."
                        - zap 1
                4:
                    trigger: /Regex:Goodbye/
                    script:
                        - chat "Understood. We'll be here. Take it easy."
                        - zap 1

        3:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Welcome back. Do you have that stack of coal for me?"
                        - narrate "<&click[Yes.]><&a>[Turn in the Coal]<&end_click><&f> | <&click[No.]><&a>[Say No]<&end_click><&f>"
                2:
                    trigger: /Regex:Yes/.
                    script:
                        - if <player.inventory.contains[coal].quantity[64]>:
                            - chat "Wonderful! I'll take that and make sure it sees good use. Here's your payment."
                            - take coal quantity:64
                            - money give quantity:500
                            - chat "I'll be here whenever you want to turn in more."
                            - run RemoveActiveQuest def:<player>|CoalRunning1ActiveItem
                            - if !<player.flag[CompletedQuestItems].contains[CoalRunning1CompletedItem]>:
                                - run AddCompletedQuest def:<player>|CoalRunning1CompletedItem
                            - zap 1
                        - else:
                            - chat "It doesn't look like you've got the supplies. Remember, I need a stack of coal. Come back when you have it!"
                3:
                    trigger: /Regex:No|Goodbye/.
                    script:
                        - chat "Take it easy."
#====================================================#
#======================QuestItems====================#
#====================================================#
CoalRunning1GuideBook:
    type: book
    author: Active Quest
    title: Coal Running
    signed: yes
    text:
        - "After arriving at Waystation 4, I met a man who asked me to deliver him a stack of coal."
        - "He said I could bring it to him at -2445, -127. He'd pay me more than the typical sell price."
CoalRunning1QuestCompleted:
    type: book
    author: Completed Quest
    title: Coal Running
    signed: yes
    text:
        - "I delivered a decent coal shipment to Waystation 4."
CoalRunning1ActiveItem:
    type: item
    material: written_book
    book: CoalRunning1GuideBook
CoalRunning1CompletedItem:
    type: item
    material: written_book
    book: CoalRunning1QuestCompleted