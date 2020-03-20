# CrashBandicooter

Crash Bandicoot! For your macOS desktop!!

![screenshot of crash bandicoot desktop toy](https://p199.p4.n0.cdn.getcloudapp.com/items/6quBJlRN/Screen%20Shot%202020-03-20%20at%2019.13.05.png?v=93e549b5a2c681936f4cdf39ed68f824)

Inspired by [this tweet](https://twitter.com/ticky/status/1240078387256803328), including the entirely-not-mine-and-probably-still-copyrighted assets in [this executable](https://archive.org/details/crash_bandicoot_desktop_character) for Windows.

Download it [here](https://p199.p4.n0.cdn.getcloudapp.com/items/p9uKZDdw/CrashBandicooter.app.zip?v=0bdcdb52bca1af29a817062c254ab165)!

## Requirements

- macOS 10.13

## Contributing

Build, run, off you go. No package manager or anything.

## Notes

If you want to extract the assets yourself, here's what it looked like for me.

### Tools

The main one is `icoutils`, which gives us the `wrestool` command. I have Imagemagick and `ffmpeg` on hand for noodlin' around too.

```bash
brew install icoutils
```

### Extract Assets

```bash
wrestool -x -o ./wres crash.exe         # extracts the BMPs, but doesn't know how to handle the WAVs
wrestool -x --raw -o ./wres crash.exe   # extracts the WAVs, but doesn't transform the BMPs
```

### Generate Transparent `.png`s

```bash
convert ./crash.exe_2_3000_2057.bmp ./crash.exe_2_3000_2057.png                                           # extract into PNG
convert ./crash.exe_2_3000_2057.png -colorspace sRGB -transparent 'srgb(252, 4, 252)' ./transparent.png   # convert background into transparency

mkdir tiles
magick ./transparent.png -crop 152x150 tiles/tile%04d.png                                                 # extract each frame into a tile
```

### Bonus Fun: Create Movie

(note, this will bring the pink background back, because the video doesn't know how to transparency. Fool!)

```bash
ffmpeg -r 12 -f image2 -s 152x150 -i tiles/tile%04d.png -vcodec libx264 -crf 25  -pix_fmt yuv420p clip.mp4
```

## Thanks

Internets!!
