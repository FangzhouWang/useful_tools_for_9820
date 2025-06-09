# 在merged_output.csv文件生成后，用此脚本向teams各小组添加成员
# Ensure the script runs with administrator privileges
$CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$Principal = New-Object Security.Principal.WindowsPrincipal($CurrentUser)
if (-not ($Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

# Get the script's directory path (Assumes CSV is in the same folder)
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$csvFilePath = Join-Path $scriptPath "merged_output.csv"  # CSV file name

# Define Microsoft Teams Group ID (Update with the correct ID)
$groupId = "3aafbcca-9c46-4be4-bc33-dda9b133adbf"

# Install MicrosoftTeams module if not already installed
Write-Host "Checking and installing MicrosoftTeams module..." -ForegroundColor Yellow
$Module = Get-Module -ListAvailable -Name MicrosoftTeams
if (-not $Module) {
    Install-Module -Name MicrosoftTeams -Force -AllowClobber -Scope CurrentUser
}

# Import the MicrosoftTeams module
Import-Module MicrosoftTeams

# Connect to Microsoft Teams
Write-Host "Connecting to Microsoft Teams..." -ForegroundColor Cyan
Connect-MicrosoftTeams

# Check if the CSV file exists
if (-Not (Test-Path $csvFilePath)) {
    Write-Host "Error: CSV file not found at $csvFilePath" -ForegroundColor Red
    exit
}

# Import users from CSV and add them to the Microsoft Teams group
Write-Host "Adding users to Microsoft Teams group..." -ForegroundColor Green
Import-Csv -Path $csvFilePath | ForEach-Object {
    $email = $_.email
    if ($email -match "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$") {
        Write-Host "Adding user: $email" -ForegroundColor Blue
	# 这行添加成员
        Add-TeamUser -GroupId $groupId -User $email
    } else {
        Write-Host "Skipping invalid email: $email" -ForegroundColor Red
    }
}

# 这里把几个管理员加上
# Yingbo!
Add-TeamUser -GroupId $groupId -User z5121033@ad.unsw.edu.au -Role Owner
# Imrana!
Add-TeamUser -GroupId $groupId -User z3218035@ad.unsw.edu.au -Role Owner
# Jiaying!
Add-TeamUser -GroupId $groupId -User z5318698@ad.unsw.edu.au -Role Owner
# add the demonstrator in charge of these groups
Add-TeamUser -GroupId $groupId -User z5269201@ad.unsw.edu.au -Role Owner

Write-Host "Process completed successfully!" -ForegroundColor Green