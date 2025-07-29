# 🔐 SSH Key Setup for GitHub & GitLab

This project provides two scripts — one for Unix-like systems (Linux/macOS) and another for Windows — to help you quickly generate and configure SSH keys for GitHub and GitLab.

---

## 📁 Files

* `setup_ssh_keys.sh` – Shell script for Linux/macOS
* `setup_ssh_keys.ps1` – PowerShell script for Windows

---

## 🧪 Prerequisites

### For Linux/macOS

* `ssh-keygen` installed (usually available by default)
* `curl` if running script remotely

### For Windows

* Git for Windows (includes `ssh-keygen`)
* PowerShell 5.1 or later

---

## 🚀 Usage

### 🐿 Linux/macOS

1. **Download the script:**

   ```sh
   curl -fsSL https://raw.githubusercontent.com/<your-user>/<your-repo>/main/setup_ssh_keys.sh -o setup_ssh_keys.sh
   chmod +x setup_ssh_keys.sh
   ```

2. **Run the script:**

   * Generate **both** GitHub and GitLab keys (default):

     ```sh
     ./setup_ssh_keys.sh you@example.com
     ```

   * Only GitHub key:

     ```sh
     ./setup_ssh_keys.sh github you@example.com
     ```

   * Only GitLab key:

     ```sh
     ./setup_ssh_keys.sh gitlab you@example.com
     ```

3. **Copy public key(s) to clipboard:**

   ```sh
   cat ~/.ssh/id_github.pub
   cat ~/.ssh/id_gitlab.pub
   ```

---

### 🪿 Windows (PowerShell)

1. **Download the script:**

   ```powershell
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/<your-user>/<your-repo>/main/setup_ssh_keys.ps1" -OutFile "setup_ssh_keys.ps1"
   ```

2. **Allow script execution if needed (once):**

   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **Run the script:**

   * Generate **both** GitHub and GitLab keys:

     ```powershell
     .\setup_ssh_keys.ps1 -Email "you@example.com"
     ```

   * Only GitHub key:

     ```powershell
     .\setup_ssh_keys.ps1 -KeyType github -Email "you@example.com"
     ```

   * Only GitLab key:

     ```powershell
     .\setup_ssh_keys.ps1 -KeyType gitlab -Email "you@example.com"
     ```

4. **Copy public key(s):**

   ```powershell
   Get-Content $HOME\.ssh\id_github.pub
   Get-Content $HOME\.ssh\id_gitlab.pub
   ```

---

## 💡 Notes

* The script **does not overwrite existing SSH keys**.
* SSH configuration (`~/.ssh/config`) is updated only if the host entry is missing.
* You can reuse these keys across multiple machines by copying them securely.

---

## 🌟 Troubleshooting

* **Permission denied (publickey)** – Make sure the correct key is added to GitHub/GitLab.
* **Script doesn’t run on Windows** – Ensure you're using PowerShell, not CMD, and you've allowed script execution.

---

## 📬 Questions?

Open an issue or discussion on this repository.
