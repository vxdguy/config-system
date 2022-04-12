![](https://capsule-render.vercel.app/api?type=waving&section=header&color=gradient&height=320&fontColor=f0f0ff&desc=Rise%20of%20the%20Machines:%20Clones&text=config-system&fontSize=39)

#  The "PLAN"

Contents of the README.md describe the "PLAN" for `config-system` and the software is not yet in a working state.

# Clones!  I need Clones!

I re-installed one of my Ubuntu VMs for , I don't know, at least the 4th time and it dawned on me that I'm not following one of my rules.  Every time I setup this server, I customize it the same way.  Why am I repeating the same work?  The rule is "Never repeat yourself more than twice," and I broke my own rule.  I blame the long interval between VM rebuilds...  That's my story and I'm sticking to it.

`config-system` lets you save a system state and re-create it on a different machine. There's two main parts, a set of scripts to *get* a system's configuration, and a set of scripts to *set* a system's configuration.  "System configuration" can be anything, there just needs to be a get/set script for that configuration.  Here's a concrete example of settings can be copy over:

OS Settings:

- Identify OS and produce a differential between the unmodified OS and the current system.  For example, if run on Ubuntu Server 20.04, 

- APT repositories and their GPG keys
- Installed packages
- SSH server keys
- /etc files for base OS packages

Global Application Settings:

- /etc files for user installed packages (generic)
- "alternative" application settings
- nginx webserver settings & wwwroot contents
- php8 settings
- mariadb settings & databases (exported)

User Application Settings

- Visual Studio Code settings
- Conky customizations
- Wallpaper
- Gnome extensions & settings

As the admin, you can disable any get scripts as well as write your own.

# How It Works

`get-config` runs `get-*` scripts in the `get-scripts` folder.  Scripts is a misnomer; any executable programs in the folder that begins with `get-*` will be executed in alphanumeric order.

Data files, that is your configuration collected by the `get-*` scripts, is saved in the `sys-config-<timestamp>` folder.  Once you capture the configuration you want, rename the `sys-config-<timestamp>` to  `sys-config`, and run the `package-config` script.

Copy the resulting `install-config.run` to the target system.  Run the file to unpack into a new folder and run `set-config` to apply your settings.

There are a few intelligent design failsafes:

- Source and target system must be the same OS, version, and variant.
- `backup` folder contains an `undo` script to reverse all changes.