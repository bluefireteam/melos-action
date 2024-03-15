# Melos Action

Activates [Melos](https://github.com/invertase/melos) for your GitHub workflow.
It can also automatically version, dry-run and publish your packages to pub.dev.

NOTE: Remember to check the "Allow GitHub Actions to create and approve pull
requests" checkbox in the bottom of the Actions > General section of your
repository settings if you want to use `create-pr: true`.


## Installation

The `melos-action` needs to have either dart or flutter on the path before it
can activate melos. With this set up it will automatically add melos to your
path and run `melos bootstrap`, for more advanced usa-cases, like automatic
releases, see the [Parameters](#parameters) section.


### With Flutter

```yaml
steps:
- uses: actions/checkout@v4
- uses: subosito/flutter-action@v2
- uses: bluefireteam/melos-action@v3
```


### With Dart

```yaml
steps:
- uses: actions/checkout@v4
- uses: dart-lang/setup-dart@v1
- uses: bluefireteam/melos-action@v3
```


## Parameters

There are a few parameters that can be set to customize the behavior of the
action, they are all optional.

| Parameter                 | Default               | Description                                              |
|---------------------------|-----------------------|----------------------------------------------------------|
| melos-version             | latest                | The version of Melos to activate.                        |
| run-bootstrap             | true                  | Whether to run `melos bootstrap` after activating Melos. |
| run-versioning            | false                 | Whether packages should be versioned.                    |
| run-versioning-prerelease | false                 | Whether packages should be versioned as a prerelease.    |
| publish-dry-run           | false                 | Whether packages should be dry-run published.            |
| publish                   | false                 | Whether packages should be published to pub.dev.         |
| create-pr                 | false                 | Whether to create a PR with the changes made by Melos.   |
| git-email                 | contact@blue-fire.xyz | The email to use when committing changes.                |
| git-name                  | Melos Action          | The name to use when committing changes.                 |

To set a specific parameter you use the `with` keyword in your action, like in
the example below.

```yaml
steps:
  - uses: actions/checkout@v4
  - uses: subosito/flutter-action@v2
  - uses: bluefireteam/melos-action@v3
    with:
      run-bootstrap: false
```


### Set melos version

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
- uses: actions/checkout@v4
- uses: subosito/flutter-action@v2
- uses: bluefireteam/melos-action@v3
  with:
    melos-version: '1.2.0'
```


### Automatic versioning and publishing

NOTE: This won't work until
[dart-lang/pub.dev#7462](https://github.com/dart-lang/pub-dev/pull/7462) is
merged.

It is recommended that you read through and follow the set up steps at
[dart.dev](https://dart.dev/tools/pub/automated-publishing) before continuing,
not applicable for dry-runs of course.

Remember that if your package isn't already published to pub.dev you need to
manually publish it the first time, after that you can use the action to
automatically publish it.

If you want to automatically release your packages for example when a new PR is
merged you have a few different options:

1. Create two actions, one which versions and dry-run publishes your packages
   and then creates a release preparation PR every time a PR from a normal user
   is merged and then a second action that publishes your packages to pub.dev 
   when the release preparation PR is merged.
2. Directly publish your packages to pub.dev when a PR from a normal user is
   merged and create a PR with the versioning changes afterwards.
3. Only use the action to ensure in your pipeline that your packages are
   releasable, i.e doesn't fail any dry run.

And this note is worth repeating - Remember to check the "Allow GitHub Actions
to create and approve pull requests" checkbox in the bottom of the
Actions > General section of your repository settings if you want to use
`create-pr: true`.


### 1. Version and release on each PR

Create a file with the following content name `prepare-release.yaml` and place
it in `.github/workflows/`:

```yaml
name: Prepare release
on:
  push:
    branches: [main]

jobs:
  prepare-release:
    name: Prepare release
    permissions:
      contents: write
      pull-requests: write
    runs-on: ubuntu-latest
    if: "!contains(github.event.head_commit.message, 'chore(release)')"
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - uses: bluefireteam/melos-action@v3
        with:
          run-versioning: true
          publish-dry-run: true
          create-pr: true
```

Create a second file with the following content named `publish.yaml` and place
it in `.github/workflows/`:

```yaml
name: Publish packages
on:
  push:
    branches: [main]

jobs:
 publish-packages:
   name: Publish packages
   permissions:
     contents: write
     id-token: write # Required for authentication using OIDC
   runs-on: [ ubuntu-latest ]
   if: contains(github.event.head_commit.message, 'chore(release)')
   steps:
     - uses: actions/checkout@v3
     - uses: subosito/flutter-action@v2
     - uses: bluefireteam/melos-action@v3
       with:
         publish: true
```


### 2. Directly publish to pub.dev after each PR is merged

Create a second file with the following content named `publish.yaml` and place
it in `.github/workflows/`:

```yaml
name: Publish packages
on:
  push:
    branches: [main]

jobs:
 publish-packages:
   name: Publish packages
   permissions:
     contents: write
     id-token: write # Required for authentication using OIDC
   runs-on: [ ubuntu-latest ]
   steps:
     - uses: actions/checkout@v4
     - uses: subosito/flutter-action@v2
     - uses: bluefireteam/melos-action@v3
       with:
         run-versioning: true
         publish-dry-run: true
         publish: true
         create-pr: true
```


### 3. Only run dry-run versioning and publishing as a check

Create a second file with the following content named `verify-releasable.yaml`
and place it in `.github/workflows/`:

```yaml
name: Verify that the packages are releasable.
on:
  push:
    branches: [main]
  pull_request:

jobs:
 publish-packages:
   name: Verify packages
   runs-on: [ ubuntu-latest ]
   steps:
     - uses: actions/checkout@v4
     - uses: subosito/flutter-action@v2
     - uses: bluefireteam/melos-action@v3
       with:
         run-versioning: true
         publish-dry-run: true
```

See the [examples directory](./examples) to get files that you can copy and
paste into your repository.
