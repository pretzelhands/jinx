<p align="center">
<img alt="jinx - a magical nginx wrapper" src="https://pretzelhands.com/assets/jinx/jinx-logo-full.png" width="560">
</p>

---

jinx is a wrapper script for nginx written entirely in Bash. It helps you manage your sites and configurations in a more streamlined way than working with plain shell commands.

---

#### Table of Contents

* [Prerequisites](#prerequisites)
* [Installation](#installation)
* [Updating](#updating)
* [Deinstallation](#deinstallation)
* [Configuring `jinx`](#configuring-jinx)
    * [Setting options](#setting-options-via-jinx)
    * [Getting options](#reading-the-value-of-options-with-via-jinx)
    * [Available options](#available-options)
* [Using the commands](#using-the-commands)
    * [`jinx start|restart|stop`](#jinx-startrestartstop)
    * [`jinx logs`](#jinx-logs)
    * `jinx site`
        * [`jinx site activate`](#jinx-site-activate)
        * [`jinx site deactivate`](#jinx-site-deactivate)
        * [`jinx site delete`](#jinx-site-delete)
        * [`jinx site create`](#jinx-site-create)
        * [`jinx site edit`](#jinx-site-edit)
* [Templating](#templating)
    * [Naming of templates](#naming-of-templates)
    * [Default template](#default-template)
    * [Replacement variables](#replacement-variables)
* [Miscellaneous](#miscellaneous)
* [Contributors](#contributors)

---

## Prerequisites

Since this is an early release of jinx, it still has some assumptions about your enviroment. Currently these are as follows:

* **Your sites are organized in two folders: `sites-available` and `sites-enabled`**: The former one holding all available sites you could potentially host and the latter holding the sites that are reachable on the web.

## Installation

Installation of jinx can be done in one line using the convenient installer script. Just copy and paste this into your terminal and you'll be all set!

```
bash <(curl -s https://raw.githubusercontent.com/pretzelhands/jinx/master/installer)
```

If you don't trust using `curl` with remote scripts, you can [inspect the script](https://github.com/pretzelhands/jinx/blob/master/installer) and execute the steps manually.

## Updating

jinx will occasionally (once a day) check if a new version is available in this repository. Should this be the case you will receive a little notice on top of the other commands.

If you're ever unsure which version of `jinx` you're running you can check with `jinx version`.

You need only run `jinx update` and the tool will handle the rest!

## Deinstallation

<small>You should probably skip this chapter. 😁</small>

Should you ever wish to uninstall `jinx`, you can do so with `jinx uninstall`.
You will be asked if you're really sure that this is what you wanted. To complete
deinstallation run `jinx uninstall -y`

## Configuring `jinx`

`jinx` has a few configuration options that you should be aware of. When you run `jinx` for the first time it will automatically create a `.jinx/config` in your home directory and display a notice that this has happened. This configuration file contains some basic configuration to make everything run smoothly.

A first run looks approximately like this:

```
$ jinx start
First run! Creating default configuration in ~/.jinx/config
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

### Setting options manually

You can do this if you want to see exactly how everything is set up. Open up `~/.jinx/config` in your favorite editor and off you go. The configuration file is arranged as a set of key-value pairs separated by an equals sign.

There are a few options you can set. You can find detailed descriptions down below.

### Reading the value of options with via `jinx`

If you only provide an option key to `jinx` it will spit out the value that this option is currently set to.
```
$ jinx config nginx_path
/etc/nginx/
```
This can be useful if you want to do a quick check or if you want to use the value in your own script.

### Available options

* **nginx_path:** The root directory of your nginx installation.    
  This is where your `nginx.conf` and `sites-available`/`sites-enabled` directories should reside. 
  
* **config_path:** This is where `jinx` looks for configuration templates.
  It is a subdirectory of `nginx_path`. By default this directory is set to `templates` which means `jinx` will look for
  templates in `/etc/nginx/templates`.
  
* **editor:** This is the editor used to open your configuration files when you use `jinx site edit`.
  You can use any editor you like (e.g. `emacs` or `vim`). I defaulted to nano, because it is the easiest for newcomers.

* **grumpy:** This option can be used to determine whether you want colored output or not. 
  If you set `grumpy` to `1` the console output will not be colored. By default it is set to 0.

## Using the commands

To see all commands offered by `jinx`, you can run `jinx help` and it will give you a nicely formatted list:
```
$ jinx help

Available commands:

config <key>                             get config value from ~/.jinx/config
config <key> <value>                     set config value in ~/.jinx/config

site activate <name> [--restart|-r]      activate a site
site deactivate <name> [--restart|-r]    deactivate a site
site delete <name> [--yes|-y]            delete a site
site create <name> [ipv4=<ipv4 address>] [ipv6=<ipv6 address>] [<template>]          create a site from template
site edit <name>                         edit a site .conf file with editor

start                                    start nginx service
restart                                  restart nginx service
stop                                     stop nginx service
logs                                     get nginx error logs

version                                  output jinx version number
update                                   update to latest version
uninstall                                uninstall jinx (aw!)
```

### `jinx start|restart|stop`

Does as it says. These commands start, restart or stop your nginx server.

### `jinx logs`

Opens up what it determines to be the nginx error logs you have configured. For this it examines the `error_log` 
directive in your `nginx.conf`

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

#### Deleting a site
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

### `jinx site edit`

This will open up the chosen site configuration in the text editor of your choice. By default `nano` is used, but as described in ["Available Options"](#available-options) you can set this to any text editor of your liking.

## Templating

This first version of `jinx` offers some very limited templating functionality to make creating sites as frictionless as possible. By default `jinx` will look for templates in the `templates` subdirectory of your `nginx` folder (e.g. `/etc/nginx/templates`.) This can be changed by [adjusting the `config_path` setting of `jinx`](#available-options).

### Naming of templates

The name of the template is decided by the file name of it. (e.g. a file `/etc/nginx/templates/php.conf` can be used by invoking the following command

```
$ jinx site create mysite.com php
```

### Default template

If no special template is passed to `jinx` (`jinx site create mysite.com`), it will look for a default template in `/etc/nginx/templates/default.conf`, or in whichever folder you have specified for configuration templates.

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

Other replacement variables are also available - `_IPv4_` and `_IPv6_`. Through them you can set your desired IPv4 and|or IPv4 address. The case when many IPv4 or IPv6 addresses are assigned, they are not yet implemented.

## Miscellaneous

This is for common questions and other quips I want to add but that didn't fit in anywhere.

#### Is this usable in production?
I personally use it to run all the ~25 virtual hosts for my freelance business and it has been doing its job well so far. I would still recommend you try it out in a local environment first, though. See how you like it and if you think it's good, put it on your server.

#### What's with the name? Isn't nginx pronounced "engine-x"?
I'm so glad you asked! And you are indeed correct that the proper pronounciation of "nginx" is "engine-x". However before many, many people told me so, I used to consistently pronounce it as "En-jinx". So I just threw out the "En" and kept the rest. Hence, `jinx`!

## Like this project? Support it!

If you like this project and want to help me out, you can go and [buy me a coffee!](https://paypal.me/pretzelhands/5EUR)
In case that is not an option you can also help me by sharing this project with your friends and [following me on Twitter](https://twitter.com/_pretzelhands)

## Contributors

* **[Richard 'pretzelhands' Blechinger](https://twitter.com/_pretzelhands)** (Creator/maintainer)
* **[Vladislav 'click0' Prodan](https://github.com/click0)**