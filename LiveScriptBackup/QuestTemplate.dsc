# Quest Template
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.0
# Quest Template Prototype
# Allows for quick and easy setup of Quests

#====================================================#
#======================Responses=====================#
#====================================================#
YourQuestIntro:
    type: task
    script:
        - chat "Hi I'm Steve I have a Quest for you"
YourQuestGoodbye:
    type: task
    script:
        - chat "See ya"
YourQuestPitch:
    type: task
    script:
        - inject YourQuestRemind
        - chat "Accept/Decline"
YourQuestAccept:
    type: task
    script:
        - chat "Ok cool thanks"
        - inventory add d:in@<player>questjournal o:YourQuestMenuItem
YourQuestDecline:
    type: task
    script:
        - chat "Whatever okay"
YourQuestRemind:
    type: task
    script:
        - chat "Yeah can you come back and say hello"
YourQuestWaiting:
    type: task
    script:
        - chat "Hey thanks for that you win"
        - run AddCompletedQuest def:<player>|YourQuestMenuItem
        - zap 1
#====================================================#
#======================NPC Container=================#
#====================================================#
YourQuestAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
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
                        - inject YourQuestIntro
                2:
                    trigger: /Regex:Goodbye/
                    script:
                        - inject YourQuestGoodbye
                3:
                    trigger: /Regex:Quest/
                    script:
                        - inject YourQuestPitch
                        - zap 2
        2:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - inject YourQuestPitch
                2:
                    trigger: /Regex:Accept/
                    script:
                        - inject YourQuestAccept
                        - zap 3
                3:
                    trigger: /Regex:Decline/
                    script:
                        - inject YourQuestDecline
                        - zap 1
                4:
                    trigger: /Regex:Goodbye/
                    script:
                        - inject YourQuestGoodbye
                        - zap 1
        3:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - inject YourQuestWaiting
                2:
                    trigger: /Regex:Remind/
                    script:
                        - inject YourQuestPitch
                3:
                    trigger: /Regex:Goodbye/
                    script:
                        - inject YourQuestGoodbye
    #====================================================#
    #======================QuestItems====================#
    #====================================================#
    YourQuestMenuItem:
        type: item
        material: book
        display name: Your NPC<&sq>s Quest
        lore:
            - "Click to see information"
    YourQuestGuideBook:
        type: book
        author: Active Quest
        title: Your Quest Title
        signed: yes
        text:
            - "This is what you were asked to do"
            - "Should be the same as your quest remind"