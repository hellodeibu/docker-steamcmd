# SteamCMD for Docker

Based on the Ubuntu 18.04 image. This is a barebones image designed to be used as a starting point for your own game-specific image.

## v1.5 changes

The newer version greatly reduces the amount of steps required to build the image, and makes its purpose of being used as a pre-build step rather than the main image to be used more clear. While you can still certainly use this image directly, you'll more likely want to use this as one of your build steps instead.

## Directories

The image prepares a few folders that I recommend you use in your setup where appropriate. These are:

- `/opt/steam` contains the actual steamcmd setup.
- `/opt/game` is prepared and owned by the same `steam` user and is recommended to be used to `force-install_dir` your game to
- `/opt/app` if you need to run anything else alongside or as a pre- or post-install step, you might want to use this directory. It is also owned by the same `steam` user.

## A note on the actual SteamCMD installation

While this image prepares everything you need, by default it does not do a first-run that pulls in the latest Steam updates and what-not. This is done as this run would actually fail if you happen to run this on Docker Hub for example, but if you locally build your image and want to have Steam 100% ready to go, it would be good to uncomment-out that line and have it do its first run. However, as this will happen automatically when installing a game too, you might as-well just do it then.

```Dockerfile
# Run SteamCMD to finalize installation — Disable this if you run this on something like Docker Hub as it will fail
RUN [ "./steamcmd.sh", "+@NoPromptForPassword 1", "+login anonymous",  "+quit" ]
```
