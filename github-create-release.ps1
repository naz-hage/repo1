# Define script parameters
param (
    [string]$tag,
    [string]$repo
)

# Build release notes since a specific release
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
    $releaseNotes = "## What's Changed"
    $releaseNotes += ($commits | ForEach-Object { "* $($_.commit.message) by @$_author in https://github.com/$owner/$repo/pull/$($_.sha)" }) -join "`n"
    $releaseNotes += "`n`n## New Contributors"
    $releaseNotes += ($commits | Where-Object { $_.author.login -notin $commits.author.login } | ForEach-Object { "* @$($_.author.login) made their first contribution in https://github.com/$owner/$repo/pull/$($_.sha)" }) -join "`n"
    $releaseNotes += "`n`n**Full Changelog**: https://github.com/$owner/$repo/compare/$sinceLastPublished...$tag"

    return $releaseNotes
}

function CreateGitHubRelease {
    param (
        [string]$token,
        [string]$owner,
        [string]$repo,
        [string]$tag,
        [string]$releaseName,
        [string]$commitMessage,
        [string]$assetPath,
        [string]$assetName
    )

    $assetMimeType = "application/octet-stream"
    $assetContent = [System.IO.File]::ReadAllBytes($assetPath)

    $headers = @{
        "Authorization" = "token $token"
        "Accept" = "application/vnd.github.v3+json"
    }

    $body = @{
        "tag_name" = $tag
        "name" = $releaseName
        "body" = $commitMessage
        "draft" = $false
        "prerelease" = $false
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "https://api.github.com/repos/$owner/$repo/releases" -Method Post -Body $body -Headers $headers

    try {
        $uploadUrl = $response.upload_url -replace "\{\?name,label\}", "?name=$assetName"
        Write-Output "Upload URL: $uploadUrl"
        Invoke-RestMethod -Uri $uploadUrl -Method Post -Body $assetContent -Headers $headers -ContentType $assetMimeType
    } catch {
        Write-Output $_.Exception
        Write-Output "Error: Could not create a release."
        exit 1
    }
}

function Main {
    param (
        [string]$tag,
        [string]$repo
    )

    Write-Output "Creating release for tag: $tag"
    # Define parameters
    $token = Get-Content "C:\Users\Naz\token.env"
    $owner = "naz-hage"
    $artifactPath = "c:/Artifacts/ntools/release"
    $releaseName = "$tag"
    $commitMessage = "Test commit message for $tag"
    $assetPath = "$artifactPath/$tag.zip"
    $assetName = "$tag.zip"

    # Build release notes since the last published release
    $releaseNotes = Get-CommitsSinceRelease -token $token -owner $owner -repo $repo -sinceLastPublished $latestRelease.published_at

    $commitMessage = $releaseNotes
    $assetPath = "$artifactPath/$tag.zip"
    $assetName = "$tag.zip"

    Write-Output "Creating release $tag for $owner/$repo"
    Write-Output "Release Name: $releaseName"
    Write-Output "Commit Message: $commitMessage"
    Write-Output "Asset Path: $assetPath"
    Write-Output "Asset Name: $assetName"

    # Create Release
    CreateGitHubRelease -token $token -owner $owner -repo $repo -tag $tag -releaseName $releaseName -commitMessage $commitMessage -assetPath $assetPath -assetName $assetName
}

# Call the main function with the provided tag
Main -repo $repo -tag $tag