# choco
choco install script

see (https://stackoverflow.com/questions/48144104/powershell-script-to-install-chocolatey-and-a-list-of-packages)

Run this script in powershell (checked in version 5):

```powershell -executionpolicy bypass -File C:\Users\mypath\home_env_powershell_scr.ps1```

Look up package:

```(https://community.chocolatey.org/packages?q=)```

To check installed choco package status':

```choco outdated```

Auto update all:

```choco upgrade all --yes```

List all installed packages (windows list):

'''choco list -li'''


'''choco list --local-only'''
Or:

'''clist -l'''
