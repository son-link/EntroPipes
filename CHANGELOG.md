# EntroPipes CHANGELOG

## r1:
* Firts release

## r2:
* Now have 4 game modes: 4x4, 6x4, 6x6 and 8x6 grid sizes
* Now you have time limit for resolve the maximum number of puzzles. Every time you solve one add 30 seconds to the time limit
* New top score system.
* New grafics and other changes

## r3:
* Update LovePotion to the last commits
* Update PixelOperator8 font 
* Minor changes on the code (need for run on LovePotion 1.10.x)
* Added more puzzles and credits
* Update README.md
* Other minor changes

## r3-2:
* Fix bug on save/load top score

## r4 (Beta 1):
* Now avaliable for **Android** thanks to the oficial port **[Löve-Android](https://bitbucket.org/MartinFelis/love-android-sdl2)**
* Added more puzzles (now have a total of 80, 20 for grid size)
* Remove **Nintendo 3DS** support.
* Added **Cscreen** for keep aspect ratio on any screen or window resolution, necesary for Android and now you can change the windows size.
* Clean clode and other minor changes

## r5 (Beta 2):
* New game grafics, logo and icons and remove others
* Now automatic game pause if the window is minified or lost focus, or change app or back to desktop on Android
* Remove some grafics
* Now on the main screen have 3 options: Play, Top Score and Exit
* Now show the all top scores when press the option on the main screen
* Now on grid size selection Escape or Back button return to the main menu
* Optimize the puzzle editor and some changes on CSS
* Update README.md and screenshots
* Added LÖVE and love-release credits on README.md
* Added my script to automate the build for Windows and Android
* Clean code and other changes

## r6 (Beta 3):
* Change framework. Now used **TIC-80**
* New grafics.
* A lot of code changes for adapte to TIC-80, performance, etc
* Now only save the best record of the current puzzle size (due to limitations of framework)
* The puzzles now is storage in a array inside game code. For the moment the files with puzzles list they keep to check that when adding new puzzles these are no longer in the game.
* Remove unused files (old grafics, libs, etc)
* Update README.md
* Remove android APK. (Coming soon)