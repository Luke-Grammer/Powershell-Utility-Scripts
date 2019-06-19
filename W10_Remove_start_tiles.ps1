# Windows 10 start tile remover
# Written by Luke Grammer 
# May 29, 2019

# Programatically removes all tiles from the windows start menu in all versions of Windows 10. 
Write-Host "Windows 10 Start tile remover v1.0"
Write-Host ""

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Exit
}

$os = (Get-WmiObject win32_operatingsystem).caption
If ($os.StartsWith("Microsoft Windows 10"))
{
    $choice = (Read-Host -Prompt "Would you like to remove all start tiles on this device? (y/n)").ToLower()
    If ($choice -eq "y" -OR $choice -eq "yes")
    {
        $removed_items_count = 0
        Write-Host ""
        (New-Object -Com Shell.Application).NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items() |
          %{  $app_name = $_.Name()
              $_.Verbs() 
           } |
          ?{$_.Name -match "Un.*pin from Start"} |
          %{
              Write-Host "Removing " -NoNewline
              $app_name
              $_.DoIt()
              $removed_items_count++
           }
        Write-Host "Done!"
        Write-Host ""

        If ($removed_items_count.Equals(0))
        {
            Write-Host "No start menu tiles removed."
            Write-Host ""
        }
    }
    Else
    {
		Write-Host ""
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