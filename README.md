<p align="center">
<img alt="jinx - a magical nginx wrapper" src="https://pretzelhands.com/assets/jinx/jinx-logo-full.png" width="560">
</p>

---

jinx is a wrapper script for nginx written entirely in Bash. It helps you manage your sites and configurations in a more streamlined way than working with plain shell commands.

## Prerequisites

Since this is an early release of jinx, it still has some assumptions about your enviroment. Currently these are as follows:

* **Your sites are organized in two folders: `sites-available` and `sites-enabled`**: The former one holding all available sites you could potentially host and the latter holding the sites that are reachable on the web.

* **ONLY ON macOS: You have `gnu-sed` installed :** This is because macOS comes delivered with POSIX `sed` by default, which behaves in incompatible ways with GNU `sed`. You can easily [install `gnu-sed` via Homebrew](https://formulae.brew.sh/formula/gnu-sed). Don't forget to alias `gsed` to `sed`

**NOTE: Automatic start, stop and restart currently only work on macOS and Ubuntu**    
I do not have a lot of experience with other distros, thus the commands interacting directly with the service are currently only available on macOS and Ubuntu. If you want to make them work with your favorite distro, please [add the necessary changes to this function](https://github.com/pretzelhands/jinx/blob/master/jinx#L55) and submit a pull request. Thank you!

## Installation

For the time being, installation has to be done manually. You can do so as described below. The folder in your `PATH` may vary and doesn't necessarily have to be `/usr/bin`. (I understand if you don't trust random shell scripts)

**Clone the git repository**
```bash
$ git clone https://github.com/pretzelhands/jinx.git /tmp/jinx
```

**Copy the `jinx` script to some folder in your `PATH`**
```bash
$ sudo mv /tmp/jinx/jinx /usr/bin/jinx
```

## Configuring `jinx`

`jinx` has a few configuration options that you should be aware of. When you run `jinx` for the first time it will automatically create a `.jinxrc` in your home directory and display a notice that this has happened. This `.jinxrc` contains some basic configuration to make everything run smoothly.

A first run looks approximately like this:

```
$ jinx start
First run! Creating default configuration in ~/.jinxrc
Pardon the interruption, we will now continue running your command.

Success. Started nginx service on your system.
```

### Setting options via `jinx`

This is the recommended way of setting options, because it will automatically format them correctly for later use.
To set an option with `jinx`, you need only write `jinx config <option> <value>` and `jinx` will handle the rest

```
$ jinx config nginx_path /etc/nginx/
Success. Updated setting 'nginx_path' to '/etc/nginx/'.
```

There are a few options you can set. You can find detailed descriptions down below.

### Reading the value of options with via `jinx`

If you only provide an option key to `jinx` it will spit out the value that this option is currently set to.
```
$ jinx config nginx_path
/etc/nginx/
```
This can be useful if you want to do a quick check or if you want to use the value in your own script.

### Setting options manually

You can do this if you want to see exactly how everything is set up. Open up `~/.jinxrc` in your favorite editor and off you go. The configuration file is arranged as a set of key-value pairs separated by an equals sign.

**NOTE: You must follow the format guidelines stated below yourself if you choose to manually edit this file**

### Available options

* **nginx_path:** The root directory of your nginx installation.    
  This is where your `nginx.conf` and `sites-available`/`sites-enabled` directories should reside. 
  (This setting **must** end in a slash. The `config` command automatically adds one if required)
  
* **config_path:** This is where `jinx` looks for configuration templates.
  It is a subdirectory of `nginx_path`. By default this directory is set to `configurations` which means `jinx` will look for
  templates in `/etc/nginx/configurations`. (This setting **must not** contain any slashes. The `config` command will
  automatically remove them if required)
  
* **editor:** This is the editor used to open your configuration files when you use `jinx site edit`.
  You can use any editor you like (e.g. `emacs` or `vim`). I defaulted to nano, because it is the easiest for newcomers.

## Using the commands

To see all commands offered by `jinx`, you can run `jinx help` and it will give you a nicely formatted list:
```
$ jinx help

Available commands:

start                                    start nginx service
restart                                  restart nginx service
stop                                     stop nginx service

site activate <name> [--restart|-r]      activate a site
site deactivate <name> [--restart|-r]    deactivate a site
site delete <name> [--yes|-y]            delete a site
site create <name> [<template>]          create a site from template
site edit <name>                         edit a site .conf file with editor

config <key>                             get config value from ~/.jinxrc
config <key> <value>                     set config value in ~/.jinxrc
```

### `jinx start|restart|stop`

Does as it says. These commands start, restart or stop your nginx server. You may be asked for your root password, as it is not possible to run an nginx server on port 80 without `sudo` access.

### `jinx site activate`

This links the site you pass in from `sites-available` to `sites-enabled`, thus making it available on the web. The name of the site corresponds to the name of the configuration file. So if you have a configuration file called `/etc/nginx/sites-available/pretzelhands.com.conf` then the site name will be `pretzelhands.com` and you can activate it like so:

```
$ jinx site activate pretzelhands.com
Success. Activated site 'pretzelhands.com'.
```

You can also add the `-r` or `--restart` flag to automatically restart nginx after the activation

```
$ jinx site activate pretzelhands.com --restart
Success. Activated site 'pretzelhands.com'.
Success. Restarted nginx service on your system.
```

### `jinx site deactivate`

This deactivates any active site you have. The naming conventions work the same as for `jinx site activate`. And you can also pass in the same `-r` or `--restart` flag.


#### Simple
```
$ jinx site deactivate pretzelhands.com
Success. Deactivated site 'pretzelhands.com'.
```

#### With restart
```
$ jinx site deactivate pretzelhands.com --restart
Success. Deactivated site 'pretzelhands.com'.
Success. Restarted nginx service on your system.
```

### `jinx site delete`

This deletes any inactive site you have. Before deleting you will however be prompted if you really wish to delete your site.
You may also not delete any currently active site, to prevent unexpected breaking of your websites.

When prompted if you wish to delete your site accepted values are `y` and `yes`. Note that any site you delete will be **remove permanently**. Be cautious and double check!

#### Refusing to delete site
```
$ jinx site delete pretzelhands.com
Careful: Are you sure you want to delete site 'pretzelhands.com'? (y/N): N
Aborting. Did not receive 'y' or 'yes' as answer, so not deleting site.
```

#### Accepting to delete site
```
$ jinx site delete pretzelhands.com
Careful: Are you sure you want to delete site 'pretzelhands.com'? (y/N): y
Success. Site 'pretzelhands.com' was deleted.
```

#### Skipping the confirmation

You can also skip the confirmation by passing either `-y` or `--yes` to the command.
Use this with caution!

```
$ jinx site delete pretzelhands.com --yes
Success. Site 'pretzelhands.com' was deleted.
```

#### Attempting to delete an active site

This is what happens when you attempt to delete a site that is currently active.

```
$ jinx site delete pretzelhands
ABORTING. Site 'pretzelhands' is currently activated!
If you really want to delete it, please deactivate the site first.
```

### `jinx site create`

This will create a new site based on a template of your choice and move it to your `sites-available` directory so you can immediately activate it. To find out how the template system works, please [refer to the section Templating](#templating) further below.

Note that the same name cannot be used twice and `jinx` will throw an error if you try to do so.

#### Creating a new site with default template
```
$ jinx site create my-awesome-website.com
Success. Site 'my-awesome-website.com' was created and can now be activated.
```

#### Creating a new site from a different configuration template
```
$ jinx site create my-awesome-php-website.com php
Success. Site 'my-awesome-php-website.com' was created and can now be activated.
```

#### Trying to create a site with the same name
```
$ jinx site create my-awesome-php-website.com php
Failure. Site 'my-awesome-php-website.com' already exists. Please choose another name.
```

### `jinx site edit`

This will open up the chosen site configuration in the text editor of your choice. By default `nano` is used, but as described in ["Available Options"](#available-options) you can set this to any text editor of your liking.

## Templating

This first version of `jinx` offers some very limited templating functionality to make creating sites as frictionless as possible. By default `jinx` will look for templates in the `configurations` subdirectory of your `nginx` folder (e.g. `/etc/nginx/configurations`.) This can be changed by [adjusting the `config_path` setting of `jinx`](#available-options).

### Naming of templates

The name of the template is decided by the file name of it. (e.g. a file `/etc/nginx/configurations/php.conf` can be used by invoking the following command

```
$ jinx site create mysite.com php
```

### Default template

If no special template is passed to `jinx` (`jinx site create mysite.com`), it will look for a default template in `/etc/nginx/configurations/default.conf`, or in whichever folder you have specified for configuration templates.

### Replacement variables

All configuration templates are essentially normal nginx configuration files, with the exception that you can use `___` (that's three underscores) as a replacement variable. This will be replaced by the site name you pass to `jinx site create` 

Here is an example of my `default.conf`
```nginx
server {
    listen 80;
    listen [::]:80;
    listen 443 ssl http2;

    include snippets/use-https.conf;
    include snippets/use-non-www.conf;
    include snippets/use-ssl.conf;
    include snippets/use-react.conf;

    server_name ___ www.___;

    root /var/www/live/___;
    index index.html index.htm;
}
```

When I run `jinx site create mysite.com` the resulting `mysite.com.conf` will look as such
```nginx
server {
    listen 80;
    listen [::]:80;
    listen 443 ssl http2;

    include snippets/use-https.conf;
    include snippets/use-non-www.conf;
    include snippets/use-ssl.conf;
    include snippets/use-react.conf;

    server_name mysite.com www.mysite.com;

    root /var/www/live/mysite.com;
    index index.html index.htm;
}
```

## Miscelleanous

This is for common questions and other quips I want to add but that didn't fit in anywhere.

#### What's with the name? Isn't nginx pronounced "engine-x"?
I'm so glad you asked! And you are indeed correct that the proper pronounciation of "nginx" is "engine-x". However before many, many people told me so, I used to consistently pronounce it as "En-jinx". So I just threw out the "En" and kept the rest. Hence, `jinx`!

## Like this project? Support it!

If you like this project and want to help me out, you can go and [buy me a coffee!](https://paypal.me/pretzelhands/5EUR)
In case that is not an option you can also help me by sharing this project with your friends and [following me on Twitter](https://twitter.com/_pretzelhands)
