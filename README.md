# GD-Human-Framework

Godot Human generator.

Based on MakeHuman assets.

**New version is W.I.P. and NOT recommended for production - major changes ahead. Use `go_makehuman_dot branch for pre-rework runtime-only generator` instead.**

## How to enable plugin:

1. Add `res://addons/gd-human-framework/scripts/char_edit_global.gd` as global autoload with name `CharEditGlobal`, otherwise plugin won't work properly.
2. Enable the plugin.

## TODO.

- [ ] Add customization panel for morphs, not only for clothes
- [ ] Re-add runtime editor front-end.
- [ ] Instantiate base human instead of simply editing.
- [ ] Make all custom types toggleable.

## License:

This project is based on [Go_MakeHuman_dot (see it's readme for advanced asset management)](./README-ORIGINAL.md)

## Godot project

Public Domain or CC-by-zero.

*Yni Viar's edit: I think they meant CC0 license - added a CC0 license to the project*

## Human skin shader

There are two components from 2 authors:
- HumanShaders [(MIT License)](./src/char_edit/meshs/mats/materials/LICENSE_HumanShaders)
- GdCharacterCreation [(MIT License)](./src/char_edit/meshs/mats/materials/LICENSE_GdCharacterCreation)

## Yni Viar's commentary

Since **Humanizer gone AGPL** (because of copying MakeHuman code, so **previous versions are affected too!!!**),
I decided to make an alternative human generator.