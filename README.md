# gccrs-workspace

## Introduction

Welcome to the gccrs-workspace, an ARM64 Docker-based environment for the gccrs designed to be used with ARM MacOS!

This is created to standardize the development process for Mac-based devs on gccrs.

> **PRECAUTION**: Only ARM-based Mac devices should be cloning and using this since the docker image that this is based on is configured for ARMv64.

## Prerequisites
Docker is a cross-platform tool for managing containers. 

First, you will have to download and install Docker to your machine so you can access the Workspace. This can be done in one of following two ways.

- **(Preferred)** Download the Docker Desktop app from the [Docker website](https://docs.docker.com/desktop/).
- **(or)** download both the [Docker Engine](https://docs.docker.com/engine/) and [Docker Compose](https://docs.docker.com/compose/)

## Getting Started
jjasmine only built an ARM version to work with with MacOS, please don't use this if you are not ARM-based, virtualization cross-platform are heavy on resources.

1. **Clone this GitHub Repository via https**
   ```bash
   git clone https://github.com/badumbatish/gccrs-workspace.git
   ```
2. **Navigate to the Repository**
   ```bash
   cd gccrs-workspace
   ```

3. **Run Docker Compose for the first time**
   ```bash
   docker-compose up
   ```

   This command will build and start the Docker container defined in the `docker-compose.yml` file. If needed, you can change the port used for SSH within this file.

   Wait until you see "Docker workspace is ready!" in the terminal. The Workspace is now ready (obviously 🙄).

   Use <kbd>Ctrl</kbd> + <kbd>C</kbd> to stop the command.


   Example output via `fish` shell:
   ```
   [+] Running 2/0
   ✔ Network gccrs-workspace_default              Created                                                                          0.0s 
   ✔ Container gccrs-workspace-gccrs-workspace-1  Created                                                                          0.0s 
   Attaching to gccrs-workspace-1
   gccrs-workspace-1  |  * Starting OpenBSD Secure Shell server sshd        [ OK ] 
   gccrs-workspace-1  | Docker workspace is ready!
   gccrs-workspace-1  | Entry directory is /
   gccrs-workspace-1  | CD-ing into /workspace
   gccrs-workspace-1  | Current directory is /workspace
   gccrs-workspace-1  | Downloading .clang-format...
   gccrs-workspace-1  | Downloading .vimrc...
   gccrs-workspace-1  | Downloaded all quality of life script
   gccrs-workspace-1  | gccrs-workspace is ready
   ```
4. **Starting the container in the background**
   ```bash
   docker-compose up -d
   ```
   This will simply start the container in the background and keep it running. With Docker Desktop, you can also manage this through the GUI.

5. **SSH into the Container**
   ```bash
   ssh workspace@127.0.0.1 -p 2200 -o "PasswordAuthentication yes"
   ```

   Use the password `workspace` the first time you SSH into the container.

   Example output via `fish` shell:
   ```
   jjsm@MacBook-Air ~/D/c/gccrs-workspace (main)> ssh workspace@127.0.0.1 -p 2200 -o "PasswordAuthentication yes"
   The authenticity of host '[127.0.0.1]:2200 ([127.0.0.1]:2200)' can't be established.
   ED25519 key fingerprint is SHA256:LSt4ID5MGVhlh5qaIaI5OuG3GjTers4nI7B/0ywQAEg.
   This key is not known by any other names.
   Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
   Warning: Permanently added '[127.0.0.1]:2200' (ED25519) to the list of known hosts.
   workspace@127.0.0.1's password: 
   Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 6.6.16-linuxkit aarch64)

   * Documentation:  https://help.ubuntu.com
   * Management:     https://landscape.canonical.com
   * Support:        https://ubuntu.com/pro
   workspace@9c72bba2b0d5:~$ 
   ```
6. **Stop the container**
   
   _Within your host machine's shell (not the Workspace shell you ssh'd into)_:
   ```bash
   docker-compose down
   ```

   Example output with `fish` shell:
   ```bash
   jjsm@MacBook-Air ~/D/c/gccrs-workspace (main) [127]> docker compose down
   [+] Running 2/1
   ✔ Container gccrs-workspace-gccrs-workspace-1  Removed                         10.1s 
   ✔ Network gccrs-workspace_default              Removed                         0.1s 
   ```

   This will stop the container. Your data should still be saved within the hidden `.workspace` folder, so you can restart the container as needed and pick up where you left off.

   **Note: To be safe, always push work you want to keep to Github!**

   **Use with caution:** If you ever need it, you can use `sudo rm -rf .workspace` to reset the Workspace.  This will erase your cloned fork and any ssh keys necessary to push your work to GitHub.

## Avoiding Password Entry

   To avoid entering the password every time you SSH into the container, follow these additional steps from your host machine:

1. **Copy Your SSH Key**
   ```bash
   ssh-copy-id -o "PasswordAuthentication yes" -p 2200 -i ~/.ssh/id_ed25519.pub workspace@127.0.0.1 
   ```

   Replace `~/.ssh/id_ed25519.pub` with the path to your SSH public key.

2. **Update SSH Config**
   To alias the full SSH command, add the following lines to your `~/.ssh/config` file:
   ```
   Host gccrs-wp
     HostName 127.0.0.1
     Port 2200
     User workspace
     IdentityFile ~/.ssh/id_ed25519
   ```
   You can now enjoy a passwordless SSH experience for your gccrs workspace:
   `ssh gccrs-wp`

   Happy coding!


## gccrs cloning
This section describes different steps prior and after of cloning your fork.

1.  **Setting up ssh keys**
   
      Please create a new ssh key in the workspace or copy your ssh key to `.workspace` in order for git to recognize your ownership of your fork.

2. **Cloning your fork**

   After this, you can clone your fork down in `~` now.
   ```bash
   cd ~
   git clone `your fork .git here`
   ```

3. **Setting up remote (RECOMMENDED, OPTIONAL)**
   After cloning, run this in your forked repo to set an upstream remote
   ```bash
   git remote add upstream https://github.com/Rust-GCC/gccrs.git
   ```

4. **Setting up customization of git (RECOMMENDED, OPTIONAL)**
   In your forked and cloned repo, run
   ```bash
   ./contrib/gcc-git-customization.sh
   ```

   More in-depth documentation (might be outdated) is at [gcc-git-write](https://gcc.gnu.org/gitwrite.html).

   In short, it asks for:
   - **Your name** - git uses this when you commit messages. You can set this globally, but the script will confirm the setting is appropriate for GCC as well. If you have not already set this then git will try to find your name from your account.
   - **Your email address** - similar to above. If this is not set globally, the script will not attempt to guess this field, so you must provide a suitable answer.
   - **The local name for the upstream repository** - normally, the default (origin) will be correct. 
   - **Your account name** on gcc.gnu.org: (Not sure of the usefulness here, just press enter to continue)
   - **The prefix to use for your personal branches** - the default is me, but you can change this if you prefer. (Not sure of the usefulness here, just press enter to continue).

   After setting up the repo via every step, you should be able to see something similar to this:
   
   Example output via `fish` shell:
   ```bash
   workspace@e9318ff46f10 ~/gccrs (master)> git remote -v
   origin  git@github.com:badumbatish/gccrs.git (fetch)
   origin  git@github.com:badumbatish/gccrs.git (push)
   upstream        https://github.com/Rust-GCC/gccrs.git (fetch)
   upstream        https://github.com/Rust-GCC/gccrs.git (push)
   users/me        git@github.com:badumbatish/gccrs.git (fetch)
   users/me        git@github.com:badumbatish/gccrs.git (push)
   ```

5. **Speeding up git (RECOMMENDED, OPTIONAL)**

   This section is based on [git performance](https://www.git-tower.com/blog/git-performance).

   I only recommend these features:

   
   Run
   ```bash
   git config feature.manyFiles true
   ```
   to enable a newer index file version that is smaller in size and thus gets rewritten faster after modifying files in the index.

   and run 
   ```bash
   git update-index --index-version 4
   ```
   to switch to this new indexing

   Run
   ```bash
   git config core.fsmonitor true
   ```
   to [enable](https://git-scm.com/docs/git-config#Documentation/git-config.txt-corefsmonitor) FSMonitor, Git's built-in file system monitor daemon.
   
   Now run 
   ```bash
   git fsmonitor--daemon status
   ``` 
   to see the current status


## (OPTIONAL) Updating the image

   Initially every version of the image should be sufficient for developing gccrs. New updates will only bring quality of life updates if MacOS-based maintainers of gccrs suggest so if not stated otherwise.

   **You should only do this if you'd want to have new quality of life that fits you.**

   You may need to update the image if changes are pushed. You could completely reset your workspace by deleting the .workspace directory. However, we provide a mechanism to safely update by tracking changes with git.

   1. To be extra safe, **push anything you want to keep to Github first**.

   2. Pull the latest image from Docker hub with `docker image pull jjasmine/gccrs-workspace`.

   3. Stop and remove the old container. You can do this through the Docker desktop GUI or the command line via `docker stop CONTAINER_ID && docker rm CONTAINER_ID`. You can find your `CONTAINER_ID` through `docker ps -a`. 

   4. Run `docker-compose run -i gccrs-workspace` and follow the instructions to update. You can exit out of the shell with `exit` once it's done.
      
   5. You're done updating! You can go back to the usual way of starting the container.

## Building From Source (OPTIONAL and not recommended)

- **Local build:**

   Simply run `docker build .`

- **For maintainer:**

   If you would like to deploy changes to Docker Hub, first sign in with the `jjasmine` account and run the following buildx command:

   `docker buildx build --platform linux/arm64  -t jjasmine/gccrs-workspace --push .`

## FAQ and Errors

- **WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED error on ssh**

   It is possible that you've registered port 2200 (the default port of gccrs-workspace) with another host. There are two methods to resolve this.

   1. Run
   `vim  ~/.ssh/known_hosts` or your favorite editor on the file and search for `[127.0.0.1]:2200` and delete those lines to reset them.

   2. Another method you can do is to use a different port via
   `docker-compose.yml` settings

- **git operations are taking a long time. What is going on?**

   Please refer to `Speeding up git` subsection in the [gccrs-cloning](#gccrs-cloning) section

### VS-Code related

- **Vscode's C++ analysis server is taking a very long time to scan, what is going on?**

   gccrs is a big repo, hence it will take a long time to scan every file. I suggest only open vscode in `gccrs/gcc/rust` to limit the processing requirements of vscode.