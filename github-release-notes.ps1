# Define script parameters
param (
    [string]$repo,
    [string]$tag
)

# Import the latest version of the module
Import-Module -Name "./github.psm1" -Force

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


function Main {
    param (
        [string]$repo,
        [string]$tag
    )
    # Define parameters
    $token = Get-Content "C:\Users\Naz\token.env"
    $owner = "naz-hage"

    Write-Host "repo: $repo"
    Write-Host "tag: $tag"

    # Get the latest release
    $releaseNotes = GetLatestRelease -token $token -owner $owner -repo $repo -tag $tag

    Write-Output $releaseNotes

    # write to file releasenotes.md
    $releaseNotes | Out-File -FilePath "releasenotes.md"
    # Convert the release notes to JSON
    #$releaseNotesJson = $releaseNotes | ConvertTo-Json

    # Now you can use $releaseNotesJson as the JSON response from the API
    #Write-Output $releaseNotesJson
}
# Call the main function with the provided tag
Main -repo $repo -tag $tag
