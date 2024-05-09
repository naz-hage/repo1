# Define parameters
$repoUrl = "https://github.com/naz-hage/repo1.git"
$defaultBranch = "main"

# Clone the repository
#git clone $repoUrl
#$repoName = $repoUrl.Split("/")[-1].Replace(".git", "")
#cd $repoName

# Remove the history
Remove-Item .git -Recurse -Force
git init
git add .
git commit -m "Initial commit"

# Force push to the repository
git remote add origin $repoUrl
git push -u -f origin $defaultBranch