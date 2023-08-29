# Pokemon Showdown Drafts

A Gnome styled godot app in which to players (on the same network) can select a pokemon team using a draft system.

![image](https://user-images.githubusercontent.com/51231053/169382437-e28c3bb1-44a9-493d-8457-dcc7bd724768.png)


## How it works
1. Players connect (same network only, for now. Solutions like tailscale could work for over the internet)
2. Each player is given a random pair of Pokemon
2. Player 1 and 2 both choose a pokemon out of their pair
3. The chosen pokemon is added to their own team, and the other is sent to the other player
4. This is done 3 times, each turn adding 2 pokemon to both teams
5. Once finished, the team's export text is then displayed and copied to clipboard


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
