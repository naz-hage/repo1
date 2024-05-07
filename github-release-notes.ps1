# Define parameters
$token = Get-Content "C:\Users\Naz\token.env"
$owner = "naz-hage"
$repo = "ntools"

function Get-LatestRelease {
    param (
        [string]$token,
        [string]$owner,
        [string]$repo
    )

# Get the latest release
$headers = @{
    "Authorization" = "token $token"
    "Accept" = "application/vnd.github.v3+json"
}

try {
    $uri = "https://api.github.com/repos/$owner/$repo/releases/latest"
    Write-Host "Calling $uri"
    $latestRelease = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers
        
    return $latestRelease
    }
    catch {
        Write-Output $_.Exception
        Write-Output "Error: Could not get the latest release. Please check the repository and token."
        exit 1
    }
}

# Define parameters
$token = Get-Content "C:\Users\Naz\token.env"
$owner = "naz-hage"
$repo = "ntools"

# Get the latest release
$latestRelease = Get-LatestRelease -token $token -owner $owner -repo $repo

# Get all commits since the latest release
$sinceLastPublished = $latestRelease.published_at
$commits = Invoke-RestMethod -Uri "https://api.github.com/repos/$owner/$repo/commits?since=$sinceLastPublished" -Method Get -Headers $headers

# Format the commit messages
$releaseNotes = ($commits | ForEach-Object { "- $($_.commit.message)" }) -join "`n"

# Reformat release note as markdown
$releaseNotes = "## Release Notes`n`n$releaseNotes"
Write-Output $releaseNotes

# Convert the release notes to JSON
$releaseNotesJson = $releaseNotes | ConvertTo-Json

# Now you can use $releaseNotesJson as the JSON response from the API
#Write-Output $releaseNotesJson

# Get all commits since the latest release
function Get-CommitsSinceRelease {
    param (
        [string]$token,
        [string]$owner,
        [string]$repo,
        [string]$sinceLastPublished
    )

    # Define headers
    $headers = @{
        "Authorization" = "token $token"
        "Accept" = "application/vnd.github.v3+json"
    }

    # Get commits since the latest release
$commits = Invoke-RestMethod -Uri "https://api.github.com/repos/$owner/$repo/commits?since=$sinceLastPublished" -Method Get -Headers $headers

# Format the commit messages
$releaseNotes = ($commits | ForEach-Object { "- $($_.commit.message)" }) -join "`n"

    return $releaseNotes
}

# Call the function
$releaseNotes = Get-CommitsSinceRelease -token $token -owner $owner -repo $repo -sinceLastPublished $latestRelease.published_at

# Reformat release note as markdown
$releaseNotes = "## Release Notes`n`n$releaseNotes"
Write-Output $releaseNotes

# Convert the release notes to JSON
$releaseNotesJson = $releaseNotes | ConvertTo-Json

# Now you can use $releaseNotesJson as the JSON response from the API
#Write-Output $releaseNotesJson

# reformat release note as markdown
$releaseNotes = "## Release Notes`n`n$releaseNotes"
Write-Output $releaseNotes
# Convert the release notes to JSON
$releaseNotesJson = $releaseNotes | ConvertTo-Json

# Now you can use $releaseNotesJson as the JSON response from the API
#Write-Output $releaseNotesJson