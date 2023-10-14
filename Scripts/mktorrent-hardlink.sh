#!/bin/bash
folder="/path/to/your/folder" # Replace this with the original path of the content you want to create a torrent from
name="your_folder_name" # Replace this with your desired name for the folder containing the hardlinked files
hardlink="/path/to/hardlink/$name" # Replace /path/to/hardlink with the path you wish to create a hardlink in. Make sure to leave $name at the end of the path
announce="https://tracker.com/announce" # Replace with announce URL
comment="" # Enter comment if you want one

output="$name.torrent"
# Create a new folder at the hardlink path
echo "Creating new folder at the hardlink path..."
mkdir -p "$hardlink"

# Create a hard link for each .mkv, .avi, and .mp4 file in the original folder
echo "Creating hard links for each .mkv, .avi, and .mp4 file in the original folder..."
for ext in mkv avi mp4; do
    files=("$folder"/*."$ext")
    if [ -e "${files[0]}" ]; then
        for file in "${files[@]}"; do
            ln "$file" "$hardlink"
        done
    fi
done

# If you wish to create a hardlink of everything in the folder, delete Line 14 to 22 and uncomment the next 4 lines (delete the # to uncomment)

# echo "Creating hard links for each file in the original folder..."
# for file in "$folder"/*; do
#     ln "$file" "$hardlink"
# done

echo "Calculating folder size..."
fsize="$(du -sm "$hardlink" | awk '{print $1}')"

echo "Calculated folder size: $fsize MB"

echo "Determining piece size for torrent..."
# Calculate folder/file size
if [ "$fsize" -le 512 ];
  then psize="18";                # Piece Size = 256 KB
elif [ "$fsize" -le 1024 ];
  then psize="19";                # Piece Size = 512 KB
elif [ "$fsize" -le 2048 ];
  then psize="20";                # Piece Size = 1 MB
elif [ "$fsize" -le 4096 ];
  then psize="21";                # Piece Size = 2 MB
elif [ "$fsize" -le 8192 ];
  then psize="22";                # Piece Size = 4 MB
elif [ "$fsize" -le 16384 ];
  then psize="23";                # Piece Size = 8 MB    
else psize="24";                  # Piece Size = 16 MB
# else psize="23"
fi
# If you wish to have a max Piece Size of 8 MB, delete lines 48-50 and uncomment line 51
echo "piece size is: $psize"      # just to check what Piece Size the script chose.

echo "Creating torrent file..."
## Create .torrent
cd "$(dirname "$hardlink")"      # Move to the parent directory of hardlink
mktorrent -v -p -l "$psize" -a "$announce" -n "$name" -o "$output" "$name" -c "$comment"          # If you're not using comments, remove (-c "$comment")
# Move the .torrent file to the torrents subdirectory
mv "$output" "torrents/$output"      # move the .torrent file to a folder called "torrents" in the parent folder of hardlink
echo "Done."
