# Define script parameters
param (
    [string]$repo,
    [string]$tag        
)

# Import the latest version of the module
Import-Module -Name "./github.psm1" -Force


function Main {
    param (
        [string]$repo,
        [string]$tag        
    )

    # Call the function to create and push the tag
    CreateAndPushTag -tag $tag

    Write-Output "Creating release for tag: $tag"
    # Define parameters
    $token = Get-Content "C:\Users\Naz\token.env"
    $owner = "naz-hage"
    $artifactPath = "c:/Artifacts/$repo/release"
    $releaseName = "$tag"

    $assetPath = "$artifactPath/$tag.zip"
    $assetName = "$tag.zip"

    $releaseNotes = GetLatestRelease -token $token -owner $owner -repo $repo -tag $tag


    $assetPath = "$artifactPath/$tag.zip"
    $assetName = "$tag.zip"

    Write-Output "Creating release $tag for $owner/$repo"
    Write-Output "Release Name: $releaseName"
    Write-Output "Commit Message: $commitMessage"
    Write-Output "Asset Path: $assetPath"
    Write-Output "Asset Name: $assetName"

    # Create Release
    CreateGitHubRelease -token $token -owner $owner -repo $repo -tag $tag -releaseName $releaseName -commitMessage $releaseNotes -assetPath $assetPath -assetName $assetName
}

# Call the main function with the provided tag
Main -repo $repo -tag $tag