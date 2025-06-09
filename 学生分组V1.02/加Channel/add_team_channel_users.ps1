# Ensure the script runs with administrator privileges
$CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$Principal = New-Object Security.Principal.WindowsPrincipal($CurrentUser)
if (-not ($Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

# Get the script's directory path (Assumes CSV files are in "output_csvs" folder in the same location as this script)
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$outputFolder = Join-Path $scriptPath "output_csvs"  # Folder containing CSV files

# Define Microsoft Teams Group ID (Replace with your actual Team ID)
$teamId = "3aafbcca-9c46-4be4-bc33-dda9b133adbf"

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

# Check if the folder exists
if (-Not (Test-Path $outputFolder)) {
    Write-Host "Error: Folder 'output_csvs' not found at $outputFolder" -ForegroundColor Red
    exit
}

# Process each CSV file in the output_csvs folder
$csvFiles = Get-ChildItem -Path $outputFolder -Filter "*.csv"

if ($csvFiles.Count -eq 0) {
    Write-Host "No CSV files found in 'output_csvs' folder." -ForegroundColor Red
    exit
}

foreach ($file in $csvFiles) {
    # Extract channel name from file name (remove ".csv" extension)
    $channelName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)

    Write-Host "Processing file: $file.Name | Adding users to Private Channel: '$channelName'" -ForegroundColor Green
    
    # Add fixed administrators (managers) to every channel (sometimes this doesn't work coz in channel research return no result)
    # Write-Host "Adding fixed administrators to '$channelName'" -ForegroundColor Cyan
    Add-TeamChannelUser -GroupId $teamId -DisplayName $channelName -User z5121033@ad.unsw.edu.au  # Yingbo
    Add-TeamChannelUser -GroupId $teamId -DisplayName $channelName -User z3218035@ad.unsw.edu.au  # Imrana
    Add-TeamChannelUser -GroupId $teamId -DisplayName $channelName -User z5318698@ad.unsw.edu.au  # Jiaying
    Add-TeamChannelUser -GroupId $teamId -DisplayName $channelName -User z5269201@ad.unsw.edu.au  # Demonstrator

    Add-TeamChannelUser -GroupId $teamId -DisplayName $channelName -User z5121033@ad.unsw.edu.au -Role Owner  # Yingbo
    Add-TeamChannelUser -GroupId $teamId -DisplayName $channelName -User z3218035@ad.unsw.edu.au -Role Owner  # Imrana
    Add-TeamChannelUser -GroupId $teamId -DisplayName $channelName -User z5318698@ad.unsw.edu.au -Role Owner  # Jiaying
    Add-TeamChannelUser -GroupId $teamId -DisplayName $channelName -User z5269201@ad.unsw.edu.au -Role Owner  # Demonstrator

    # Import CSV and add users to the private channel
    Import-Csv -Path $file.FullName | ForEach-Object {
        $email = $_.email
        if ($email -match "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$") {
            Write-Host "Adding user: $email to '$channelName'" -ForegroundColor Blue
            Add-TeamChannelUser -GroupId $teamId -DisplayName $channelName -User $email
        } else {
            Write-Host "Skipping invalid email: $email" -ForegroundColor Red
        }
    }
}

Write-Host "All users have been added to their respective private channels." -ForegroundColor Green
