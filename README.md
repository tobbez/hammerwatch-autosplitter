# [LiveSplit](https://livesplit.org/) auto splitter for [Hammerwatch](https://store.steampowered.com/app/239070/Hammerwatch/)

To use:

- [Download this repository](https://github.com/tobbez/hammerwatch-autosplitter/archive/refs/heads/master.zip) and unpack it
- Right-click LiveSplit, click `Edit Layout...`
- Click `+` -> `Control` -> `Scriptable Auto Splitter`
- Double click `Scriptable Auto Splitter` in the list
- Click `Browse...` and select `Hammerwatch.asl`
- Click `OK` twice
- To load the splits: right-click LiveSplit, click `Open Splits` -> `From file...` and select `Hammerwatch - Any% Solo.lss`

The splitter was developed against the Steam version.

It was tested to work both when Hammerwatch is launched from Steam, and when launched from outside of Steam (with Steam closed).

## Features

- Start
- Split
- Reset

## Splits

Splits are based on [this any% run by Kragnir](https://www.speedrun.com/hammerwatch/run/yvg2ep4y) and assumes the same route.
Most of the splits should be usable for the 100% category as well (at least when using the route used by the current top run).

Each split can be disabled/enabled individually in the splitter settings.

A file containing the splits is available as [Hammerwatch - Any% Solo.lss](https://raw.githubusercontent.com/tobbez/hammerwatch-autosplitter/master/Hammerwatch%20-%20Any%25%20Solo.lss).

As there are 17 splits in total, you may want to edit the `Splits` component in your LiveSplit layout and set `Total Splits` to 17 so all splits are visible simultaneously.

<table>
  <thead>
    <tr>
      <th>Split</th>
      <th>Trigger</th>
    </tr>
  </thead>
  <tbody>
    <tr><th colspan="2">Act 1</th></tr>
    <tr>
      <td>Floor 1</td>
      <td>Entering floor 3 from floor 1</td>
    </tr>
    <tr>
      <td>Floor 3</td>
      <td>Entering Queen floor from floor 3</td>
    </tr>
    <tr>
      <td>Queen</td>
      <td>Entering floor 4 from the Queen floor</td>
    </tr>
    <tr><th colspan="2">Act 2</th></tr>
    <tr>
      <td>Floor 4</td>
      <td>Entering floor 6 from floor 4</td>
    </tr>
    <tr>
      <td>Floor 6</td>
      <td>Entering floor 5 from floor 4</td>
    </tr>
    <tr>
      <td>Floor 5</td>
      <td>Entering Knight floor from floor 5</td>
    </tr>
    <tr>
      <td>Knight</td>
      <td>Entering floor 7 from the Knight floor</td>
    </tr>
    <tr><th colspan="2">Act 3</th></tr>
    <tr>
      <td>Floor 7</td>
      <td>Entering floor 8 from floor 7 (second time)</td>
    </tr>
    <tr>
      <td>Floor 8</td>
      <td>Entering floor 9 from floor 8</td>
    </tr>
    <tr>
      <td>Floor 9</td>
      <td>Entering the Lich floor from floor 9</td>
    </tr>
    <tr>
      <td>Lich</td>
      <td>Entering floor 11 from floor 10 (second time)</td>
    </tr>
    <tr><th colspan="2">Act 4</th></tr>
    <tr>
      <td>Floor 10</td>
      <td>Entering floor 11 from floor 10 (second time)</td>
    </tr>
    <tr>
      <td>Floor 11</td>
      <td>Entering floor 12 from floor 11</td>
    </tr>
    <tr>
      <td>Floor 12</td>
      <td>Entering floor 11 from floor 12</td>
    </tr>
    <tr>
      <td>Dragon reached</td>
      <td>Entering the Dragon floor from floor 11</td>
    </tr>
    <tr>
      <td>Dragon killed</td>
      <td>Dragon killed</td>
    </tr>
    <tr>
      <td>End</td>
      <td>Victory screen shown</td>
    </tr>
  </tbody>
</table>

## Game Time

This splitter does not implement game time. The game's internal run timer is paused while shops (and other menus) are open, making it unsuitable for tracking game time.

In any case, all prior runs use Real Time timing.