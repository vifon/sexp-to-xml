NAME
====

sexp-to-xml

DESCRIPTION
===========

A converter from s-expression to XML/XHTML written in Common Lisp.

USAGE
=====

```Common-Lisp
CL-USER> (sexp-to-xml '((head
                         (title "my-site"))
                        ((body
                          :bgcolor
                          "yellow")
                         (p
                          "foo"
                          (br)
                          (b "bar")
                          "baz")
                         ((a :href "http://google.com")
                          "Google")
                         ((img :src "http://example.com/image.png")))))
```
```XML
<head>
  <title>
    my-site
  </title>
</head>
<body bgcolor="yellow">
  <p>
    foo
    <br />
    <b>
      bar
    </b>
    baz
  </p>
  <a href="http://google.com">
    Google
  </a>
  <img src="http://example.com/image.png" />
</body>
```

AUTHOR
======

Wojciech 'vifon' Siewierski < wojciech dot siewierski at gmail dot com >

COPYRIGHT
=========

Copyright (C) 2014  Wojciech Siewierski

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
