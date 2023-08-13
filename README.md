# Disk Space Usage

This is a small desktop app that will allow you to analyze
the disk space usage of a given directory of your choosing.

It's built in [Dart](https://dart.dev) using [Flutter](https://flutter.dev/).

It can be built for Windows, Linux and MacOS.

## Screenshot

![Screenshot](docs/screenshot.png)

## Running tests

```
make test
```

## Formatting

We use a line length of `100` characters, which is good enough to show two files side by side on a modern 27-inch
screen.
Line length can be set in Jetbrains IDEs `Preferences > Editor > Code Style > Dart`.

```
make format
```

If your prefer a different line length, feel free to update the `Makefile` to your team's liking
and have developers configure their IDE as well.

## Check before push

To check formatting and run tests before pushing your code

```
make check
```

or

```
make
```
