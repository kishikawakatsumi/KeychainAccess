# SwiftCov

A tool to generate test code coverage information for Swift.

## Installation

Install the `swiftcov` command line tool by running `git clone` for this repo followed by `make install` in the root directory.

## Usage

```shell
$ swiftcov generate xcodebuild -project Example.xcodeproj -scheme 'Example' -configuration Release -sdk iphonesimulator test
```

```shell
$ swiftcov generate --output ./coverage --threshold 1 xcodebuild -project Example.xcodeproj -scheme 'Example' -configuration Release -sdk iphonesimulator test
```

### Options

- `--output` specify output directory for generated coverage files
- `--threshold` specify limitation for counting hit count (for performance)

## How to run example project

```shell
$ make install
$ cd Examples/ExampleFramework/
$ swiftcov generate --output coverage_ios \
  xcodebuild test \
  -project ExampleFramework.xcodeproj \
  -scheme ExampleFramework-iOS \
  -sdk iphonesimulator \
  -configuration Release
```

Please see [the generated coverage file](https://github.com/realm/SwiftCov/blob/master/Examples/ExampleFramework/results/Calculator.swift.gcov)!

## Advanced Usage

### Convert to HTML output with Gcovr

```shell
$ gcovr --root . --use-gcov-files --html --html-details --output coverage.html --keep
```

See [the generated coverage file](https://github.com/realm/SwiftCov/blob/master/Examples/ExampleFramework/results/coverage.html).

## License

MIT licensed.
