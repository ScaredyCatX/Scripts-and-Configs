# hardlink-mktorrent
A script to make youre life easier when creating torrents IF you use mktorrent which i highly recommend.
## What does it do?
1. Create a hardlink for the contents of the folder you wish to create a torrent from.
2. Create a folder to store the hardlinks in.
3. Rename the folder containing the hardlinked files.
4. Figure out the Piece Size for the torrent to make it between 1000-2000 Pieces.
5. Run mktorrent
6. Move the created .torrent file to a folder called torrents

## The logic behind Piece Size
First we calculate the size of torrent we're creating.
    fsize="$(du -sm "$hardlink" | awk '{print $1}')"

Now that we calculated the size, we'll check which *Piece Size* we should choose, the logic behind this is that we preferably want the number of pieces for the torrent to be between 1000-2000. 
This piece of code will check if the files we want to create a torrent from are less than X MB, and depending on the size of the files, it will choose the Piece Size.
    "$fsize" -le xxx

I've listed which *Piece Size* will be selected if the files sizes are less than X next to each condition. The max *Piece Size* would be 16 MB for anything larger than 16 GB.
```
if [ "$fsize" -le 512 ];          # Piece Size = 256 KB
  then psize="18";                
elif [ "$fsize" -le 1024 ];       # Piece Size = 512 KB
  then psize="19";                
elif [ "$fsize" -le 2048 ];       # Piece Size = 1 MB
  then psize="20";                
elif [ "$fsize" -le 4096 ];       # Piece Size = 2 MB
  then psize="21";               
elif [ "$fsize" -le 8192 ];       # Piece Size = 4 MB
  then psize="22";                
elif [ "$fsize" -le 16384 ];      # Piece Size = 8 MB    
  then psize="23";                
else psize="24";                  # Piece Size = 16 MB
fi
```

### How to use it? 
First things first, there's 4 lines that you must edit.
1. Replace "*/path/to/your/folder*" with the original path of the folder of whatever you want to create a torrent from.
```
folder="/path/to/your/folder"
```
2. Replace "*your_folder_name*" with your desired name for the folder containing the hardlinked files.
```
name="your_folder_name"
```
3. Replace "*/path/to/hardlink*" with the path you wish to create a hardlink in. **Make sure to leave $name at the end of the path**.
```
hardlink="/path/to/hardlink/$name"
```
4. Replace "*https://tracker.com/announce*"with announce URL
```
announce="https://tracker.com/announce"
```
If you want to add a comment, enter one here.
```
comment=""

```

There's a couple more Lines that you might want to edit Depending on your usecase

- if you don't want to add comments to your torrents then remove (-c "$comment").
- if you want to always use 8 MB Piece Size, replace (*"$psize"*) with *23* (no need for quotation marks if you're using a number).

```
mktorrent -v -p -l "$psize" -a "$announce" -n "$name" -o "$output" "$name" -c "$comment"
```
- If you're fine with mktorrent creating the .torrent file in the parent folder of *hardlink* then remove this line, otherwise create a folder called torrents in the parent folder of *hardlink*.
```
mv "$output" "torrents/$output"
```

To run the script all you need to do is
1. Navigate to where you saved the script.
2. Make it executable.
```chmod +x mktorrent-hardlink.sh```
4. Run the script
```./mktorrent-hardlink.sh```
