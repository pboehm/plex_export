# plex_export

`plex_export.rb` allows you to export Series from your Plex Media Server into a
`.m3u` file (used for playlists). This playlist can then be used everywhere,
where Plex is not supported natively.

## Installation

```
$ git clone https://github.com/pboehm/plex_export.git
$ cd plex_export
$ bundle install
```

## Exporting

```
$ PLEX_HOST=1.2.3.4 PLEX_TOKEN=ABCDEFEDEDEDED bundle exec ./plex_export.rb "Simpsons"
#EXTM3U
#EXTINF:-1,S01E01 - Es weihnachtet schwer.avi
http://1.2.3.4:32400/library/parts/85/file.avi?X-Plex-Token=ABCDEFEDEDEDED
....
```

### Extract the PLEX_TOKEN

For remote access to your Plex Media Server, a special token for authentication
ist required. Go to the Plex Web UI and choose some episode, look for the
Download Action and extract the Token value from the corresponding url (The
value after `X-Plex-Token=`).

## LICENSE

Copyright (C) 2014 Philipp Böhm

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


