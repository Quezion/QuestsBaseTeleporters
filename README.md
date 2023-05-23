# Quest's Base Teleporters

A mod for [Project Zomboid](https://projectzomboid.com/) which adds buildable teleporters with instantaneous right-click movement between them. Subscribe & play on [Steam's workshop.](https://steamcommunity.com/sharedfiles/filedetails/?id=2979721745) Published on the Steam workshop.

Teleporters can be built with Electrical + Metalworking. They're disassemblable objects with a chance to break. The list of teleporters will only synchronize to all clients once every hour at `:00` and they don't yet require electricity.

Current Early Access. Implementation is inefficient and needs testing. Breakages across versions could occur but we'll try to avoid this. Will become more stable as it receives more testing & polish in the next months.

## TODOs

- [ ] Write script to "release a new version of the mod"
  - [ ] Increment mod.info version
  - [ ] Compile only modfiles into Workshop directory structure (`modname/Contents/mods/QuestBaseTeleporters/*`)
  - [ ] Copy directory into `~/ProjectZomboid/Workshop/`
- [ ] Batch hourly server -> client command of registerTeleporter into registerTeleporters
- [ ] Synchronize teleporter list in real-time
- [ ] Require electricity for Teleporters to work
- [ ] Upgrade static Teleporter sprite
- [ ] "Animate" Teleporter" by changing sprite depending on state
  - [ ] Sprites for "Powered" vs "Unpowered"
  - [ ] Sprites for `About to teleport`, `Actively teleporting`, and `Recently teleported`
- [ ] Teleportation sound effect
- [ ] Require players to move to Teleporter in order to activate
  - [ ] Setup as a TimedAction so this is riskier to escape zombies
- [ ] Add recipe magazine for learning Teleporter
- [ ] Support ModOptions
  - [ ] Teleporting could emit sound to attract zombies at destination
  - [ ] Customize required Electrical skill to make easier on fresh multiplayer servers
- [ ] Translation support

## Contributors

* [Poltergeist](https://github.com/Poltergeistzx), maintainer of [Immersive Solar Arrays](https://github.com/Poltergeistzx/ImmersiveSolarArrays)
  Tremendous code & reference on using game's GlobalObjectSystem to track runtime teleporters, lua mod architecture, & more
* [NayTec](https://steamcommunity.com/profiles/76561198031286597) & [Naia](https://steamcommunity.com/profiles/76561198133217288), authors of the [Bus Ticket mod](https://steamcommunity.com/sharedfiles/filedetails/?id=2866535182)
  Code & reference on recording teleportable points + moving players

## Licensing

* Poster art by [DallE 2](https://openai.com/product/dall-e-2)
* Teleporter sprite downloaded under [Reshot's generous license](https://www.reshot.com/license/)
* This mod uploaded under [Spiffo's Workshop License](https://steamcommunity.com/sharedfiles/filedetails/?id=2872282653)