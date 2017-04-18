Homebrew-ninja
===============
These formulae duplicate software provided by OS X, though may provide more recent or bugfix versions.
They may also provide conflicting formulae that I consider to be more desirable, i.e. the latest hpn-ssh
enabled version of openssh instead of the absolute latest.

How do I install these formulae?
--------------------------------
Just run the command :

`brew tap ccosby/ninja` 

and then :

`brew install ninja`

You should get this output (OS X 10.9.1) :


![Home-brew-ninja](http://thecustomizewindows.com/download/brew-ninja.png) 

If the formula conflicts with one from mxcl/master or another tap, you can `brew install ccosby/ninja`.

You can also install via URL:

```
brew install https://raw.github.com/ccosby/homebrew-ninja/master/<formula>.rb
```

Docs
----
`brew help`, `man brew`, or the Homebrew [wiki][].

[wiki]:http://wiki.github.com/mxcl/homebrew
