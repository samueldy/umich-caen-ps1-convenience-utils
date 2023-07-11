# SaveUserProfileToCloud.ps1

# Wrapper script to save important folders in my user profile to the cloud.

# Import profile functions (assumes running this script from Explorer)
Import-Module "$PSScriptRoot\CAENProfileFunctions.ps1"

# Set location to be home directory, so that paths get passed into the zip relative to this directory.
Set-Location "$Local"

#AddTo-List -ProfileItem "$Local\AppData\Roaming\Code"
AddTo-List -ProfileItem "$Local\AppData\Roaming\LyX2.3"
# AddTo-List -ProfileItem "$Local\.vscode"
AddTo-List -ProfileItem "$Local\AppData\Roaming\Zotero"
AddTo-List -ProfileItem "$Local\AppData\Local\Zotero"
AddTo-List -ProfileItem "$Local\AppData\Local\Box"
# AddTo-List -ProfileItem "$Local\AppData\Local\gitkraken" # Moved to N: drive.
AddTo-List -ProfileItem "$Local\AppData\Local\pdf2svg"
# AddTo-List -ProfileItem "$Local\AppData\Roaming\GitKraken"
# AddTo-List -ProfileItem "$Local\AppData\Roaming\.gitkraken"
AddTo-List -ProfileItem "$Local\AppData\Roaming\inkscape"
AddTo-List -ProfileItem "$Local\Documents"
AddTo-List -ProfileItem "$Local\.bash_history"
AddTo-List -ProfileItem "$Local\.bashrc"
AddTo-List -ProfileItem "$Local\.bash_profile"
AddTo-List -ProfileItem "$Local\.gitconfig"
AddTo-List -ProfileItem "$Local\.minttyrc"
AddTo-List -ProfileItem "$Local\.ssh"
AddTo-List -ProfileItem "$Local\AppData\Roaming\Notable"
AddTo-List -ProfileItem "$Local\AppData\Roaming\MuseScore"
AddTo-List -ProfileItem "$Local\AppData\Roaming\MathWorks"
AddTo-List -ProfileItem "$Local\AppData\Local\MuseScore"
AddTo-List -ProfileItem "$Local\.notable.json"
AddTo-List -ProfileItem "$Local\.pmgrc.yaml"
AddTo-List -ProfileItem "$Local\.nx"
AddTo-List -ProfileItem "$Local\AppData\Local\Globus Connect"
AddTo-List -ProfileItem "$Local\AppData\Local\Mendeley Ltd"
AddTo-List -ProfileItem "$Local\AppData\Local\MathWorks"
AddTo-List -ProfileItem "$Local\AppData\Roaming\MathWorks"
AddTo-List -ProfileItem "$Local\AppData\Roaming\Microsoft\Word\STARTUP"

# Perform the compression
Run-Compression -FolderToCompress "$TempProfile\*"

# Push to cloud
PushTo-Cloud