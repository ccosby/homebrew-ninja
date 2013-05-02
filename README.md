Homebrew-ninja
===============
These formulae duplicate software provided by OS X, though may provide more recent or bugfix versions.
They may also provide conflicting formulae that I consider to be more desirable, i.e. the latest hpn-ssh
enabled version of openssh instead of the absolute latest.

How do I install these formulae?
--------------------------------
Just `brew tap homebrew/ninja` and then `brew install <formula>`.

If the formula conflicts with one from mxcl/master or another tap, you can `brew install homebrew/ninja/<formula>`.

You can also install via URL:

```
brew install https://raw.github.com/ccosby/homebrew-ninja/master/<formula>.rb
```

Docs
----
`brew help`, `man brew`, or the Homebrew [wiki][].

[wiki]:http://wiki.github.com/mxcl/homebrew
