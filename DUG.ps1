$name = Read-Host "Full name"
$user = Read-Host "Username"

# The assecurestring is needed because windows security and password policy requirement 
# otherwise account will be disabled.

$pass = Read-Host "Password" -AsSecureString
$group = Read-host "groupname"

New-ADUser -Name $name -SamAccountName $user -AccountPassword $pass -Enabled $true
Get-ADUser $name

New-ADGroup -Name $group -GroupScope Global
Get-ADGroup $group

Add-AdGroupMember -Identity $group -Members $user
Get-AdGroupMember $group

write-host "$name has been created and added to $group"