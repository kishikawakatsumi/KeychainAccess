# Commandant

Commandant is a Swift framework for parsing command-line arguments, inspired by [Argo](https://github.com/thoughtbot/Argo) (which is, in turn, inspired by the Haskell library [Aeson](http://hackage.haskell.org/package/aeson)).

## Example

With Commandant, a command and its associated options could be defined as follows:

```swift
struct LogCommand: CommandType {
	let verb = "log"
	let function = "Reads the log"

	func run(mode: CommandMode) -> Result<()> {
		return LogOptions.evaluate(mode).map { options in
			// Use the parsed options to do something interesting here.
			return ()
		}
	}
}

struct LogOptions: OptionsType {
	let lines: Int
	let verbose: Bool
	let logName: String

	static func create(lines: Int)(verbose: Bool)(logName: String) -> LogOptions {
		return LogOptions(lines: lines, verbose: verbose, logName: logName)
	}

	static func evaluate(m: CommandMode) -> Result<LogOptions> {
		return create
			<*> m <| Option(key: "lines", defaultValue: 0, usage: "the number of lines to read from the logs")
			<*> m <| Option(key: "verbose", defaultValue: false, usage: "show verbose output")
			<*> m <| Option(usage: "the log to read")
	}
}
```

Then, each available command should be added to a registry:

```swift
let commands = CommandRegistry()
commands.register(LogCommand())
commands.register(VersionCommand())
```

After which, arguments can be parsed by simply invoking the registry:

```swift
var arguments = Process.arguments

// Remove the executable name.
assert(arguments.count >= 1)
arguments.removeAtIndex(0)

if let verb = arguments.first {
	// Remove the command name.
	arguments.removeAtIndex(0)

	if let result = commands.runCommand(verb, arguments: arguments) {
		// Handle success or failure.
	} else {
		// Unrecognized command.
	}
} else {
	// No command given.
}
```

For real-world examples, see the implementation of the [Carthage](https://github.com/Carthage/Carthage) command-line tool.

## License

Commandant is released under the [MIT license](LICENSE.md).
