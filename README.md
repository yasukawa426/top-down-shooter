## SURVIVE 5 MINUTES
I made this little game for me to remember how to use Godot after a ~10 month hiatus. It's just a simple top-down shooter where you have to survive 5 minutes to win. 

I'm not really satisfied with its current state, but if you check my [todo.txt](todo.txt) you can see that I started to have some pretty crazy scope creep lol. Because of that, I decided to just add some SFX and be done with it before I went crazy. Maybe I'll come back to it later if I still feel like finishing it, but idk.

While adding the SFX I went for an eerie vibe and I really liked how it turned out.

The code is also probably kinda janky.
## Gameplay Video
[![Game Screenshot](http://img.youtube.com/vi/IlokBUkKOJs/0.jpg)](https://youtu.be/IlokBUkKOJs)
## Mechanics
The game is a top-down shooter. The player can move in all four directions, aim with the mouse, and shoot with the left mouse button. The gun changes from yellow back to its normal color while the cooldown decreases. The player can also stop time lol.

The player has 5 HP, deals 2 damage per shot, and has a 0.5 second shooting cooldown.

There is currently one enemy type. Enemies chase the player and have the following base stats:

- HP: 1
- Movement speed: 200
- Damage: 1

When an enemy spawns, it is assigned a random size multiplier between 0.6 and 1.4. This multiplier affects all of its stats as well as its size, meaning that larger enemies are stronger but slower, and smaller enemies are weaker but faster. Some stats have minimum or maximum limits.
## Controlls
- WASD - Move <br/>
- Left Mouse Button - Shoot <br/>
- ESC/TAB - Timestop <br/>
- Q/E/Mouse Wheel - Zoom in/out
## Credits
Neon Space Palette by Jimison3 - https://lospec.com/palette-list/neon-space <br/>
Neon Darkness Palette by Baldur - https://lospec.com/palette-list/baldur-neon-darkness <br/>
200 Free SFX by Kronbits - https://kronbits.itch.io/freesfx <br/>
Sprites by me <br/>
