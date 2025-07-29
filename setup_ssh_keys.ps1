param (
    [string]$KeyType = "both",       # Accepts: github, gitlab, or both (default)
    [string]$Email
)

if (-not $Email) {
    Write-Error "❌ Usage: .\setup_ssh_keys.ps1 [github|gitlab] your_email@example.com"
    exit 1
}

$sshDir = "$HOME\.ssh"
$githubKey = "id_github"
$gitlabKey = "id_gitlab"
$configFile = "$sshDir\config"

# Ensure .ssh directory exists
if (!(Test-Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir | Out-Null
}
icacls $sshDir /inheritance:r /grant:r "$env:USERNAME:F" | Out-Null

# Generate GitHub Key
if ($KeyType -eq "github" -or $KeyType -eq "both") {
    $githubKeyPath = Join-Path $sshDir $githubKey
    if (!(Test-Path "$githubKeyPath")) {
        Write-Output "🔑 Generating SSH key for GitHub..."
        ssh-keygen -t ed25519 -f $githubKeyPath -C $Email -N "" | Out-Null
    } else {
        Write-Warning "⚠️  GitHub key already exists — skipping."
    }
}

# Generate GitLab Key
if ($KeyType -eq "gitlab" -or $KeyType -eq "both") {
    $gitlabKeyPath = Join-Path $sshDir $gitlabKey
    if (!(Test-Path "$gitlabKeyPath")) {
        Write-Output "🔑 Generating SSH key for GitLab..."
        ssh-keygen -t ed25519 -f $gitlabKeyPath -C $Email -N "" | Out-Null
    } else {
        Write-Warning "⚠️  GitLab key already exists — skipping."
    }
}

# Create config file if missing
if (!(Test-Path $configFile)) {
    New-Item -ItemType File -Path $configFile | Out-Null
}
# Ensure proper permissions
icacls $configFile /inheritance:r /grant:r "$env:USERNAME:F" | Out-Null

# Append GitHub config if not present
if ((Test-Path "$sshDir\$githubKey") -and !(Select-String -Path $configFile -Pattern "Host github.com" -Quiet)) {
    Add-Content $configFile @"
Host github.com
    HostName github.com
    User git
    IdentityFile $sshDir\$githubKey
    IdentitiesOnly yes

"@
}

# Append GitLab config if not present
if ((Test-Path "$sshDir\$gitlabKey") -and !(Select-String -Path $configFile -Pattern "Host gitlab.com" -Quiet)) {
    Add-Content $configFile @"
Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile $sshDir\$gitlabKey
    IdentitiesOnly yes

"@
}

# Summary
Write-Host "`n✅ SSH setup complete.`n"
Write-Host "📎 To copy your public key(s), run:"
if (Test-Path "$sshDir\$githubKey.pub") {
    Write-Host "   • Get-Content '$sshDir\$githubKey.pub' (GitHub)"
}
if (Test-Path "$sshDir\$gitlabKey.pub") {
    Write-Host "   • Get-Content '$sshDir\$gitlabKey.pub' (GitLab)"
}
