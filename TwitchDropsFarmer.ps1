$StreamDurationSeconds = 7200
$BrowserProcessNames = @("firefox", "chrome", "msedge", "opera", "brave", "vivaldi")


# Stream list with names and URLs (Rust Twitch Drops channels right now)
$StreamList = @(
    [PSCustomObject]@{ Name = "Large Backpack";      Url = "https://www.twitch.tv/alpacasita" },
    [PSCustomObject]@{ Name = "Assault Rifle";       Url = "https://www.twitch.tv/ferb" },
    [PSCustomObject]@{ Name = "MP5A4";               Url = "https://www.twitch.tv/R3crutaTV" },
    [PSCustomObject]@{ Name = "Thompson";            Url = "https://www.twitch.tv/xkevv" },
    [PSCustomObject]@{ Name = "MP5A4 (2)";           Url = "https://www.twitch.tv/LEDOO" },
    [PSCustomObject]@{ Name = "Assault Rifle (2)";   Url = "https://www.twitch.tv/alexdieci" },
    [PSCustomObject]@{ Name = "Garage Door";         Url = "https://www.twitch.tv/s3kox" },
    [PSCustomObject]@{ Name = "Rocket Launcher";     Url = "https://www.twitch.tv/zbb" },
    [PSCustomObject]@{ Name = "Hunting Bow"};        Url = "https://www.twitch.tv/a1dan8992" },
    [PSCustomObject]@{ Name = "Hunting Bow (2)"};    Url = "https://www.twitch.tv/toonyx" }
)

# Function to kill browser processes
function Close-Browsers {
    Write-Host "Closing browsers..." -ForegroundColor Yellow
    foreach ($browser in $BrowserProcessNames) {
        $processes = Get-Process -Name $browser -ErrorAction SilentlyContinue
        if ($processes) {
            Stop-Process -Name $browser -Force -ErrorAction SilentlyContinue
            Write-Host "Terminated process: $browser" -ForegroundColor DarkGray
        }
    }
    Start-Sleep -Seconds 2
}

# Main Execution Loop
Write-Host "Starting Twitch Drops Farmer..." -ForegroundColor Green
Write-Host "Total Streams: $($StreamList.Count)" -ForegroundColor Cyan
Write-Host "Duration per stream: $StreamDurationSeconds seconds" -ForegroundColor Cyan
Write-Host "--------------------------------------------------"

foreach ($stream in $StreamList) {
    $index = $StreamList.IndexOf($stream) + 1
    
    Close-Browsers

    Write-Host "[$index/$($StreamList.Count)] Ensure browser is closed before starting..." -ForegroundColor Gray
    
    Write-Host "Processing Stream: $($stream.Name)" -ForegroundColor Green
    Write-Host "URL: $($stream.Url)" -ForegroundColor Blue
    Write-Host "Waiting for $StreamDurationSeconds seconds..." -ForegroundColor Magenta

    try {
        Start-Process $stream.Url
    }
    catch {
        Write-Error "Failed to open URL: $($stream.Url)"
        continue
    }

    $secondsRemaining = $StreamDurationSeconds
    while ($secondsRemaining -gt 0) {
        if ($secondsRemaining % 60 -eq 0) {
            $minutesRemaining = $secondsRemaining / 60
            Write-Host "Time remaining for $($stream.Name): $minutesRemaining minutes..." -ForegroundColor DarkGray
        }
        Start-Sleep -Seconds 1
        $secondsRemaining--
    }
# Output completion message
    Write-Host "Finished watching: $($stream.Name)" -ForegroundColor Green
    Write-Host "--------------------------------------------------"
}

# Final Cleanup
Close-Browsers
Write-Host "All streams processed. Happy farming!" -ForegroundColor Green

