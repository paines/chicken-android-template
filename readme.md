
# Template for CHICKEN on Android

[CHICKEN Scheme](call-cc.org) is a popular Scheme-to-C compiler. While
CHICKEN runs well under Android, building and packaging it into an
Android app, and getting its dynamic loaders and all these
Android-nuisances out of the way is tedious.

This project aims to help in this project, and hopes to provide a way
to bootstrap your CHICKEN Android projects quickly.

## Prerequisites

* Android [SDK](http://developer.android.com/sdk/) and
  [NDK](http://developer.android.com/tools/sdk/ndk/) r10.
* A [Chicken](http://code.call-cc.org) installation. Version 4.8.0 or
  higher is recommended.
* The `ssax`, `sxpath` and `sxml` eggs
* `ndk-build` on your path

## Getting started

```
$ # download SDL2 into ~/opt. See https://libsdl.org/download-2.0.php
$ git clone https://github.com/Adellica/chicken-sdl2-android-template.git
$ cd chicken-sdl2-android-template
$ android update project -p .
$ ln -s ~/opt/SDL2-2.0.0 jni/SDL # <-- standard SDL2 instructions
$ make #<-- this takes very long
```

The make command should build CHICKEN, SDL2 and some accompanying
eggs, and an apk. You can add egg dependencies for your app under
`jni/entry/entry.meta`.

The template includes an `example.scm` that:

- Renders a green square on a red background in a game-loop
- Starts a REPL on port 1234

## REPL fun

Here's how you might want to setup your development process. You can
connect to the REPL remotely and do some rapid prototyping. For
example:

```
[me@laptop]$ nc 192.168.0.20 1234 #<-- ip of my tablet on the same WiFi
#;> game-thread
#<thread: thread0>
#;> render
#<procedure (render)>
#;> (define render void)
#;> ;; now my green rectangle has disappeared
#;> fps  ;; <-- top-level variable updated every second by game-thread
60
```

This also works well with Emacs if you specify `nc <ip> 1234` as your
Scheme interpreter (you might have to `C-q space` to force the spaces
in the Emacs prompt).

## android-chicken-install

The Makefiles compile its own cross-CHICKEN (tag 4.9.0.1). This
CHICKEN provies `android-chicken-install` and friends, which work like
you're used to on your desktop. The CHICKEN tools are not built for
the target however, your app won't have csc, only `libchicken.so`.

## Notes

If you rename your application package in AndroidManifest,
chicken-core and eggs will have to be rebuilt from scratch. The
package-name is built into the target-CHICKEN so that it knows where
to look for extensions.

If you want to install eggs in your app that are not released, adding
them to `entry.meta`, won't help. You can run your
`android-chicken-install` directly, however, from your unrelease egg's
directory. This is also useful if you need to patch official eggs and
install these.

Note that if the Cross-CHICKEN toolchain suceeds in installing an egg
for the host, but fails for the target build step - it will
incorrectly assume the egg is installed and won't retry to install it
for the target. For now you'll have to use `android-chicken-uninstall`
to retry installing failed eggs.
