module LoggingUtils

using Reexport

@reexport using Logging

export @with_logger, @no_logging

"""
    @with_logger(logger, code_to_execute)

A macro version of [`Logging.with_logger`](@ref) that allows more slick code.
Note that `code_to_execute` is executed in a block, so the scope of certain
variables may be different than when executed in local scope. The most common
situations where this applies is with [`Base.include`](@ref) and when making
assignments (Example 2 shows an example of handling this).

See also [`@no_logging`](@ref)

## Example 1

```julia
using LoggingExtras, LoggingUtils

@with_logger MinLevelLogger(global_logger(), Logging.Warn) (@info "Hide me"; @warn "Show me")
```

## Example 2

The return value of `code_to_execute` can be assigned to a variable in the following way:

```julia
using LoggingUtils

a = @with_logger NullLogger() if readline() == "" @warn "No input"; 0 else println("Input received"); 1 end
```
"""
macro with_logger(logger, code)
    return :( with_logger($(esc(logger))) do
                 $(esc(code))
    end)
end

"""
    @no_logging(code_to_execute)

Execute `code_to_execute` sending all logging to the
[`Logging.NullLogger`](@ref).
Note that similar to [`@with_logger`](@ref), `code_to_execute` is executed in a
block, so the scope of certain variables may be different than when executed in
local scope.

## Example

```julia
using LoggingUtils

function hello(n::Int64)
    j = 0
    for i in 1:n
        if iseven(i)
            println(i)
        else
            @info i
            j += 1
        end
    end
    return j
end

@no_logging @assert hello(4) == 2
```
"""
macro no_logging(code)
    return :( with_logger(NullLogger()) do
                 $(esc(code))
             end)
end

end # module LoggingUtils
