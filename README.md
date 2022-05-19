# Pokemon Showdown Drafts

A Gnome styled godot app in which to players (on the same network) can select a pokemon team using a draft system.


## How it works
1. Players connect (same network only, for now. Solutions like tailscale could work for over the internet)
2. Each player is given a random pair of Pokemon
2. Player 1 and 2 both choose a pokemon out of their pair
3. The chosen pokemon is added to their own team, and the other is sent to the other player
4. This is done 3 times, each turn adding 2 pokemon to both teams
5. Once finished, the team's export text is then displayed and copied to clipboard


## Building
The images are not downloaded into the repo (for obvious reasons). Pictures should be downloaded into `assets/Pokemon` and `assets/PokemonMini` (simple instructions in each folder)
The naming scheme for said files is also in `Global.gd`


## Contributing
This is more of a personal project, but I guess if you have any code suggestions... feel free to make a PR and I will think about this more :laugh:


## Credits
- Godot for their amazing engine
- Pokemon Showdown for their fun platform
