# Get current dir
[string]$scriptPath             = Split-Path -Parent $MyInvocation.MyCommand.Definition;
if($scriptPath -eq ''){ $scriptPath = (Get-Location).Path }
# Check if run as admin
if((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
    Write-host "Running in elevated mode, adding the module to the System32 path..." -ForegroundColor Green
    # unblock the files and copy them to the target sytem32 path
    Get-ChildItem "$scriptPath" -recurse | Unblock-File
    Copy-Item -Path .\ADModule\ActiveDirectory -Destination "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\" -Force -Recurse
    Copy-Item -Path .\ADModule\*.dll -Destination "C:\Windows\WinSxS\" -Force -Recurse

    # Import the module
    Import-Module -Name ActiveDirectory -Force -Global
    Import-Module "C:\Windows\WinSxS\Microsoft.ActiveDirectory.Management.resources.dll" -Force -Global
    Import-Module "C:\Windows\WinSxS\Microsoft.ActiveDirectory.Management.dll" -Force -Global

}else{
    Write-Host "You have to run this script in elevated mode for it to work! Cannot continue..." -ForegroundColor Red
    
    <# Does currently not work :( 
    Write-Host "Not running in elevated mode, importing module only in current session!" -ForegroundColor Yellow

    # Unblock the files
    Get-ChildItem "$scriptPath" -recurse | Unblock-File
    
    # Import the module
    Import-Module -Name $scriptPath\ActiveDirectory -Force
    Import-Module "$scriptPath\Microsoft.ActiveDirectory.Management.resources.dll" -Force -Global
    Import-Module "$scriptPath\Microsoft.ActiveDirectory.Management.dll" -Force -Global
    #>
}






