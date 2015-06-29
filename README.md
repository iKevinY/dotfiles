# iKevinY/dotfiles

This repository contains my [dotfiles](http://dotfiles.github.io), heavily inspired by [@mathiasbynens](https://github.com/mathiasbynens/dotfiles) and [@cowboy](https://github.com/cowboy/dotfiles).

## Installation

**Warning**: You probably don't want to run this command unless you are me. The `dotfiles` script clones *this* repository into `~/.dotfiles`, and it could be broken at point in time.

```bash
bash -c "$(curl -fsSL https://raw.github.com/iKevinY/dotfiles/master/bin/dotfiles)" && source ~/.bashrc
```


## bin/dotfiles

When [dotfiles](bin/dotfiles) is run for the first time, it does a few things:

1. Git is installed if necessary.
2. This repo is cloned into your user directory, under `~/.dotfiles`.
3. Files in `/copy` are copied into `~/`. ([read more](#copy))
4. Files in `/link` are symlinked into `~/`. ([read more](#link))
5. You are prompted to choose scripts in `/init` to be executed.
6. The chosen init scripts are executed in alphanumeric order. ([read more](#init))

On subsequent runs, step 1 is skipped, step 2 just updates the already-existing repo, and step 5 remembers what you selected the last time. The other steps are the same.

### /copy
Any file in the [`/copy`](/copy) subdirectory will be copied into `~/`. Any file that _needs_ to be modified with personal information (like anything containing an email address and private key) should be _copied_ into `~/`. Because the file you'll be editing is no longer in `~/.dotfiles`, it's less likely to be accidentally committed into your public dotfiles repo. Files such as `.hushlogin` which never need to be edited can also be placed in this directory.

### /link
Any file in the [`/link`](/link) subdirectory gets symlinked into `~/` with `ln -s`. Edit one or the other, and you change the file in both places. Don't link files containing sensitive data, or you might accidentally commit that data! If you're linking a directory that might contain sensitive data (like `~/.ssh`) add the sensitive files to your [.gitignore](.gitignore) file!

### /init
Scripts in the [`/init`](/init) subdirectory will be executed. A whole bunch of things will be installed, but _only_ if they aren't already.

* OS X system defaults via the [init/osx_defaults.sh](init/osx_defaults.sh) script
* Homebrew formulae & casks via the [init/osx_homebrew.sh](init/osx_homebrew.sh) script

### Other Subdirectories

* The `/backups` directory gets created when necessary. Any files in `~/` that would have been overwritten by files in `/copy` or `/link` get backed up there.
* The `/bin` directory contains executable shell scripts (including the [dotfiles](bin/dotfiles) script) and symlinks to executable shell scripts. This directory is added to the path.
* The `/caches` directory contains cached files, used by some scripts or functions.
* The `/conf` directory just exists. If a config file doesn't **need** to go in `~/`, reference it from the `/conf` directory.
* The `/source` directory contains files that are sourced whenever a new shell is opened (in alphanumeric order).
* The `/vendor` directory contains third-party libraries.


## Aliases and Functions
To keep things easy, the `~/.bashrc` and `~/.bash_profile` files are extremely simple, and should never need to be modified. Instead, add your aliases, functions, settings, etc. into one of the files in the `source` subdirectory, or add a new file. They're all automatically sourced when a new shell is opened.


## Scripts
In addition to the aforementioned [dotfiles](bin/dotfiles) script, there are a few other [bin scripts](bin).

* [dotfiles](bin/dotfiles) - (re)initialize dotfiles. It might ask for your password (for `sudo`).
* [src](link/.bashrc#L8-18) - (re)source all files in `/source` directory


## Extended Configuration

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository. This file can also be used to override settings, functions and aliases from the dotfiles repository.


## License

iKevinY/dotfiles is licensed under the [MIT license](LICENSE).
