# UMich CAEN PS1 Convenience Utils

## Overview

This repository has a few convenience scripts I use with the CAEN CLSE Windows computers at University of Michigan. A brief rundown:

- `MouseSpeed.ps1`: Wrapper for setting the mouse speed in Windows so that you don't have to do it manually through the Control Panel
- `CAENProfileFunctions.ps1`, `LoadUserProfileFromCloud.ps1`, and `SaveUserProfileToCloud.ps1`: Framework for caching local folders on your CAEN network drive. More on this below.
- `wakeonlan.ps1`: Wrapper for sending a magic packet to a computer on the local network, such as your research computer that you want to use remotely.

## Syncing local folders with your CAEN network drive

Most CAEN Windows machines (CLSE and EBD) utilize roaming profiles for all student domain users and have a folder redirection GPO set to redirect most default folders you'd expect to find inside a user's home folder (Desktop and Documents for sure, and probably Contacts, Favorites, Links, Pictures, Saved Games, Searches, and Videos).
(Strangely, roaming app data under `%APPDATA%` is _not_ redirected, and of course `%LOCALAPPDATA%` isn't redirected.)
So folders you'd normally access under `%USERPROFILE` get mapped to `\\engin-labs.m.storage.umich.edu\%USERNAME%\windat.V2`.
This is nice for having Desktop icons and stuff in your Documents sync, but annoying when you have programs like Git, Zotero, or others that expect to find config files and data at `C:\Users\%USERNAME%`.

You can access the actual local versions of these folders using `%HOMEPATH%`, which will resolve to `C:\Users\%USERNAME` but of course is not guaranteed to sync across computers or even persist beyond the current login session.
So we want a way to save config files and data that must be local to `C:\Users\%USERNAME%` to the user's `engin-labs.m.storage.umich.edu` share and be able to easily restore them to `C:\Users\%USERNAME%` again once the user logs in on another CAEN machine.
Here's how to do this:

1. Establish configuration files in their local places under `%HOMEPATH%` (i.e., `C:\Users\%USERNAME%`). This often involves running a program for the first time and setting up any settings you want. Take note of where the program installs config files, which may filenames starting with a dot and thus be hidden by default in Windows Explorer. Some programs deposit config files directly in your `%HOMEPATH%`; others will often put stuff in `%APPDATA%` or `%LOCALAPPDATA%`.
2. For each file or folder you want to back up, add an `AddTo-List` entry to `SaveUserProfileToCloud.ps1`.
3. Run `SaveUserProfileToCloud.ps1`. You can do this right-clicking on `SaveUserProfileToCloud.ps1` in Windows Explorer, or on a shortcut linking to this file, and choosing "Run with PowerShell".

Then, when you are on a new computer and want to restore your configuration, just run `LoadUserProfileFromCloud.ps1`, which will download your profile from your CAEN `N:\` drive and install each backed-up file in its appropriate place inside `%HOMEPATH`.
(Since this is a general profile initialization tool, I also have it do things like set my preferred mouse speed, install the Zotero Office add-on so I don't have to do it manually, and so on.)

If any of the files or folders you specified in `SaveUserProfileToCloud.ps1` changes during your session (i.e., which can be anything from changing a setting in a program to opening a file and the program adding it automatically to its "Recent files" list), be sure to repeat step 3 above so that the updated configuration is backed up again to the cloud.

Note that this utility backs up only files and folders. It doesn't save any config data stored in Windows Registry entries, although this probably wouldn't be too hard to implement.

Use at your own risk. Not endorsed by UMich, CAEN, or ITS.
