# Python Code Style

## Virtual Environment

- Conda is preferred, along with uv for package/project management
- Assume that each python project will have its own conda environment with the dependencies in the pyproject file

## Formatting

- Ruff is preferred
- Each project will ideally define the ruff config in the pyproject file

## Style Guide

- Follow the regular PEP 8 style guide
- Prefer to use attrs for decorating classes (over @dataclass, etc)
- Use frozen attrs classes wherever possible
- Avoid properties, but cached_properties for frozen classes are fine
- Prefer to pass in an attrs dataclass instead of a lot of different arguments to a function
- Prefer creating Enums (string enums, int enums, etc.) for categorical variables instead of using strings or integers directly
- Avoid global variables
- Try to minimize state mutation and function side-effects as much as possible
- Constants are ideally collected in a separate file
- Constants may also be placed in individual files if their scope/usage is not large. These must always be placed at the top of the file
- Never use emojis in code

## Type Hints

- Type hints are necessary in almost every circumstance
- May be skipped for trivial inner functions, etc.

## Imports

- Avoid wildcard imports
- Avoid relative imports -- assume that the project has been installed in the given conda env

## Documentation

### Docstrings

- Can be skipped for trivial or obvious functions, classes and files (getters, setters, test files, etc) and for simple/obvious functions, but otherwise must be added to every function, class and file
- Must follow the """\n docstring \n""" convention. They must never be on one line, even for short descriptions
- Don't add function param and result docstrings. Function and argument names along with the type hints must be sufficient

### Comments

- Avoid comments that are obvious or trivial
- Complex logic must always be preceded by a comment/comments

## Error Handling

- Projects must define their own custom hierarchy of exceptions (They can also inherit from built-in exceptions if it makes sense)
- Prefer to use these custom exceptions in most cases
- Catch specific exceptions instead of blanket/generic ones
- It's alright to use built-in exceptions for specific errors (e.g. ValueError for invalid input, IndexError for out-of-bounds access, etc)

## Testing

- Pytest is the preferred testing framework
- Tests are always inside a tests/ directory placed at the same level as the source code being tested
- Every class/function must be tested, except for trivial/obvious ones (getters, setters, etc)


## Scientific/Numerical Computing

Prefer the following libraries
- Numpy, Jax
- Matplotlib, Plotly
- OpenCV
- Pytorch
