# SMH Helper UI <!-- omit from toc -->

Additoinal options to help overcome common user issues with Stop Motion Helper (SMH).

## Table of Contents <!-- omit from toc -->

- [Description](#description)
  - [Features](#features)
  - [Rational](#rational)
- [Pull Requests](#pull-requests)

## Description

![preview](/media/preview.png)

This adds a new `Stop Motion Helper` list in the Spawnmenu's' `Options` tab.

### Features

- **Keybinds**: Conveniently find all SMH binds in one place, with the ability to help rebind these commands to a certain key
  - Copy the correct `bind` command, which the user can paste to the console
  - This menu uses all existing commands which contain the `smh_` prefix

### Rational

The UI originates from the need to help users overcome the Source Engine's technical barrier when it comes to using Garry's Mod as an animation tool. To identify one technical barrier, new users often ask how to make SMH keybinds. This UI eases that burden by showing the binds and providing a button to copy the bind command immediately for the user to paste into their console

## Pull Requests

When making a pull request, make sure to confine to the style seen throughout. Try to add types for new functions or data structures. I used the default [StyLua](https://github.com/JohnnyMorganz/StyLua) formatting style.
