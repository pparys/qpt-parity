
This is an implementation of algorithms from the paper "A recursive approach to solving parity games in quasipolynomial time" by K. Lehtinen, P. Parys, S. Schewe, D. Wojtczak.

The implementation is based on "oink" by Tom van Dijk, https://github.com/trolando/oink (version of 1.07.2020)

Our algorithms are implemented in the file "oink/src/zlkpp.cpp".
They can be executed using the following options to oink:
--zlkpp-std (our implementation of the standard Zielonka's algorithm)
--zlkpp-waw (the Warsaw quasipolynomial variant)
--zlkpp-liv (the Liverpool quasipolynomial variant)

Additionally, generators of random games, "rngame" and "stgame" are modified so that they take the random seed as an argument.

HOW TO RUN:

compilation: 
cd oink && mkdir -p build && cd build && cmake .. -D BUILD_EXTRA_TOOLS=1 && make

generate.sh - creates tests used in the paper (in the "tests" folder)
generate-other.sh - creates some other tests (in the "tests" folder)
run.sh - runs our three implementations on files in the "tests" folder (includes a check for correctness of solutions)

Files results.txt and results-other.txt contain our running times on tests generated this way.
