#!/bin/bash
# File   : install-automatic-wallpaper.sh
# Purpose: This file creates a script that downloads an image and sets it as wallpaper.
#          This file also installs that script as a crontab for the current user.
# Created: 2015-02-26
# Author : torben@g-b.dk
# License: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/)

###
#INIT
scriptpath=~/
scriptname=update-wallpaper.sh

# Auto-detect the line numbers of FILE_BEGIN and FILE_END.
FILE_BEGIN=$(grep -n -m 12 "#!/bin/bash" "$0"| tail -1 | awk -F: '{print $1}')
FILE_END=$(grep -n -m 12 "gsettings set" "$0"| tail -1 | awk -F: '{print $1}')
# credits to http://stackoverflow.com/a/12451684/20571
echo "Creating runtime script $scriptpath$scriptname . . ."
< "$0" head -n $FILE_END | tail -n +$FILE_BEGIN > "$scriptpath$scriptname"
# credits to http://unix.stackexchange.com/a/47414
# Make it executable:
chmod +x $scriptpath$scriptname

###
# Put the script into current user's crontab:
# Detect if we already added the runtime script to our crontab:
echo "Checking crontab . . ."
already=$(crontab -l|grep -n -m 12 "$scriptname" -| tail -1 | awk -F: '{print $1}')
# Only add the runtime script to crontab if it doesn't already exist:
if [[ "already" -eq "" ]]; then
	echo "Adding runtime script '$scriptname' to crontab . . ."
	(crontab -l 2>/dev/null; echo "") | crontab -
	(crontab -l 2>/dev/null; echo "# set world map as desktop background:") | crontab -
	(crontab -l 2>/dev/null; echo "*/15 * * * * ~/update-wallpaper.sh") | crontab -
else
	echo "Runtime script already exists in crontab! crontab not changed."
fi

###
# Let's use our new script right away!
echo "Setting new wallpaper . . ."
$scriptpath$scriptname
  
###
# Stop installation script here; the rest is used to create the runtime script.
echo "All done! Enjoy your new wallpaper :-)"
exit

###FILE_BEGIN
#!/bin/bash
# File   : update-wallpaper.sh
# Purpose: This file downloads an image and sets it as wallpaper.
# Created: 2015-02-26
# Author : torben@g-b.dk
# License: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/)

# set variables:
wallpaper_path=~/
wallpaper_name=world_sunlight_map.jpg
wallpaper_wget_url=http://www.opentopia.com/images/data/sunlight/world_sunlight_map_rectangular.jpg

# get the file:
cd $wallpaper_path
#date > $wallpaper_path$wallpaperlog
#rm $wallpaper_path$wallpaper_name # I ought to find the wget switch that allows overwriting of the existing file.
wget -q -N ‐‐execute robots=off ‐‐user-agent=Mozilla -O $wallpaper_name $wallpaper_wget_url 

# set file as wallpaper:
export DISPLAY=:0        # we must target the user's desktop, not the command line.
gsettings set org.gnome.desktop.background picture-uri file://$wallpaper_path$wallpaper_name
###FILE_END
