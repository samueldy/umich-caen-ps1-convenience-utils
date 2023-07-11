# Script to initialize settings for current user's CAEN desktop.

# Copy settings from roaming directory to local APPDATA directory
$Remote ='N:\windat.V2\Desktop\Utility Programs\ProgramSettings'
$Local = $env:USERPROFILE
$Appdata = $env:APPDATA
$WorkingFolder = 'C:\Temp'
$ArchiveName = "my-caen-profile.zip"

# Print out paths of local and remote storage, just to be sure:
Write-Output "Local storage is at: $($Local)"
Write-Output "Remote storage is at: $($Remote)"

function PullFrom-Remote
{
    # Copy items from remote store to local computer's storage.
    param($RemoteFolder,$LocalFolder)
    Copy-Item "$($Remote)\$($RemoteFolder)" -Recurse -Force -Verbose -Destination "$($Local)\$($LocalFolder)"
    Write-Output "Copied from $($Remote)\$($RemoteFolder) to $($Local)\$($LocalFolder)"
}

function PushTo-Remote
{
    # Copy items from local storage back to remote store.
    param($RemoteFolder,$LocalFolder)
    Copy-Item "$($Local)\$($LocalFolder)\*" -Recurse -Force -Verbose -Destination "$($Remote)\$($RemoteFolder)"
    Write-Output "Backed up $($Remote)\$($RemoteFolder) to $($Local)\$($LocalFolder)"
}

# Make new directory:
$TempProfile = "$WorkingFolder\TempProfile"
If (-Not (Test-Path -Path "$TempProfile")) {
    New-Item -Type Directory -Path "$TempProfile"
}

function AddTo-List
{
    # Add an item to the list of items to be compressed into an archive.
    param($ProfileItem)
    If (Test-Path -Path "$ProfileItem") {

        # Copy invisible files starting with a dot (".*")
        If (Get-Item -Force "$ProfileItem" | Where-Object {$_.Name -like ".*" -and $_.Mode -like "d*"}) { # ("$ProfileItem".Substring(0,1) -eq '.') {
            $ProposedPath = Join-Path "$TempProfile" (Split-Path "$ProfileItem" -Leaf)
            If (-Not (Test-Path "$ProposedPath")) {
                New-Item -Path "$ProposedPath" -ItemType Directory -Force
            }
        }

        # Copy entire folders of profile items...
        If (Get-Item -Force "$ProfileItem" | Where-Object {$_.Mode -like "d*"}) {
            Get-ChildItem -Force "$ProfileItem" -Recurse | foreach {
                Write-Host $_.FullName.Replace("$Local","")
                Copy-Item -Path $_.FullName -Destination (Join-Path "$TempProfile" $_.FullName.Replace("$Local",".")) -Force
            }
        } Else { # Or just a single file, if that was specified.
            Get-Item -Force "$ProfileItem" | foreach {
                Write-Host $_.FullName.Replace("$Local","")
                Copy-Item -Path $_.FullName -Destination (Join-Path "$TempProfile" $_.FullName.Replace("$Local",".")) -Force
            }
        }
    }
}

function Run-Compression
{
    # Actually run the compression.
    param($FolderToCompress)
    Compress-Archive -Path "$FolderToCompress" -Update -DestinationPath "$WorkingFolder\$ArchiveName"
}

function PushTo-Cloud
{
    # Copy items to cloud and clean up aftewards
    Copy-Item -Path "$WorkingFolder\$ArchiveName" -Destination "$Remote"
    Remove-Item -Path "$WorkingFolder\$ArchiveName"
    Remove-Item -Recurse "$TempProfile"
}

function PullFrom-Cloud
{
    # Copy items to local computer
    Copy-Item -Path "$Remote\$ArchiveName" -Destination "$WorkingFolder"
}

function Install-Profile
{
    # Expand profile into the correct location
    Expand-Archive -Force -Path "$WorkingFolder\$ArchiveName" -DestinationPath "$Local"

    # And clean up archive at the end:
    Remove-Item -Path "$WorkingFolder\$ArchiveName"
}

function Add-NewPath
{
    param($NewPath)
    # Thanks to https://stackoverflow.com/a/2571200
    ### Usage from comments - add to the system environment variable ###
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$NewPath", [EnvironmentVariableTarget]::User)
}
