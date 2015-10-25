# gorillas.rb
Gorillas in Ruby!

![](https://raw.github.com/yurivm/gorillas.rb/master/media/gorillas_screenshot.png)

## What is this?

[Gorillas](https://en.wikipedia.org/wiki/Gorillas_(video_game)) is a game that was distributed with MSDOS 5 and is a basic (wink wink) artillery game.

I've been playing with Gosu a little bit before and I decided to reimplement the game in Ruby for fun.
It looks more or less like the original and should also play like the original, with the only exception: you use your mouse to specify aiming angle and velocity. Asking for those values to be input doesn't feel like 2015 :)

## Installation

The only problem you might encounter is installing [Gosu](https://github.com/gosu/gosu). Gosu has a [tutorial](https://github.com/gosu/gosu/wiki/Ruby-Tutorial) that also explains how to set it up on Linux, Mac and Windows.

At some point I'm going to try to package everything into a single package, but I'm not sure if that works.

## Running

just

```
bundle exec ruby gorillas.rb
```

## Configuration

See the config/gorillas.yml file. You can specify images, sound files and turn sound on/off there. All the images and music are inside the media folder.

## Code

The initial implementation was quite dirty so I'm cleaning stuff up, one file at a time. Stay tuned.

## Credits

Gorillas.rb uses some images and music from [Open Game Art](http://opengameart.org/):

- [Day and Night](http://opengameart.org/content/day-night-in-summerset) by edwinnington
- [Atari Booms](http://opengameart.org/content/atari-booms) by dklon
- [Explosion](http://opengameart.org/content/explosion) by Cuzco

PRs and comments are of course welcome.

That's it, enjoy!



