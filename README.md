# Eiffel_FLAT_RENDERER
Strategies for debugging  Data structures in Eiffel 

## Introduction

This small project is an attempt to solve the problem
posed in the Eiffel users forum (see thread Renderers, a small community project
by Bertrand Meyer).
The problem consists in printing the elements of general data structures in a suitable
format. Such printing algorithm could then be used for debugging purposes.

This project is only a prototype, created with the sole purpose of
gaining a better understanding of the problem and playing with different strategies for
its solution.

Another solution strategy is being worked on by Larry Rix and can be found
at (https://github.com/ljr1981/iterable_output/).

## Methodology

The solution proposed in FLAT_RENDERER consist in traversing
the data structure recursively trhough its, possibly many, nesting
levels following a depth-first search algorithm. The algorithm
prints the value of a given element in the data structure if
this element is one of INTEGER, STRING, REAL or DOUBLE data types and
proceeds recursively otherwise.

## Output formats
Currently only Comma Separated Values (CSV) format is implemented.

## Examples

## Aknowledgements
 All friends from Eiffel Users forum
 
