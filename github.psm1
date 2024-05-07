
function GetLatestReleaseRaw {
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
    Write-Host "Getting latest release Raw for $repo"
    Write-Host "Uri: $uri"
    $latestRelease = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers
        
    return $latestRelease
    }
    catch {
        #Write-Host $_.Exception
        #Write-Host "Error: Could not get the latest release."
        return $null
    }
}

# Get all commits since the latest release
function GetLatestRelease {
    param (
        [string]$token,
        [string]$owner,
        [string]$repo,
        [string]$tag
    )

    $lastest = GetLatestReleaseRaw -token $token -owner $owner -repo $repo

    # Build release notes since the last published release
    if ($null -eq $lastest) {
        $sinceLastPublished = "1970-01-01T00:00:00Z"
    } else {
        $sinceLastPublished = $lastest.published_at
    }

    # Define headers
    $headers = @{
        "Authorization" = "token $token"
        "Accept" = "application/vnd.github.v3+json"
    }

    $uri = "https://api.github.com/repos/$owner/$repo/commits?since=$sinceLastPublished"
    Write-Host "Getting latest release for $repo"
    Write-Host "Uri: $uri"
    # Get commits since the latest release
    $commits = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers
    $sinceTag = GeTagFromCommit -token $token -owner $owner -repo $repo -commitSha $commits[0].sha

    # Format the commit messages
    #$releaseNotes = ($commits | ForEach-Object { "- $($_.commit.message)" }) -join "`n"
    # What's Changed
    $releaseNotes = "### What's Changed`n"
    #$releaseNotes += ($commits | ForEach-Object { "* $($_.commit.message) by @$_author in https://github.com/$owner/$repo/pull/$($_.sha)" }) -join "`n"
    foreach ($commit in $commits) {
        $prUri = "https://api.github.com/repos/$owner/$repo/commits/$($commit.sha)/pulls"
        $pulls = Invoke-RestMethod -Uri $prUri -Method Get -Headers $headers
        if ($pulls) {
            $prNumber = $pulls[0].number
            $releaseNotes += "* $($commit.commit.message) by @$($commit.author.login) in https://github.com/$owner/$repo/pull/$prNumber`n"
        } else {
            $releaseNotes += "* $($commit.commit.message) by @$($commit.author.login)`n"
        }
    }
    # New contributors
    $releaseNotes += "`n`n### New Contributors`n"
    $contributors = @()
    foreach ($commit in $commits) {
        if ($commit.author.login -notin $contributors) {
            $contributors += $commit.author.login
            $releaseNotes += "* @$($commit.author.login) made their first contribution in https://github.com/$owner/$repo/pull/$prNumber`n"
        }
    }
    #$releaseNotes += "`n`n### New Contributors"
    #$releaseNotes += ($commits | Where-Object { $_.author.login -notin $commits.author.login } | ForEach-Object { "* @$($_.author.login) made their first contribution in https://github.com/$owner/$repo/pull/$($_.sha)" }) -join "`n"
    
    # Full Changelog
    $releaseNotes += "`n`n**Full Changelog**: https://github.com/$owner/$repo/compare/$sinceTag...$tag"



    return $releaseNotes
}

function GeTagFromCommit {  
    param (
        [string]$token,
        [string]$owner,
        [string]$repo,
        [string]$commitSha
    )

    # Define headers
    $headers = @{
        "Authorization" = "token $token"
        "Accept" = "application/vnd.github.v3+json"
    }
    
   # Get all tags
    $tagsUri = "https://api.github.com/repos/$owner/$repo/tags"
    $tags = Invoke-RestMethod -Uri $tagsUri -Method Get -Headers $headers

    # Find the tag for a specific commit
    $tagForCommit = $null

    foreach ($tag in $tags) {
        if ($tag.commit.sha -eq $commitSha) {
            $tagForCommit = $tag.name
            break
        }
    }

    return $tagForCommit


}

function CreateAndPushTag {
    param (
        [string]$tag
    )

# get current branch
$branch = git rev-parse --abbrev-ref HEAD
# create a tag
git tag $tag
# push the tag to the remote
git push origin $branch $tag
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

Export-ModuleMember -Function 'GetLatestRelease', 'CreateGitHubRelease', 'GeTagFromCommit', 'CreateAndPushTag'