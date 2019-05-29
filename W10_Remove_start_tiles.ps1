# Windows 10 start tile remover
# Written by Luke Grammer 
# May 29, 2019

# Programatically removes all tiles from the windows start menu in all versions of Windows 10. 
Write-Host "Windows 10 Start tile remover v1.0"
Write-Host ""

$os = (Get-WmiObject win32_operatingsystem).caption
If ($os.StartsWith("Microsoft Windows 10"))
{
    $choice = (Read-Host -Prompt "Would you like to remove all start tiles on this device? (y/n)").ToLower()
    If ($choice -eq 'y' -OR $choice -eq 'yes')
    {
        Write-Host "Removing start tiles. . ."
        (New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() |
          %{ $_.Verbs() } |
          ?{$_.Name -match 'Un.*pin from Start'} |
          %{$_.DoIt()}
        Write-Host "Done!"
        Write-Host ""
    }
    Else
    {
        Write-Host "Operation terminated."
        Write-Host ""
    }
}
Else 
{
  Write-Host -NoNewline "Unrecognized OS version: " -ForegroundColor Red
  Write-Host $os
  Write-Host ""
}

# Check if not being run in Powershell ISE (to make sure window does not close suddenly)
If (-NOT $psISE) 
{
    Write-Host "Press any key to exit. . ." -ForegroundColor Yellow
    $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}