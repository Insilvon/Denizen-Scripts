# Quest Template
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
    interact scripts:
        - 1 YourQuestInteract
TestInject:
    type: task
    definitions: <script>|<player>|<step>
    script:
        - zap <[step]> s@<[script]> player:<[player]>
YourQuestInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Ok cool thanks do the thing"
                        - zap 2
                2:
                    trigger: /Regex:Goodbye/
                    script:
                        - chat "See ya"
                3:
                    trigger: /Regex:Quest/
                    script:
                        - chat "Can u come say hello to me"
                        - chat "Accept/Decline"
                        - zap 2
        2:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Can u come say hello to me"
                2:
                    trigger: /Regex:Accept/
                    script:
                        - chat "Ok cool thanks"
                        - run AddActiveQuest def:<player>|YourQuestGuideBook
                        - zap 3
                3:
                    trigger: /Regex:Decline/
                    script:
                        - chat "Whatever okay"
                        - zap 1
                4:
                    trigger: /Regex:Goodbye/
                    script:
                        - run TestInject def:<YourQuestInteract>|<player>
        3:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hey thanks for that you win"
                        - run AddCompletedQuest def:<player>|YourQuestQuestCompleted
                        - run RemoveActiveQuest def:<player>|YourQuestGuideBook
                        - zap 1
                2:
                    trigger: /Regex:Remind/
                    script:
                        - chat "Can u come say hello to me"
                3:
                    trigger: /Regex:Goodbye/
                    script:
                        - chat "See ya"
#====================================================#
#======================QuestItems====================#
#====================================================#
YourQuestGuideBook:
    type: book
    author: Active Quest
    title: Your Quest Title
    signed: yes
    text:
        - "This is what you were asked to do"
        - "Should be the same as your quest remind"
YourQuestQuestCompleted:
    type: book
    author: Completed Quest
    title: Your Quest Title
    signed: yes
    text:
        - "This is a one-page description of the quest. Do not exceed one page."
