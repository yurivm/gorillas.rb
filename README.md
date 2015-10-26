# gorillas.rb
Gorillas in Ruby!

![alt tag](https://raw.github.com/yurivm/gorillas.rb/master/media/gorillas_screenshot.png)

## What is this?

[Gorillas](https://en.wikipedia.org/wiki/Gorillas_(video_game)) is a game that was distributed with MSDOS 5 and is a basic (wink wink) artillery game.

I've been playing with Gosu a little bit before and I decided to reimplement the game in Ruby for fun.
It looks more or less like the original and should also play like the original, with the only exception: you use your mouse to specify aiming angle and velocity. Asking for those values to be input doesn't feel like 2015 :)

## Installation

The only problem you might encounter is installing [Gosu](https://github.com/gosu/gosu). Gosu has a [tutorial](https://github.com/gosu/gosu/wiki/Ruby-Tutorial) that also explains how to set it up on Linux, Mac and Windows.

### Installing Gosu

on a Mac with Homebrew, do this:

```
brew install sdl2
brew install libogg libvorbis
```

### Installing Ruby

Gorillas.rb should support Ruby 2+, I've specified 2.2.2 in Gemfile. Install that with your favorite tool, rbenv or rvm, or system-wide. Makes no difference.

### Getting gems

```
gem install bundler
bundle install
```

At some point I'm going to try to package everything into a single package, but I'm not sure if that works.

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



