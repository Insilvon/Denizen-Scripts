# Disease Proof of Concept
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.0
# Creates, manages, and enacts custom diseases to use on Aetheria.
# Internal system will inflict players with diseases, then run "symptoms" of increasing severity
# Custom cures must be made and used to cure the diseases

WorldTest:
  type: world
  events:
    on player places sand|stone:
      - narrate <player.item_in_hand>
DiseaseController:
  type: world
  events:
    # on player fires a disease trigger:
    #   - run Disease Script
# MISC EVENTS
    on player right clicks with glass_bottle:
      - if <player.location.cursor_on.material.contains[m@water]>:
        - give DirtyWater
        - determine cancelled
    on player picks up FakePoop|FakeBlood|FakeVomitBase|FakeVomitChunk1|FakeVomitChunk2:
      - determine cancelled
    on FakePoop|FakeBlood spawns:
      - wait 15s
      - remove <context.entity>
    on FakeVomitBase|FakeVomitChunk1|FakeVomitChunk2 spawns:
      - wait 10s
      - remove <context.entity>
    on FakePoop|FakeBlood|FakeVomitBase|FakeVomitChunk1|FakeVomitChunk2 merges:
      - determine cancelled
    on player consumes DirtyWater:
      - narrate "*You start to feel your stomach churn*"
      - flag player Sick
      - run SickController
    # Diseases

    on player damaged by FALL:
      - if !<player.has_flag[Splinter]>:
        - define chance:<util.random.int[0].to[13]>
        - if <[chance]> == 1:
          - flag player Splinter
          - narrate "<&2>You have gotten a nasty splinter."
          - run SplinterController

    on player consumes BasicPoison:
      - narrate "Running!"
      - flag player Poisoned:1
      - run PoisonController

    on player consumes item:
      - if !<player.has_flag[FoodPoisoning]>:
        - if <context.item.material> == m@rotten_flesh:
          - narrate "Ew, you ate that?"
          - if <util.random.int[0].to[1]> == 1:
            - flag player FoodPoisoning
            - narrate "<&2>Your stomach starts to grumble and churn. You have fallen ill with food poisoning."
            - run FoodPoisoningController
          - else:
            - narrate "You're okay, for now"
        - else:
          #2% chance of food poisoning in regular situations
          - if <util.random.int[0].to[50]> == 1:
            - flag player FoodPoisoning
            - narrate "<&2>Your stomach starts to grumble and churn. You have fallen ill with food poisoning."
            - run FoodPoisoningController
    # Cures

    on player consumes CureAll:
      - narrate "You are cured"
      - run CureAllDiseases

    on player consumes BasicPoisonCure:
      - narrate "Reducing Severity!"
      - if <player.flag[Poisoned].is[LESS].than[4]>:
        - flag player Poisoned:!
      - else:
        - flag player Poisoned:-:3
    on player right clicks with Tweezers:
      - if <player.has_flag[Splinter]>:
        - take Tweezers
        - flag player Splinter:!
        - narrate "<&2>*You delicately remove the splinter. You feel at one with the world again.*"
      - else:
        - random:
          - narrate "<&2>*You take the tweezers and pluck some particularly nasty looking eyebrows.*"
          - narrate "<&2>*Carefully, you pop that grotesque pimple on your cheek. Pus oozes everywhere!*"
          - narrate "<&2>*With a steady hand, you go to remove the ingrown hair on your inner leg. But lo! You have poked your own skin! You writhe in pain!*"
          - narrate "<&2>*With clinical precision, you remove the small bit of leaf that got trapped under your disgusting toenail.*"
          - narrate "<&2>*You absent-mindedly snip at the air, trying to hear the soft sound of metal clanking together.*"

# INDIVIDUAL CONTROLLERS
SampleController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s

PoisonController:
  type: task
  script:
    # You can use the Poisoned Flag to adjust potency
    - define counter:0
    - while <player.has_flag[Poisoned]>:
      - define counter:+:1
      # Run your effects here
      - narrate "Current Severity is <player.flag[Poisoned]>"
      - if <[counter]> == 4:
        - flag player Poisoned:+:1
        - define counter:0
      - wait 2s

CureAllDiseases:
  type: task
  script:
    - flag player Sick:!
    - flag player Poisoned:!
    - flag player Splinter:!
    - flag player FoodPoisoning:!
SickController:
  type: task
  script:
    - while <player.has_flag[Sick]>:
      - narrate "You are sick"
      - wait 5s

# REAL CONTROLLERS
FoodPoisoningController:
  type: task
  script:
    - define counter:0
    - while <player.has_flag[FoodPoisoning]>:
      - define counter:+:1
      - random:
        - run Diharrea
        - run Vomiting
      - if <[counter]> == 10:
        - flag player FoodPoisoning:!
      - wait 10s
SplinterController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[Splinter]>:
      - define counter:+:1
      - wait 2s
      - random:
        - narrate "<&a>You feel an annoying itch in your arm."
        - narrate "<&a>You feel a frustrating itch behind your ear. Is it even possible to get splinters there?"
        - narrate "<&a>That fall is still biting you. The small fleck of stray bark scratches at your inner flesh."
        - narrate "<&a>Ow. Owwwww. OWWWWWWWWW. GET IT OUT."
        - narrate "<&a>This is literally the worst thing. Take it out. It's going to drive you crazy."
        - narrate "<&a>Must... resist... urge... to... scratch..."
        - narrate "<&a>TAKE ME OUT"
      # Run your effects here
      - hurt 0.1
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
FluController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
DysenteryController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
PneumoniaController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s

FrostbiteController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
FungalInfectionController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
BrokenLegController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
BrokenArmController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
BrokenSpineController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
ArrowWoundsController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
SymforaPoisoningController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
CurseController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s

KuruController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
BotulismController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
MeaslesController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
CandiruController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
CHSController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
SexualDysfunctionController:
  type: task
  script:
    # Setup
    - define severity:1
    - define counter:0
    # Main Loop
    - while <player.has_flag[SampleFlag]>:
      - define counter:+:1
      # Run your effects here
      - if <[counter]> == 4:
        - define severity:+:1
        - define counter:0
      - wait 5s
# Effect Tasks
Diharrea:
  type: task
  speed: 3t
  script:
    - random:
      - narrate "<&a>*A horrendous gurgling sound fills the air*" target:<player.location.find.players.within[10.10]>
      - narrate "<&a>*The sound of human gas expulsion echoes in the area*" target:<player.location.find.players.within[10.10]>
      - narrate "<&a>*A putrid stench of human feces eminates near you*" target:<player.location.find.players.within[10.10]>
    - drop FakePoop <player.location>
    - drop FakeBlood <player.location>
    - drop FakePoop <player.location>
    - drop FakeBlood <player.location>
    - drop FakePoop <player.location>
    - drop FakeBlood <player.location>
Vomiting:
  type: task
  speed: 3t
  script:
    - random:
      - execute as_server "sudo <player.name> c:*Burp*"
      - execute as_server "sudo <player.name> c:*Bleeeeech*"
      - execute as_server "sudo <player.name> c:*vomits*"
      - execute as_server "sudo <player.name> c:*proceeds to blow chunks all over the ground*"
      - execute as_server "sudo <player.name> c:*hunches over, vomiting in a disgusting spray*"
    - cast confusion d:5s p:100
    - drop FakeVomitBase <player.location>
    - drop FakeVomitChunk1 <player.location>
    - drop FakeVomitBase <player.location>
    - drop FakeVomitChunk2 <player.location>
    - drop FakeVomitBase <player.location>
    - drop FakeVomitBase <player.location>
    - drop FakeVomitChunk1 <player.location>
    - drop FakeVomitBase <player.location>
    - drop FakeVomitChunk1 <player.location>
    - drop FakeVomitBase <player.location>
    - drop FakeVomitChunk2 <player.location>
    - drop FakeVomitBase <player.location>
    - drop FakeVomitBase <player.location>
    - drop FakeVomitChunk1 <player.location>
# CUSTOM ITEMS

CureAll:
  type: item
  material: potion
  display name: Cure All

DirtyWater:
  type: item
  material: potion[potion_effects=li@WATER,false,false]
  display name: Dirty Water

BasicPoison:
  type: item
  material: potion
  display name: Definitely Not A Poison

BasicPoisonCure:
  type: item
  material: potion
  display name: Definitely not a cure

FakePoop:
  type: item
  material: cocoa_beans
FakeBlood:
  type: item
  material: redstone

FakeVomitBase:
  type: item
  material: glowstone_dust
FakeVomitChunk1:
  type: item
  material: pumpkin_seeds
FakeVomitChunk2:
  type: item
  material: red_dye

Tweezers:
  type: item
  material: iron_nugget
  Display Name: Medical Tweezers
  lore:
    - To be used on the extraction
    - of rather irritating and
    - unfortunate splinters.


# Commands

FadeToBlack:
  type: command
  name: ftb
  description: A ~funky~ command for when you need to get it on.
  usage: /ftb
  aliases:
    - sex
    - fadetoblack
  script:
    - narrate "<&c>Bow-Chicka-Wow-Wow..."
    - cast blindness d:5s p:100
