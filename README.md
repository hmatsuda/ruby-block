# ruby-block package [![Build Status](https://travis-ci.org/hmatsuda/ruby-block.svg?branch=master)](https://travis-ci.org/hmatsuda/ruby-block) [![Build status](https://ci.appveyor.com/api/projects/status/bnovofmb9wyffqai/branch/master?svg=true)](https://ci.appveyor.com/project/hmatsuda/ruby-block/branch/master)

![A screenshot of your package](http://cl.ly/image/181n0f1R1U0O/ruby-block.gif)

Highlight matching ruby block when cursor is on the following keywords:

`end`, `elsif`, `else`, `when` `rescue` and `ensure`.


## Features
- Highlight matching ruby block
- Go to matching line (`ctrl-g b`)

## Requirements
Enable the [`language-ruby`](https://atom.io/packages/language-ruby) package.

## Settings
You can change behavior to highlight block by settings menu.
  
- Show matching block into bottom panel(like Emacs minibuffer)

![show bottom panel](http://cl.ly/image/0d081N2t2p0f/Image%202015-01-16%20at%201.05.32%20%E5%8D%88%E5%89%8D.png)

- Highlight line of matching block

![highlight line](http://cl.ly/image/1v3N0F1R3B15/test_rb_-__Users_hakutoitoi__atom_packages_ruby-block_-_Atom.png)

- Highlight gutter of matching block

![highlight gutter](http://cl.ly/image/1x0g1e291k0v/Image%202015-01-16%20at%201.03.15%20%E5%8D%88%E5%89%8D.png)

Highlighting line and bottom panel are enable by default.

## Overwriting default styles
If you want to change default highliting color, just add styles with preference for color like below into `styles.less`.
```less
:host, atom-text-editor, atom-text-editor::shadow {
  .line-number.ruby-block-highlight {
    background-color: red;
  }
  
  .highlights {
    .ruby-block-highlight .region {
      background-color: red;
    }
  }
}
```

## Thanks
Porting the features of [juszczakn](https://github.com/juszczakn)'s great Emacs [Ruby Block Mode](https://github.com/juszczakn/ruby-block) to Atom.

## Contributing
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
