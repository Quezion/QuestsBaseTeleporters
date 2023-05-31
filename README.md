# Quest's Base Teleporters
A mod for [Project Zomboid](https://projectzomboid.com/) which adds buildable teleporters with instantaneous right-click movement between them. Subscribe & play on [Steam's workshop.](https://steamcommunity.com/sharedfiles/filedetails/?id=2979721745)

Teleporters can be built with Electrical + Metalworking. They're disassemblable objects with a chance to break. The list of teleporters will only synchronize to all clients once every hour at `:00` and they don't yet require electricity.

Current Early Access. Implementation is inefficient and needs testing. Breakages across versions could occur but we'll try to avoid this. Will become more stable as it receives more testing & polish.

## Development

Ensure [Bababshka](https://babashka.org/) is installed & on the system path via `bb`

In order to Lint codefiles, you should also install [luacheck](https://github.com/mpeterv/luacheck) & place it on your PATH.

* `bb build` to copy modfiles in Steam workshop format at `build/`\
  This combines `steamworkshop` & `src` directories to produce a version for Steam.
* `bb release` to copy the modfiles into your `~/Zomboid/Workshop` directory.
* `bb tasks` for a list of available tasks
* `bb taskname --help` for task information & supported args

## TODOs
- [ ] Write script to "release a new version of the mod"
  - [x] Compile only modfiles into Workshop directory structure (`modname/Contents/mods/QuestBaseTeleporters/*`
  - [x] Copy `steamworkshop` to `build/` and rename to QuestBaseTeleporters
  - [x] Copy modfiles to `build/QuestBaseTeleporters/Contents/mods/QuestBaseTeleporters`
  - [ ] Copy `target/QuestBaseTeleporters` directory into `~/Zomboid/Workshop/`
  - [ ] ~~Increment mod.info version~~ Watch mod.info in Release task & copy updated file back to this repo
- [x] Find & script running a Lua linter on this repo
  - [ ] Work through Lua warnings and add global namespaces to `script/lint.clj`
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

## Tools
* Code editor ([Emacs](https://www.gnu.org/software/emacs/) [Lua Mode](https://github.com/immerrr/lua-mode) but try [IntelliJ](https://www.jetbrains.com/idea/download/) for a beginner option)
* [TileZed](https://theindiestone.com/forums/index.php?/topic/59675-latest-tilezed-worlded-and-tilesets-september-8-2022/)
* [CFR Java Decompiler](https://www.benf.org/other/cfr/)

## Guides
* [How to upload your map to the Steam workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=534034411)
* [PZWiki.net - New Tiles](https://pzwiki.net/wiki/New_Tiles)

## Contributors
* [Poltergeist](https://github.com/Poltergeistzx) & [radx5Blue](https://github.com/radx5Blue) authors of [Immersive Solar Arrays](https://github.com/Poltergeistzx/ImmersiveSolarArrays)\
  Vital code & reference on using game's GlobalObjectSystem to track runtime teleporters, lua mod architecture, & more
* [NayTec](https://steamcommunity.com/profiles/76561198031286597) & [Naia](https://steamcommunity.com/profiles/76561198133217288), authors of the [Bus Ticket mod](https://steamcommunity.com/sharedfiles/filedetails/?id=2866535182)\
  Code & reference on recording teleportable points + moving players

## Licensing
* Poster art by [DallE 2](https://openai.com/product/dall-e-2)
* Teleporter sprite downloaded under [Reshot's generous license](https://www.reshot.com/license/)
* This mod uploaded under [Spiffo's Workshop License](https://steamcommunity.com/sharedfiles/filedetails/?id=2872282653)