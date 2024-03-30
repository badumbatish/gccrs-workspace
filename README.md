# gccrs-workspace

## Introduction

Welcome to the gccrs-workspace, an ARM64 Docker-based environment for the gccrs designed to be used with MacOS!

This is created to standardized the development process.

## Prerequisites
Docker is a cross-platform tool for managing containers. 

First, you will have to download and install Docker to your machine so you can access the Workspace. This can be done in one of following two ways.

- **(Preferred)** Download the Docker Desktop app from the [Docker website](https://docs.docker.com/desktop/).
- **(or)** download both the [Docker Engine](https://docs.docker.com/engine/) and [Docker Compose](https://docs.docker.com/compose/)

## Getting Started
jjasmine only built an ARM version to work with with MacOS.

1. **Clone this GitHub Repository via https**
  
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
Example output:
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

Example output:
```
jjsm@MacBook-Air ~/D/c/gccrs-workspace (main)> ssh workspace@127.0.0.1 -p 2200 -o "PasswordAuthentication yes"
The authenticity of host '[127.0.0.1]:2200 ([127.0.0.1]:2200)' can't be established.
ED25519 key fingerprint is SHA256:LSt4ID5MGVhlh5qaIaI5OuG3GjTers4nI7B/0ywQAEg.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[127.0.0.1]:2200' (ED25519) to the list of known hosts.
workspace@127.0.0.1's password: 
Permission denied, please try again.
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
   This will stop the container. Your data should still be saved within the hidden `.workspace` folder, so you can restart the container as needed and pick up where you left off.

   **Note: To be safe, always push work you want to keep to Github!**
   
   **Use with caution:** If you ever need it, you can use `sudo rm -rf .workspace` to reset the Workspace. 

## Avoiding Password Entry

To avoid entering the password every time you SSH into the container, follow these additional steps from your host machine:

1. **Copy Your SSH Key**
   ```bash
ssh-copy-id -o "PasswordAuthentication yes" -p 2200 -i ~/.ssh/id_ed25519.pub worksp
ace@127.0.0.1 
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
You can now enjoy a passwordless SSH experience for your CS162 workspace:
`ssh gccrs-wp`

Happy coding!

## (OPTIONAL) Updating the image

**Not updated yet.**

**You only need to do this if staff push changes to the image. We will let you know if/when this happens.**

You may need to update the image if changes are pushed. You could completely reset your workspace by deleting the .workspace directory. However, we provide a mechanism to safely update by tracking changes with git.

1. To be extra safe, **push anything you want to keep to Github first**.

2. Pull the latest image from Docker hub with `docker image pull cs162/pintospace`.

3. Stop and remove the old container. You can do this through the Docker desktop GUI or the command line via `docker stop CONTAINER_ID && docker rm CONTAINER_ID`. You can find your `CONTAINER_ID` through `docker ps -a`. 

4. Run `docker-compose run -i cs162` and follow the instructions to update. You can exit out of the shell with `exit` once it's done.
   
5. You're done updating! You can go back to the usual way of starting the container.

## Building From Source (OPTIONAL and not recommended)

**Local build:**

Simply run `docker build .`

**For staff:**

If you would like to deploy changes to Docker Hub for ARM and x86, first sign in with the `cs162` account and run the following buildx command:

`docker buildx build --platform linux/amd64,linux/arm64  -t cs162/pintospace:latest --push .`

## FAQ and Errors

### WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED
It is possible that you've registered port 2200 with another host

Run
`vim  ~/.ssh/known_hosts` and search for `[127.0.0.1]:2200` and delete those lines to reset them.

Another method you can do is to use a different port via
`docker-compose.yml` settings