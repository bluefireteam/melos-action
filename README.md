# melos-action

Activates [Melos](https://github.com/invertase/melos) for your GitHub workflow.


## Usage

The `melos-action` needs to have either dart or flutter on the path before it
can activate melos.


### With Flutter

```yaml
steps:
- uses: actions/checkout@v2
- uses: subosito/flutter-action@v2
- uses: bluefireteam/melos-action@v1
- run: melos bootstrap
```


### With Dart

```yaml
steps:
- uses: actions/checkout@v2
- uses: dart-lang/setup-dart@v1
- uses: bluefireteam/melos-action@v1
- run: melos bootstrap
```


### Arguments

You can set a version constraint for the melos version if you don't want the
latest version (default).

Simply adding the version, like in the example below, will guarantee that
exactly the specified version is activated.

You can also use all range constraints that exist for pub.
For example `'^1.0.0'` would allow any version from 1.0.0 to 2.0.0 (but not
including 2.0.0). If you want an even tighter restriction you can define the
version like this `'>=1.2.0 < 1.3.0'` which would allow any version between
1.2.0 (included) to 1.3.0 (excluded).

```yaml
steps:
- uses: actions/checkout@v2
- uses: subosito/flutter-action@v2
- uses: bluefireteam/melos-action@v1
  with:
    melos-version: '1.2.0'
- run: melos bootstrap
```


