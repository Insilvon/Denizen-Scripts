# Quest Template
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.0
# Quest Template Prototype
# Allows for quick and easy setup of Quests

#====================================================#
#======================Responses=====================#
#====================================================#
Example1Intro:
    type: task
    script:
        - chat "Hi I'm Steve I have a Quest for you"
Example1Goodbye:
    type: task
    script:
        - chat "See ya"
Example1Pitch:
    type: task
    script:
        - inject Example1Remind
        - chat "Accept/Decline"
Example1Accept:
    type: task
    script:
        - chat "Ok cool thanks"
        - run AddActiveQuest def:<player>|Example1GuideBook
Example1Decline:
    type: task
    script:
        - chat "Whatever okay"
Example1Remind:
    type: task
    script:
        - chat "Yeah can you come back and say hello"
Example1Waiting:
    type: task
    script:
        - chat "Hey thanks for that you win"
        - run AddCompletedQuest def:<player>|Example1QuestCompleted
#====================================================#
#======================NPC Container=================#
#====================================================#
Example1Assignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
        - 1 Example1Interact
Example1Interact:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - inject Example1Intro
                2:
                    trigger: /Regex:Goodbye/
                    script:
                        - inject Example1Goodbye
                3:
                    trigger: /Regex:Quest/
                    script:
                        - inject Example1Pitch
                        - zap 2
        2:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - inject Example1Pitch
                2:
                    trigger: /Regex:Accept/
                    script:
                        - inject Example1Accept
                        - zap 3
                3:
                    trigger: /Regex:Decline/
                    script:
                        - inject Example1Decline
                        - zap 1
                4:
                    trigger: /Regex:Goodbye/
                    script:
                        - inject Example1Goodbye
                        - zap 1
        3:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - inject Example1Waiting
                2:
                    trigger: /Regex:Remind/
                    script:
                        - inject Example1Pitch
                3:
                    trigger: /Regex:Goodbye/
                    script:
                        - inject Example1Goodbye
                        - zap 1
#====================================================#
#======================QuestItems====================#
#====================================================#
Example1MenuItem:
    type: item
    material: book
    display name: Your NPC<&sq>s Quest
    lore:
        - "Click to see information"
Example1GuideBook:
    type: book
    author: Active Quest
    title: Your Quest Title
    signed: yes
    text:
        - "This is what you were asked to do"
        - "Should be the same as your quest remind"
Example1QuestCompleted:
    type: book
    author: Completed Quest
    title: Your Quest Title
    signed: yes
    text:
        - "This is a one-page description of the quest. Do not exceed one page."
Cleanup:
    type: task
    script:
        - foreach <player.list_flags> as:flag:
            - flag <player> <[flag]>:!