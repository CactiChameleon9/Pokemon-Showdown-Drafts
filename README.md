# Pokemon Showdown Drafts

A Gnome/Gtk styled Godot app for [Pokemon Showdown](https://play.pokemonshowdown.com)!  
Grab a friend, connect up on a LAN (or do offline mode) and have a Draft-like 1v1 Pokemon Battle competition!

![image](https://user-images.githubusercontent.com/51231053/169382437-e28c3bb1-44a9-493d-8457-dcc7bd724768.png)


## How it works
1. Players connect (same network only, for now. Solutions like tailscale could work for over the internet)
2. Each player is given a random pair of Pokemon
2. Player 1 and 2 both choose a pokemon out of their pair
3. The chosen pokemon is added to their own team, and the other is sent to the other player
4. This is done 3 times, each turn adding 2 pokemon to both teams
5. Once finished, the team's export text is then displayed and copied to clipboard


## Downloads
Visit the releases page: [github.com/CactiChameleon9/Pokemon-Showdown-Drafts/releases](https://github.com/CactiChameleon9/Pokemon-Showdown-Drafts/releases)


## Notable Features
- Supports up to Gen 9 (_latest gen!_)
- Modern UI
- Offline and LAN Modes
- Official artwork for each pokemon (from @PokeAPI)
- Pokemon Pools Manager
  - Add custom pools of Pokemon to draft between
  - Great selection of included pools (thanks @sleepy-poc)
  - Select multiple pools to mix them!
  

## Building
Clone the repo with submodules (this will download ~1.4GiB because PokeAPI sprites)
```
git clone --recurse-submodules https://github.com/CactiChameleon9/Pokemon-Showdown-Drafts
```

Then import the project into **Godot 3** (3.5 is recommended as of now)  
You can then run/export the project as normal in godot

Note: importing the assets can take a long time - I recommend leaving godot open while you go and make a hot beverage 

## Contributing
This is more of a personal project, but I guess if you have any code suggestions... feel free to make a PR and I will think about this more :laugh:


## Credits
- Godot for their amazing engine
- Pokemon Showdown for their fun platform
- PokeApi for their sprites
