# Orbit Closures of Polynomial Loops

A prototype implementation of new algorithms for computing the ideal of the orbit closure of a polynomial loop when either:

- the dimension of the orbit closure is known; or
- the generators of one of its maximal components are known.

The algorithms are presented in:

> **The Structure of Orbit Closures of Polynomial Loops**

## Repository Structure

The software directory contains an ongoing implementation of Algorithms 1 and 2 in [Macaulay2](https://macaulay2.com/).

It includes:

- the source code for the algorithms;
- a loop directory containing polynomial-loop examples, such as `ex2.m2`.

## Usage

Run the following commands from the `software` directory.

### Computing an Orbit Closure from Its Dimension

When the dimension of the orbit closure is known, run:

```bash
M2 main.m2 -e 'OrbitClosures("loops/<loop-name>.m2", <dimension>)'
```

For example:

```bash
M2 main.m2 -e 'OrbitClosures("loops/ex2.m2", 2)'
```

Alternatively, start Macaulay2 in the `software` directory and run:

```macaulay2
load "main.m2"
OrbitClosures("loops/<loop-name>.m2", <dimension>)
```

The output consists of two entries:

1. the number of isolated points;
2. the maximal components of the orbit closure.

### Computing an Orbit Closure from a Maximal Component

When the generators of a maximal component are known, run:

```macaulay2
load "main.m2"
InvariantVarietyIrr("loops/<loop-name>.m2",<generators-of-maximal-component>)
```

The output consists of two entries:

1. the number of isolated points;
2. the maximal components of the orbit closure.
