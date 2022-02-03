# EufyFileFixer
The Eufy Security Batch Downloader for Mac, as of 2/2022, makes really strange files that are a pain to fix. This automates me fixing the files.

## Why is this even a thing?
Simply, the Eufy app pissed me off. It does the following:
1. Spams the write time of the files as whenever you download them instead of the time the video was taken. WHY. I can sort of sort by name but multiple camera screws up the sorting
2. That wasn't bad enough. If your camera has a space in its name (I think this is the case, or the old P22 cameras teling me to go screw off while the P24 is ok), the app just throws the serial number as the name. Good luck finding your "Living Room" camera file.

I wanted to fix both.

## What it does
1. Scans the path you set at the top of the app for all files inside of that folder recursively.
2. Tries to figure out the date from the file name. Note that this will use your current computer's time zone. This will match up with the timestamp on the file and inside the video if they're all set to the time zone
3. Tries to figure out the name of the serial number and match it over to a name. You need to define this part in the $cameraid hashtable. More on that in the Usage section

## Requirements
* PowerShell 5 or higher. Tested on Windows but it should work under Linux and Mac
* Your files from the Eufy Security Batch Downloader macOS app in a writeable location. You will need to know the path

## Usage
1. Download the EufyRenamer.ps1 script
2. Open the script in your favorite editor.
3. Edit the first line's variable, `$camerapath` to where your files are that you want to fix up. This script will dig at all of the subfolder for files as well so maybe try a small folder first to double-check my work.
4. Edit the `$cameraid` hashtable on line 3. Hashtables are key/value pairs. The keys will be your camera serial number, and the value will be the actual name you want it to be. There are no commas separating multiple items.
```
$cameraid = @{
    T8411ASDFSDFSDF = "Living Room"
    T8411RTGDFGDGAF = "Dining Room"
}
```
5. Save the file.
6. Run it in PowerShell.

