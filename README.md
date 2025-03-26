# LoggingUtils.jl

Some utilies that can be useful in connection with the
[`Logging`](https://docs.julialang.org/en/v1/stdlib/Logging/) standard
library. Also exports all exported symbols from the `Logging` standard
library.

## Installation

From the Julia REPL, execute

```julia
using Pkg
pkg"add https://github.com/GHTaarn/LoggingUtils.jl"
```

or using [FreeRegistry](https://github.com/GHTaarn/FreeRegistry):

```julia
using Pkg
pkg"registry add https://github.com/GHTaarn/FreeRegistry"
pkg"add LoggingUtils"
```

## Use

There are two entry points, `@no_logging` and `@with_logger` which are both
described more precisely in their docstrings.

### Examples

```julia
using LoggingUtils

function verbose_sin(x)
    @info "calculating sin"
    sin(x)
end

@no_logging println(verbose_sin(8))

mylogger = SimpleLogger()

@with_logger mylogger println(verbose_sin(8))
```

Illustrating that `@no_logging` suppresses logging, whereas `@with_logger`
redirects logging to the specified logger.

### Caveats

Both `@no_logging` and `@with_logger` use the 
[`Logging.with_logger`](https://docs.julialang.org/en/v1/stdlib/Logging/#with_logger)
function internally and therefore assignments must be done externally, e.g.

```julia
using LoggingUtils

function verbose_sin(x)
    @info "calculating sin"
    sin(x)
end

a = @no_logging verbose_sin(1)
@assert a == sin(1)
@no_logging a = verbose_sin(2)
@assert a == sin(2)
```

where the first assertion would pass and the second would fail.
