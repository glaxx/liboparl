liboparl
========

You are laying eyes on liboparl. A client implementation of the OParl-1.0 specification.
It's your easy way to access endpoints in a straightforward fashion.

Features
--------

  * [x] Parsing all OParl objects
  * [x] Check syntactic spec conformity - types and fieldnames are correct
  * [ ] Check semantic spec conformity - values are realistic and make sense [ in progress ]

Meta-Features
-------------

  * [x] Unittests
  * [x] API-Documentation (GNOME Devhelp book format)
  * [x] i18n

Characteristics
---------------

The library's objective is to abstract OParls object format away from you. You as someone
who develops an application for OParl does not need to know how to resolve the ids that
objects yield to you and how to parse the objects themselves and check them for correctness.

The library does not want to interfere with your way to write programs which is why liboparl
leaves all non-OParl-related tasks to you. OParl exposes anything it needs from you through
signals and interfaces. For example, if liboparl wants to request a new object via HTTP, it
triggers the signal ```resolve_url``` that belongs to the ```OParl.Client```-Object. This
signal gives you an url and expects to get a JSON-string back. You can implement this method
however you feel is right for your project. If you program liboparl in Python you could use
requests. If you program liboparl in Perl, you could use LWP. This also gives you the
possibility to handle multithreading as you wish. And the best thing: liboparl can provide
an API that is as clean and uncluttered as possible.

As mentioned before, liboparl is a GObject-based library. This means that you can use it in
any programming language that supports GObject-Introspection. Famous examples are e.g. Python
Ruby or Lua. Check if your favoured language is available at 
[GObjectIntrospecion](https://wiki.gnome.org/action/show/Projects/GObjectIntrospection/Users)

Dependencies
------------

The following libraries have to be present for liboparl to run:

  * glib-2.0
  * json-glib-1.0

Building
--------

[Meson > 0.40.0](http://mesonbuild.com) is used as the buildsystem for liboparl. The build dependencies
are the following:

  * valac > 0.32 - Vala compiler
  * valadoc - Vala documentation tool
  * g-ir-compiler - GObject introspection compiler
  * json-glib-dev - Dev headers for json-glib
  * libgirepository1.0-dev - Dev headers for gobject introspection

Clone and build the library as follows:

```
$ git clone https://github.com/oparl/liboparl
$ cd liboparl
$ mkdir build
$ cd build
$ meson ..
$ ninja
```

If you desire to install the library, execute:

```
# ninja install
```

Running the examples
--------

liboparl supports GObject-Introspection which means you can consume it in various
popular languages including but not limited to: Python, Perl, Lua, JS, PHP.
I compiled some examples on how to program against the library in Python in the examples-folder.

Feel free to add examples for your favorite language.

Note: If you installed the library in /usr/local, you have to export the following
environment variables for the examples to work:

```
$ export LD_LIBRARY_PATH=/usr/local/lib 
$ export GI_TYPELIB_PATH=/usr/local/lib/girepository-1.0/
```
