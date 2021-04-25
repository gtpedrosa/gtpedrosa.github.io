+++
title = "Enabling Frescobaldi MIDI output"
author = ["Guilherme Pedrosa"]
date = 2020-06-21T23:29:00-03:00
tags = ["MIDI", "lilypond", "Frescobaldi"]
draft = false
+++

Trying to export a composition engraved with lilypond to MIDI, I have found out that it was not properly set up. The resulting MIDI was mute, even though I could see its contents using Audacity.

The solution lies in [this post](https://askubuntu.com/questions/463575/frescobaldi-midi-player-seems-to-be-working-fine-but-doesnt-produce-any-sound). After installing a MIDI to Wave converter and player called timidity and starting its daemon:

```shell
sudo apt-get install timidity
sudo service timidity start
```

A _Timidity port 0_ should be available after refreshing Midi Settings as player output option in the _Edit > Preferences > Midi Settings_ in Frescobaldi.