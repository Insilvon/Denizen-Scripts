CrankshaftHead:
    type: item
    material: player_head[skull_skin=e3974081-9956-4aef-a45d-6e6337da7d69|ewogICJ0aW1lc3RhbXAiIDogMTU4OTUxMjExMzU3MywKICAicHJvZmlsZUlkIiA6ICIzM2ViZDMyYmIzMzk0YWQ5YWM2NzBjOTZjNTQ5YmE3ZSIsCiAgInByb2ZpbGVOYW1lIiA6ICJEYW5ub0JhbmFubm9YRCIsCiAgInNpZ25hdHVyZVJlcXVpcmVkIiA6IHRydWUsCiAgInRleHR1cmVzIiA6IHsKICAgICJTS0lOIiA6IHsKICAgICAgInVybCIgOiAiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS9hMjE2YTI5ZGZlMzNjZGYwZjhiYmFhNTFkNzNhODRiNzAxZTY4MGQzNTBlNmI1M2YzOTE0ZDhjYjg5YmVhY2IyIgogICAgfQogIH0KfQ==]
    display name: <&b>Master Crankshaft<&sq>s Head
    lore:
        - The head of the
        - afflicted Robonoid
        - Master Crankshaft.
GiveCustomMap:
    type: task
    script:
        - map new:skyworld_v2 image:lucky.png resize save:map
        - give filled_map[map=<entry[map].created_map>]


FixCandles:
    type: task
    script:
        - foreach <server.list_notables> as:theNote:
            - if <[theNote].contains_text[Candle]>:
                - note remove as:<[theNote]>
        - foreach <server.list_flags> as:theFlag:
            - if <[theFlag].contains_text[Candle]>:
                - flag server <[theFlag]>:!


Bloop:
    type: command
    name: bloop
    usage: /bloop
    script:
        - if <player.has_flag[Bloop]>:
            - flag player Bloop:!
            - teleport <player> l@-4316,155,897,skyworld_v2
        - else:
            - flag player Bloop
            - teleport <player> l@-7804,116,1840,skyworld_v2

FlagCleanup:
    type: task
    script:
        - foreach <server.list_flags> as:flag:
            - if <[flag].contains_text[Grapple_Arrow]> || <[flag].contains_text[Rope_Arrow]>:
                - flag server <[flag]>:!

MCLTest:
    type: task
    script:
        - narrate "<&hover[Press This]><&click[https://denizenscript.com].type[open_url]>Option One<&end_click><&end_hover> | <&hover[Or This]><&click[/dnpc]>Option Two<&end_click><&end_hover>"
        - narrate "<&hover[Click Me!]><&click[Tell me about yourself.]>Ask about their history.<&end_click><&end_hover> | <&hover[Click Me!]><&click[I think you should leave.]>Ask them to stop following you.<&end_click><&end_hover>"

CrystalSwitch:
    type: item
    material: diamond
    display name: Swap Tool
CrystalPuzzleWorld:
    type: world
    events:
        on player right clicks oak_button:
            # - if <context.location> == l@-39,81,-410,eventworld:
            - if <context.location> == l@1056,55,-1489,aetheria:
                - if <server.has_flag[EventOne]>:
                    - teleport <player.location.find.players.within[<30.30>]> l@-339,10,-390,new_buildworld
            - if <context.location> == l@-341,11,-390,new_buildworld:
                - if <server.has_flag[EventOne]>:
                    - teleport <player.location.find.players.within[<30.30>]> l@-7810,116,1840,skyworld_v2
        on player left clicks block with crystalswitch:
            - foreach li@l@-23,85,-447,eventworld|l@-23,85,-449,eventworld|l@-23,85,-451,eventworld|l@-23,83,-447,eventworld|l@-23,83,-449,eventworld|l@-23,83,-451,eventworld|l@-23,81,-447,eventworld|l@-23,81,-449,eventworld|l@-23,81,-451,eventworld as:position:
                - modifyblock red_stained_glass <[position]>
        on player right clicks block with crystalswitch:
            - if <cu@CrystalPuzzle.contains_location[<context.location>]>:
                - define pos1:l@-23,85,-447,eventworld
                - define pos2:l@-23,85,-449,eventworld
                - define pos3:l@-23,85,-451,eventworld
                - define pos4:l@-23,83,-447,eventworld
                - define pos5:l@-23,83,-449,eventworld
                - define pos6:l@-23,83,-451,eventworld
                - define pos7:l@-23,81,-447,eventworld
                - define pos8:l@-23,81,-449,eventworld
                - define pos9:l@-23,81,-451,eventworld
                - if <context.location> == <[pos1]>:
                    - run swapcrystal def:<[pos1]>
                    - run swapcrystal def:<[pos2]>
                    - run swapcrystal def:<[pos4]>
                    - if <proc[CheckAllCrystals]>:
                        - narrate "*Ding*" targets:<[pos1].find.players.within[<20.20>]>
                    - stop
                - if <context.location> == <[pos2]>:
                    - run swapcrystal def:<[pos2]>
                    - run swapcrystal def:<[pos1]>
                    - run swapcrystal def:<[pos3]>
                    - run swapcrystal def:<[pos5]>
                    - if <proc[CheckAllCrystals]>:
                        - narrate "*Ding*" targets:<[pos1].find.players.within[<20.20>]>
                    - stop
                - if <context.location> == <[pos3]>:
                    - run swapcrystal def:<[pos3]>
                    - run swapcrystal def:<[pos2]>
                    - run swapcrystal def:<[pos6]>
                    - if <proc[CheckAllCrystals]>:
                        - narrate "*Ding*" targets:<[pos1].find.players.within[<20.20>]>
                    - stop
                - if <context.location> == <[pos4]>:
                    - run swapcrystal def:<[pos4]>
                    - run swapcrystal def:<[pos1]>
                    - run swapcrystal def:<[pos5]>
                    - run swapcrystal def:<[pos7]>
                    - if <proc[CheckAllCrystals]>:
                        - narrate "*Ding*" targets:<[pos1].find.players.within[<20.20>]>
                    - stop
                - if <context.location> == <[pos5]>:
                    - run swapcrystal def:<[pos5]>
                    - run swapcrystal def:<[pos2]>
                    - run swapcrystal def:<[pos4]>
                    - run swapcrystal def:<[pos6]>
                    - run swapcrystal def:<[pos8]>
                    - if <proc[CheckAllCrystals]>:
                        - narrate "*Ding*" targets:<[pos1].find.players.within[<20.20>]>
                    - stop
                - if <context.location> == <[pos6]>:
                    - run swapcrystal def:<[pos6]>
                    - run swapcrystal def:<[pos3]>
                    - run swapcrystal def:<[pos5]>
                    - run swapcrystal def:<[pos9]>
                    - if <proc[CheckAllCrystals]>:
                        - narrate "*Ding*" targets:<[pos1].find.players.within[<20.20>]>
                    - stop
                - if <context.location> == <[pos7]>:
                    - run swapcrystal def:<[pos7]>
                    - run swapcrystal def:<[pos4]>
                    - run swapcrystal def:<[pos8]>
                    - if <proc[CheckAllCrystals]>:
                        - narrate "*Ding*" targets:<[pos1].find.players.within[<20.20>]>
                    - stop
                - if <context.location> == <[pos8]>:
                    - run swapcrystal def:<[pos8]>
                    - run swapcrystal def:<[pos7]>
                    - run swapcrystal def:<[pos5]>
                    - run swapcrystal def:<[pos9]>
                    - if <proc[CheckAllCrystals]>:
                        - narrate "*Ding*" targets:<[pos1].find.players.within[<20.20>]>
                    - stop
                - if <context.location> == <[pos9]>:
                    - run swapcrystal def:<[pos9]>
                    - run swapcrystal def:<[pos8]>
                    - run swapcrystal def:<[pos6]>
                    - if <proc[CheckAllCrystals]>:
                        - narrate "*Ding*" targets:<[pos1].find.players.within[<20.20>]>
                    - stop
SwapCrystal:
    type: task
    definitions: position
    speed: instant
    script:
        - if <[position].block.material.name> == RED_STAINED_GLASS:
            - modifyblock <[position]> CYAN_STAINED_GLASS
            - stop
        - if <[position].block.material.name> == CYAN_STAINED_GLASS:
            - modifyblock <[position]> RED_STAINED_GLASS
            - stop
CheckAllCrystals:
    type: procedure
    script:
        - foreach li@l@-23,85,-447,eventworld|l@-23,85,-449,eventworld|l@-23,85,-451,eventworld|l@-23,83,-447,eventworld|l@-23,83,-449,eventworld|l@-23,83,-451,eventworld|l@-23,81,-447,eventworld|l@-23,81,-449,eventworld|l@-23,81,-451,eventworld as:position:
            - if <[position].block.material.name> != CYAN_STAINED_GLASS:
                - determine false
        - determine true

EventOneJournal:
    type: item
    material: EventOneBook
    display name: John Mana<&sq>s Journal

EventOneBook:
    type: book
    title: Log 163
    author: John Mana
    signed: true
    text:
    -  I<&sq>ve discovered this strange tomb that I believe belonged to the ancient natives of Aetheria. While it<&sq>s common knowledge that they worshipped 4 gods, many do not know that those gods held domain over the basic elements of the world. Earth is Geos, Air is Manaia, Water is Pagos, and Fire
    - is Ignos. I have reason to believe that there were actually 2 more gods that, while not worshipped to the scale of the 4 main gods, were still considered quite powerful and important in the hierarchy of the gods.
    - I<&sq>m still researching who they might be and what their domain was, but from what I<&sq>ve gathered, they seem almost MORE powerful than the main 4. Luckily, I<&sq>ve found some information in this chamber that I<&sq>ve been able to translate fairly well. It reads;
	- Ignos, who<&sq>s passion knows no bounds. Their ferocity is massive, and inspires many of the worlds warriors to strike hard and true, no matter the foe. This stone requires a great warrior, who<&sq>s skill and patience knows no adversary.
    - Pagos, who<&sq>s calm demeanor is matched only by their imagination. The power Pagos possesses is unknown, yet feared all the same. This stone requires a quick mind, and a level head.
    - Manaia, who<&sq>s elegance is unmatched in the worlds above. They strive to be the best at everything, and at nothing. Equilibrium at its finest. This stone requires a clear head, and a persistence that challenges the very ground we walk upon. (I found this stone in a room that I am now
    - unable to return to. Very difficult jumping was involved!)
    - Geos, who<&sq>s deeds match all the stars in the heavens. Their raw power is so raw and powerful, they say the ground we walk on is the hair on his head! This stone requires an unpushing attitude, and a not so elegant solution.
    - Skortana, who takes as easily as her brother gives, requires the strangest and most powerful of worship. Who only accepts, and never gives. The stone seeks champions, or those worthy enough to end what is sacred. 
    - And Zoi, who seems to be the most powerful and important. The brother who works the hardest, and is always taken for granted. The stone seeks what<&sq>s always been with you, since day one.
    - I will continue to study and investigate this area. There has to be more to this place than just a nice looking wall and this… strange pattern near the entrance. I<&sq>ll have to write that down. John Mana.”

EventOneBook2:
    type: book
    title: Log 164
    author: John Mana
    signed: true
    text:
    - After many days of research and analyzing, I<&sq>ve discovered something groundbreaking. Truly marvelous! 
	- Magic is an incredibly complicated thing, correct? Well what if I told you, that magic is not a thing, but more like… Radiation.
    - What I mean is, I believe magic comes FROM something. It isn<&sq>t a force that surrounds us at all times, no no! Magic, and apparently life as we know it, comes from things named “Crystals of Aether”. These crystals are quite large and very very powerful. These things are scattered 
    - around the world, but are invisible to the naked eye. It<&sq>s as if these crystals reside in another realm of existence!
	- However, I discovered that they aren<&sq>t… okay. I<&sq>ve come to find out that these crystals are… How do I put this… Off Balance?
    - It<&sq>s as if an event (Maybe the great explosion of Sonn?) has shifted theme ever so slightly, and now they aren<&sq>t exactly working the way they should. This could be caused by many things, but I wonder, is this because of… the synfora? Was it really that powerful that it 
    - could shake the very foundation of reality?
	- Regardless, it seems like magic can only be performed by USING the crystals, or at least a piece of them. 
	- It<&sq>s also possible that these crystals may create antibodies to protect themselves. I do not know what is wrong with the crystal I<&sq>m researching, but I fear I may need to evacuate soon. I just hope whoever comes here after me, stays safe.
	- Best of luck to those who wander.
	- John Mana
EventOneBook3:
    type: book
    title: Poem
    author: Unknown
    signed: true
    text:
    - “I am used to grow life, yet thrown away on sight. I am essential to humans, though I carry no might. I always pester, and sometimes weigh pounds, but as long as there<&sq>s life, I will always be around. What am I?”