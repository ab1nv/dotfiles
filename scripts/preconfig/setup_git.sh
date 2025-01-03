# Phase 1: Basic credentials setup

read -p "Enter your Git username: " git_username
read -p "Enter your Git email: " git_email
git config --global user.name "$git_username"
git config --global user.email "$git_email"
echo "Git username and email have been set."

# Phase 2: SSH authentication

ssh_dir="$HOME/.ssh"
key_file="$ssh_dir/id_rsa"

if [[ -f "$key_file" ]]; then
    echo "SSH key already exists."
else
    echo "Generating a new SSH key..."
    ssh-keygen -t rsa -b 4096 -C "$git_email" -f "$key_file" -N ""
    echo "SSH key generated."
fi

eval "$(ssh-agent -s)"
ssh-add "$key_file"

echo "SSH key added to SSH agent."
echo "Here is your public SSH key:"
cat "$key_file.pub"

echo "Copy the above SSH key to your Git hosting provider (e.g., GitHub, GitLab, etc.)."
read -p "Do you want to upload your SSH key to GitHub automatically (yes/no)? " upload_ssh

if [[ "$upload_ssh" == "yes" ]]; then
    if ! command -v gh &> /dev/null; then
        echo "GitHub CLI (gh) is not installed. Installing it now..."
        sudo pacman -S --needed --noconfirm github-cli
    fi

    echo "Logging into GitHub..."
    gh auth login
    echo "Uploading SSH key to GitHub..."

    ssh_key_title="$(hostname) SSH Key"
    gh ssh-key add "$key_file.pub" --title "$ssh_key_title"

    echo "SSH key has been added to your GitHub account."
fi

# Phase 3: Commit Signature Verification

echo "Checking for existing GPG keys..."
gpg_key=$(gpg --list-secret-keys --keyid-format LONG "$git_email" 2>/dev/null | grep "sec" | awk '{print $2}' | cut -d'/' -f2)

if [[ -z "$gpg_key" ]]; then
    echo "No GPG key found for $git_email. Generating a new GPG key..."
    gpg --full-generate-key

    echo "Listing available GPG keys..."
    gpg --list-secret-keys --keyid-format LONG

    read -p "Enter the GPG key ID you want to use for signing commits: " gpg_key
    echo "Uploading GPG key to GitHub..."
    gpg --armor --export "$gpg_key" | gh gpg-key add -

    echo "GPG key has been added to your GitHub account."
fi

git config --global user.signingkey "$gpg_key"
git config --global commit.gpgSign true

echo "Git setup complete, including commit signature verification."