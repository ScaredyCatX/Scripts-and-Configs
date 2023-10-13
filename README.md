# Scripts-and-Configs
A bunch of scripts for unraid and linux in general
most of the scripts i got over the internet and edited them to make them suit my use case.
at this point i don't even think i can reference where i got any script from, since they're heavly edited. But I'll try to if imanage to recall the original creator

## hardlink-mktorrent
A script to make youre life easier when creating torrents IF you use mktorrent which i highly recommend.
**The script does the following.**

1. Create a hardlink for the contents of the folder you wish to create a torrent from.
2. Create a folder to store the hardlinks in.
3. Rename the folder containing the hardlinked files.
4. Figure out the Piece Size for the torrent to make it between 1000-2000 Pieces.
5. Run mktorrent.
6. Move the created .torrent file to a folder called torrents.

check the [docs](https://github.com/SomeThingElseZ/Scripts-and-Configs/tree/main/Scripts) for how the script actually works and how to use it.