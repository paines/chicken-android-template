
# Template for CHICKEN on Android

[CHICKEN Scheme](call-cc.org) is a popular Scheme-to-C compiler. While
CHICKEN runs well under Android, building and packaging it into an
Android app, and getting its dynamic loaders and all these
Android-nuisances out of the way is tedious.

This project aims to help in this project, and hopes to provide a way
to bootstrap your CHICKEN Android projects quickly.

## Getting started

```
$ git clone https://github.com/Adellica/chicken-sdl2-android-template.git
$ cd chicken-sdl2-android-template
$ ln -s ~/opt/SDL2-2.0.0 jni/SDL # <-- standard SDL2 instructions
$ make
```

The make command should build cross-CHICKEN, SDL2, the sdl2 egg and
some egg dependencies and launch `ant debug` to produce an apk.

## android-chicken-install

The Makefiles compile its own cross-CHICKEN (tag 4.9.0.1). This
CHICKEN provies `android-csc` and `android-chicken-install` and all
the other CHICKEN tools that should work mostly like normal CHICKEN
tools. The CHICKEN tools are not built for the target (your app won't
have csc), only `libchicken.so`.

You can add egg dependencies under `jni/entry/entry.meta`.

## Notes

If you rename your application package in AndroidManifest,
chicken-core and eggs will have to be rebuilt from scratch.

If you want to install eggs in your app that are not released, adding
them to `entry.meta`, won't help. You can run your
`android-chicken-install` directly, however, from your unrelease egg's
directory. This is also useful if you need to patch official eggs and
install these.
