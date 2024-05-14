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

   The first time you run `docker-compose up`, something like this should happen
   ```
   [+] Running 10/12
   gccrs-workspace [⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿] 679.8MB / 684.1MB Pulling                                                               40.9s 
   ✔ f4bb4e8dca02 Pull complete                                                                                           1.2s 
   ✔ b34c89ba2949 Pull complete                                                                                           0.9s 
   ✔ 61d8855b6961 Pull complete                                                                                           3.8s 
   ✔ b0e8950b3326 Download complete                                                                                      37.0s 
   ✔ 7a2dfbe0ca39 Download complete                                                                                       2.4s 
   ✔ 705d5ce2ef7a Download complete                                                                                       3.3s 
   ⠹ 4f4fb700ef54 Downloading  [==================================================>] 32B/32B                             39.3s 
   ✔ 26eaf58bb146 Download complete                                                                                       4.7s 
   ✔ e6a4a2a7b1b9 Download complete                                                                                       5.0s 
   ✔ d5ba4437dd44 Download complete                                                                                       5.6s 
   ✔ fe30df8d0cd6 Download complete
   ```

   Wait until you see "Docker workspace is ready!" in the terminal. The Workspace is now ready (obviously 🙄).

   Use <kbd>Ctrl</kbd> + <kbd>C</kbd> to stop the command.


   Example output via `fish` shell:
   ```
   [+] Running 0/0
   ⠋ Container gccrs-workspace-gccrs-workspace-1  Recreated                                                                                                                                0.0s 
   Attaching to gccrs-workspace-1
   gccrs-workspace-1  |  * Starting OpenBSD Secure Shell server sshd        [ OK ] 
   gccrs-workspace-1  | Docker workspace is ready!
   gccrs-workspace-1  | Entry directory is /
   gccrs-workspace-1  | CD-ing into /home
   gccrs-workspace-1  | Current directory is /home
   gccrs-workspace-1  | Downloading .clang-format...
   gccrs-workspace-1  | Downloading .vimrc...
   gccrs-workspace-1  | Downloaded all quality of life script
   gccrs-workspace-1  | gccrs-workspace is ready
   gccrs-workspace-1  | Currently at /home with directory structure:
   gccrs-workspace-1  | .
   gccrs-workspace-1  | |-- initialize.py
   gccrs-workspace-1  | `-- workspace
   gccrs-workspace-1  | 
   gccrs-workspace-1  | 1 directory, 1 file
   gccrs-workspace-1  | Your ~workspace~ is ready
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

## Default Features

> *On going work. Jasmine's going to work. Ork Ork Ork~~~*

## gccrs cloning
This section describes different steps prior and after of cloning your fork.

1.  **Setting up ssh keys**
   
      Please **create a new ssh key** in the workspace in this [generating a new ssh-key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) article
      in order for git to recognize your ownership of your fork.
      
      Alternatively, to **not create a new ssh key**, you can follow these steps to copy your ssh key to `.workspace` in order for git to recognize your ownership of your fork.

      - In your original MacOS terminal (not the docker container), run `pbcopy < ~/.ssh/id_ed25519` to copy your ssh key into your copy-paste board.

      - In your docker environment terminal, run `vim ~/.ssh/id_ed25519` and paste your ssh-key into that file, type `:wq` to close the file via vim
      
      - In the same docker environment terminal, run `chmod 600 ~/.ssh/id_ed25519` so that only you can read and write, this helps keep ssh quiet on error `Permissions 0xxx for '/home/workspace/.ssh/id_ed25519' are too open.`

      You can now clone your fork with this newly copy-pasted ssh key.
2. **Cloning your fork**

   After this, you can clone your fork down in `~` now.
   ```bash
   cd ~
   git clone `your fork .git here` gccrs # Clone your fork and rename your cloned folder to gccrs
   cd gccrs # change directory into your fork
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
   - **Whether you want to install prepare-commit-msg git hook for 'git commit-mklog' alias** - You really should do this to avoid being overwhelmed by the work flow of gccrs in general.

   Example output via `fish` shell during git customization
   ```
   workspace@1a7cad37dc38 ~/gccrs (master)> ./contrib/gcc-git-customization.sh
   Your name [(no default)]? jjasmine
   Your email address (for git commits) [(no_default)]? ###############
   Local name for upstream repository [origin]? 
   Account name on gcc.gnu.org (for your personal branches area) [workspace]? 

   Local branch prefix for personal branches you want to share
   (local branches starting <prefix>/ can be pushed directly to your
   personal area on the gcc server) [me]? 

   Install prepare-commit-msg git hook for 'git commit-mklog' alias [yes]? yes
   Setting up tracking for personal namespace workspace in remotes/users/me
   ```

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

5. **You're done!**

   Congrats on setting up your work space for gccrs, now, please refer back to the [Linux section](https://github.com/Rust-GCC/gccrs#linux) of gccrs to
   continue build and test all the test cases before development.

   Alternative if you have followed all the steps from 1 to 4 and am currently in gccrs, run this code to start building the code base by default.
   All the dependencies should have been installed for you.

   Change from `make -j2` to a higher core count to build faster.

   ```
   mkdir ../gccrs-build && cd ../gccrs-build && ../gccrs/configure --prefix=$HOME/gccrs-install --disable-bootstrap --enable-multilib --enable-languages=rust && make -j2 # Change to -jX to use X core to build.
   ```

   Then run the tests:
   ```
   make check-rust
   ```


6. **Speeding up git (RECOMMENDED, OPTIONAL)**

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

   `docker buildx build --platform linux/arm64  -t jjasmine/gccrs-workspace:vx.y --push .` where x, y are integers

   Something like this should be displayed:
   ```
   [+] Building 159.7s (22/23)                                                          docker:desktop-linux
   => pushing jjasmine/gccrs-workspace with docker                                                    158.9s
   => => pushing layer b34e060e7f68                                                                     6.2s
   => => pushing layer a0d20f2d597d                                                                     5.0s
   => => pushing layer 25b7309d5bdb                                                                     5.1s
   => => pushing layer 5f70bf18a086                                                                   158.5s
   => => pushing layer 30d28f08fbad                                                                     4.3s
   => => pushing layer 22cb36038158                                                                    10.7s
   => => pushing layer 902f74f878ca                                                                    11.0s
   => => pushing layer 706723e7a464 156.98MB / 1.07GB                                                 158.5s
   => => pushing layer e1327057188d 108.13MB / 181.12MB                                               158.5s
   => => pushing layer 2b967fea2034 120.12MB / 723.98MB                                               158.5s
   => => pushing layer 0c6ee22ab34f 109.58MB / 149.92MB                                               158.5s
   => => pushing layer 718cff4cb42c 100.02MB / 185.59MB                                               158.5s
   => => pushing layer e765fc14f7f3                                                                   158.5s
   => => pushing layer 0e53a3b142a5                                                                   158.5s
   => => pushing layer bfa656ccdc47                                                                   158.5s
   => => pushing layer 842bef16b8fb                                                                   158.5s
   ```

## FAQ and Errors

- **WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED error on ssh**

   It is possible that you've registered port 2200 (the default port of gccrs-workspace) with another host. There are two methods to resolve this.

   1. Run
   `vim  ~/.ssh/known_hosts` or your favorite editor on the file and search for `[127.0.0.1]:2200` and delete those lines to reset them.

   2. Another method you can do is to use a different port via
   `docker-compose.yml` settings where the line involved ports are highlighted
   ```yml
      version: "3.9"
      services:
      gccrs-workspace:
         image: jjasmine/gccrs-workspace
         tty: true
         volumes:
            - ./.workspace:/home/workspace
         ports:
            - "2200:22"     <---- CHANGE YOUR PORT FROM 2200:22 TO xxxx:22    

- **git operations are taking a long time. What is going on?**

   Please refer to `Speeding up git` subsection in the [gccrs-cloning](#gccrs-cloning) section

### VS-Code related

- **Vscode's C++ analysis server is taking a very long time to scan, what is going on?**

   gccrs is a big repo, hence it will take a long time to scan every file. I suggest only open vscode in `gccrs/gcc/rust` to limit the processing requirements of vscode.

- **Vscode's C++ analysis is not working.**

   You might want to run `chmod +x /home/workspace/.vscode-server/extensions/ms-vscode.cpptools-1.19.9-linux-arm64/bin/cpptools` and roll back the `C/C++ Extension Pack` to `v1.2.0`. 

   This error has been reported to occur on `v1.3.0` of the extension.

## Acknowledgements

This repository was originally forked from [CS162](https://cs162.org/) and thus benefitted heavily from the infrastructure that was set up by CS162 course staff.

Contributors including (but not excluding):
- https://github.com/ShreyasKallingal
- https://github.com/PotatoParser
- https://github.com/jel221

I decided to break fork since I think the repo has deviated from the original structure of course staff.