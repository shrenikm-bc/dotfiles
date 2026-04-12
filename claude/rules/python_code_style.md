# Python Code Style

## Virtual Environment

- Conda is preferred
- Assume that each python project will have its own conda environment with the dependencies in the pyproject file

## Formatting

- Ruff is preferred
- Each project will ideally define the ruff config in the pyproject file

## Style Guide

- Follow the regular PEP 8 style guide
- Prefer to use attrs for decorating classes (over @dataclass, etc)
- Use frozen attrs classes wherever possible
- Try to minimize state mutation and function side-effects as much as possible

## Type Hints

- Type hints are necessary in almost every circumstance
- May be skipped for trivial inner functions, etc.

## Documentation

### Docstrings

- Can be skipped for trivial functions (getters, setters, etc) and for simple/obvious functions
- Must follow the """\n docstring \n""" convention. They must never be on one line, even for short descriptions
- Don't add function param and result docstrings. Function and argument names along with the type hints must be sufficient

### Comments

- Avoid comments that are obvious or trivial
- Complex logic must always be preceded by a comment/comments

## Error Handling

- Projects must define their own custom hierarchy of exceptions (They can also inherit from built-in exceptions if it makes sense)
- Prefer to use these custom exceptions in most cases
- It's alright to use built-in exceptions for specific errors (e.g. ValueError for invalid input, IndexError for out-of-bounds access, etc)

## Testing

- Pytest is the preferred testing framework
- Tests are always inside a tests/ directory placed at the same level as the source code being tested


## Scientific/Numerical Computing

Prefer the following libraries
- Numpy, Jax
- Matplotlib, Plotly
- OpenCV
- Pytorch
