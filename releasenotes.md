### What's Changed
* The most significant changes include the addition of a new feature in the `github.psm1` file that allows users to see the count of commits since the latest release. Additionally, the `releasenotes.md` file was updated to reflect the changes made in the new version `1.3.21`.

Changes:
1. A new line of code was added to the `GetLatestRelease` function in the `github.psm1` file. This line uses the `Write-Host` command to print the count of the `$commits` variable, providing users with the number of commits since the latest release. (See `github.psm1` file)
2. The URL for the full changelog in the `releasenotes.md` file was updated. The version number in the URL was changed from `1.3.20` to `1.3.21`, indicating that the changelog now reflects the changes made in the new version `1.3.21`. (See `releasenotes.md` file) by @naz-hage
* Update release notes

The most significant changes involve the addition of a function call to `CreateAndPushTag` in the `github-release-notes.ps1` file and the update of the version number in the Full Changelog URL in the `releasenotes.md` file.

Changes:
1. A new function call to `CreateAndPushTag` was added to the `github-release-notes.ps1` file. This function is designed to create and push a new tag, which is a crucial step in version control and release management. (See `github-release-notes.ps1`)
2. The version number in the Full Changelog URL was updated from 1.3.19 to 1.3.20 in the `releasenotes.md` file. This change indicates that the release notes now refer to the new version 1.3.20, providing users with the latest information about the software's updates. (See `releasenotes.md`) by @naz-hage
* The most significant changes involve the modification of the `Main` function in the `github-create-release.ps1` file and the update of the `releasenotes.md` file. The `Main` function now prioritizes the release notes over the commit message, indicating a shift in the importance of these elements. The `releasenotes.md` file now points to a different comparison on GitHub, suggesting an update in the software version from 1.0.0 to 1.3.19.

Changes:

1. The `Main` function in the `github-create-release.ps1` file was altered. The line that printed the commit message was removed, and a new line was added to print the release notes. This change indicates a shift in focus from the commit message to the release notes (github-create-release.ps1).

2. The `releasenotes.md` file was updated. The URL for the full changelog was changed to point to a different comparison on GitHub, indicating a software version update from 1.0.0 to 1.3.19 (releasenotes.md). by @naz-hage
* The most significant changes involve the renaming of two functions, `Get-LatestRelease` and `Get-LatestReleaseRaw`, to `GetLatestRelease` and `GetLatestReleaseRaw` respectively. These changes have been implemented across multiple files, including `github-create-release.ps1`, `github-release-notes.ps1`, and `github.psm1`. Additionally, the `Export-ModuleMember` command has been updated to reflect these new function names. Lastly, the `releasenotes.md` file has been updated with a list of changes and contributions made by the user @naz-hage. (#4)

List of changes:

1. The function `Get-LatestRelease` has been renamed to `GetLatestRelease` in the files `github-create-release.ps1`, `github-release-notes.ps1`, and `github.psm1`. All instances of this function call have been updated to reflect this change.
2. The function `Get-LatestReleaseRaw` has been renamed to `GetLatestReleaseRaw` in the file `github.psm1`.
3. The `GetLatestRelease` function in `github.psm1` now calls the updated `GetLatestReleaseRaw` function instead of the old `Get-LatestReleaseRaw`.
4. The `Export-ModuleMember` command in `github.psm1` has been updated to export the new function names `GetLatestRelease` and `GetLatestReleaseRaw`.
5. The `releasenotes.md` file has been updated with a list of changes and contributions made by the user @naz-hage. by @naz-hage in https://github.com/naz-hage/repo1/pull/4
* 01 issue (#2)

The most significant changes in your workspace include updates to the `.gitignore` file, refactoring of the `github-release-notes.ps1` script, creation of a new module `github.psm1`, and refactoring of the `github-create-release.ps1` script. 

1. `.gitignore` file was updated to ignore certain directories and files, preventing Git from tracking changes in these locations.
2. `github-release-notes.ps1` script was refactored for improved flexibility and maintainability. Parameters are now passed as script parameters instead of being hard-coded. The script was restructured to include a `Main` function, and the release notes are now written to a file called `releasenotes.md`.
3. A new module `github.psm1` was created, including functions `Get-LatestReleaseRaw` and `Get-LatestRelease` which fetch the latest release and all commits since the latest release from a GitHub repository.
4. `github-create-release.ps1` script was refactored for improved modularity and reusability. Several functions were moved to the `github.psm1` module. A new function, `CreateAndPushTag`, was added to the `github.psm1` module, which is now used by the `Main` function in `github-create-release.ps1`.
5. The `releasenotes.md` file was updated with the release notes for the latest changes. by @naz-hage in https://github.com/naz-hage/repo1/pull/2
* Fix bugs in poweshell script by @naz-hage
* Add Get-LatestRelease function by @naz-hage
* Update .gitignore by @naz-hage
* Fix bug with params order by @naz-hage
* Fix Powershell script to use repo as param by @naz-hage
* Learn how to create a GitHub release from a powershell by @naz-hage
* Update Vault.drawio by @naz-hage
* Update Vault.drawio by @naz-hage
* Update Vault.drawio by @naz-hage
* Added Vault.drawio by @naz-hage
* new file and dir by @naz-hage
* Rename README.md to README-repo1.md by @naz-hage
* Initial commit by @naz-hage


### New Contributors
* @naz-hage made their first contribution in https://github.com/naz-hage/repo1/pull/2


**Full Changelog**: https://github.com/naz-hage/repo1/compare/...1.3.0
