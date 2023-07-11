# LoadUserProfileFromCloud.ps1

# Script to load my user profile from the cloud.

# Fix mouse speed
Import-Module "$PSScriptRoot\MouseSpeed.ps1"
Set-MouseSpeed -Speed 6

# Import profile functions (assumes running this script from Explorer)
Import-Module "$PSScriptRoot\CAENProfileFunctions.ps1"

# Download profile
PullFrom-Cloud

# Install profile
Install-Profile

# For the U-M ITS Sites computers, remove non-en-US keyboard languages so I don't accidentally switch to them.
$NewLanguageList = New-WinUserLanguageList -Language "en-US"
Set-WinUserLanguageList $NewLanguageList -Force


# Append to user PATH
# Add-NewPath -NewPath "N:\windat.V2\AppData\Local\Programs\miktex-2.9.6753\texmfs\install\miktex\bin"
# 
# Add-NewPath -NewPath "N:\windat.V2\AppData\Local\Programs\pdf2svg-64bits"
# 
# Add-NewPath -NewPath "N:\windat.V2\AppData\Local\Programs\pandoc-2.5-windows-x86_64"

[Environment]::SetEnvironmentVariable("Path", $env:Path + ";N:\windat.V2\AppData\Local\Programs\miktex-2.9.6753\texmfs\install\miktex\bin;N:\windat.V2\AppData\Local\Programs\pdf2svg-64bits;N:\windat.V2\AppData\Local\Programs\pandoc-2.5-windows-x86_64", [EnvironmentVariableTarget]::User)

# If you use PuTTY from AppsAnywhere and want to use its agents keys for Git
[Environment]::SetEnvironmentVariable("GIT_SSH", "C:\VApps\PuTTY\0.74\plink.exe", [EnvironmentVariableTarget]::User)

# Also want to install the Zotero Word plugin automatically
New-Item -ItemType Directory -Force "$Local\AppData\Roaming\Microsoft\Word\STARTUP"
Copy-Item "N:\windat.V2\AppData\Local\Programs\Zotero\extensions\zoteroWinWordIntegration@zotero.org\install\Zotero.dotm" "$Local\AppData\Roaming\Microsoft\Word\STARTUP"

# Start Box Edit (obsolete)
# & "$Local\AppData\Local\Box\Box Edit\Box Edit.exe"
