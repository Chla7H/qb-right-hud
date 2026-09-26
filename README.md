# qb-right-hud
<img width="358" height="180" alt="image" src="https://github.com/user-attachments/assets/dcd7b45e-b9a4-45d6-9d25-0427c3e55090" />

Compact QBCore health + armor HUD inspired by the supplied reference.

## Install

1. Copy `qb-right-hud` into your server `resources` folder.
2. Add this after `qb-core` in `server.cfg`:

```cfg
ensure qb-right-hud
```

3. Restart the resource/server.

## Config

Edit `config.lua`:

- `AccentColor`: health color (default `#ee1c3e`).
- `ArmorColor`: armor color (default `#2389ff`).
- `Position`: `right-center`, `right-top`, or `right-bottom`.
- `OffsetX` / `OffsetY`: fine position adjustment.
- `AlwaysShowArmor`: keep the armor row visible at 0.
- `UpdateInterval`: UI refresh interval.
- `HideDefaultAmmo`: hides GTA/FiveM's native weapon icon and ammo counter.

## Commands / exports

- `/togglehud` toggles visibility.
- Client export: `exports['qb-right-hud']:SetHudVisible(true/false)`.

## Weapon display

When the player equips a weapon, a compact panel appears above the health HUD with:

- Combined kill and weapon panel matching the supplied reference.
- 142 embedded weapon images, including official FiveM and supplied custom weapons.
- Current weapon name, magazine ammo, and reserve ammo.
- Images are embedded in JavaScript, avoiding FiveM NUI file-path and cache issues.
- Local Oxanium gaming font with aligned tabular ammo and kill numbers.

The panel hides automatically when the player is unarmed.

## Kill indicator

- Shows `1x` when the local player kills another player.
- Consecutive kills increase the counter and restart the timer.
- Hides after `Config.KillDisplayTime` (10 seconds by default).
- Use `/t123` in chat to test the indicator.
- Other resources can trigger `qb-right-hud:client:RegisterKill` on the client.
