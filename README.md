### Intro
A minimalist, topic-oriented zsh dotfiles setup inspired by **@holman**.

I don't have any qualms with dotfile frameworks like oh-my-zsh or prezto. I've used them with some luck in the past, and I wanted to put some time and understanding into how they worked by writing my own. As my shell needs are fairly simple, I value fast startup time over tons of aliases. I also only add aliases/scripts I use regularly.

Though I took the time to write a nice README, my dotfiles aren't very configurable. Best to just steal what you want.

### What's Nifty?
* Stylish, two-line [prompt](https://github.com/mattgreen/dotfiles/blob/master/zsh/prompt.zsh) with git info
* [Jump alias](https://github.com/mattgreen/dotfiles/blob/master/zsh/jump.zsh) to switch between projects quickly
* Extremely fast startup:
````
$ time zsh -i -c "print -n"
zsh -i -c "print -n"  0.07s user 0.02s system 96% cpu 0.097 total   # Warm disk cache + SSD
````

### Screenshot
![Preview](http://f.cl.ly/items/0Y2d2A241z1r0j2U3D1q/preview.png)

