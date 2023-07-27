function Add-Path() {
    [Cmdletbinding()]
    param([parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0)][String[]]$AddedFolder)
    # Get the current search path from the environment keys in the registry.
    $OldPath=(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
    # See if a new folder has been supplied.
    if (!$AddedFolder) {
        Return 'No Folder Supplied. $ENV:PATH Unchanged'
    }
    # See if the new folder exists on the file system.
    if (!(TEST-PATH $AddedFolder))
    { Return 'Folder Does not Exist, Cannot be added to $ENV:PATH' }cd
    # See if the new Folder is already in the path.
    if ($ENV:PATH | Select-String -SimpleMatch $AddedFolder)
    { Return 'Folder already within $ENV:PATH' }
    # Set the New Path
    $NewPath=$OldPath+’;’+$AddedFolder
    Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $newPath
    # Show our results back to the world
    Return $NewPath
}

Function CheckError ($output, $message)
{
    #if ($output.Contains("0 packages failed"))
    #    {
    #    write-host $message "success" -ForegroundColor "green"
    #}
    #else 
    #{
    #    write-host $message "fail" -ForegroundColor "red" 
    #'}
    $o = $output.Split([Environment]::NewLine) | select-string -Pattern "Chocolatey installed" -AllMatches
    write-host $message $o -ForegroundColor Yellow

}

######################################################
# Install apps using Chocolatey
######################################################
Write-Host "Installing Chocolatey" -ForegroundColor "green" 
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Host "Set choco to confirm installation questions" -ForegroundColor "green" 
choco feature enable -n=allowGlobalConfirmation
choco feature enable -n=allowEmptyCheckSums
choco feature enable -n=ignorechecksums

Write-Host "Installing applications:" -ForegroundColor "green" 
$packages = "agentransack", "logparser", "GoogleChrome", "7zip", "SourceTree", "fiddler4", "git", "greenshot", "launchy", "MsSqlServer2014Express",
	"VisualStudioCode", "vscode-powershell", "notepadplusplus", "putty", 
	"python2", "r.project", "microsoft-r-open", "r.studio", "sumatrapdf", "veracrypt", "windirstat", "winmerge", "winscp", "xmind", "AzureStorageExplorer", 
	"docker", "nodejs.install", "windirstat", "lockhunter", "Cmder", "rsat", "teracopy", "kdiff3", "gitextensions"

foreach ($p in $packages)
{
    $output = cinst $p | Out-String
    CheckError $output $p
}
Write-Host

######################################################
# Install Windows installer through WebPI
######################################################
Write-Host "Installing apps from WebPI" -ForegroundColor "green" 
cinst WindowsInstaller45 -source webpi
Write-Host

######################################################
# Add Git to the path
######################################################
Write-Host "Adding Git\bin to the path" -ForegroundColor "green" 
Add-Path "C:\Program Files (x86)\Git\bin"
Write-Host

# Not in choco repo
# SpreadsheetGear
# Tableau public