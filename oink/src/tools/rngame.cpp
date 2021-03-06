/*
 * Copyright 2017-2018 Tom van Dijk, Johannes Kepler University Linz
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// A modification by Paweł Parys: random numbers seed read from command line

#include <iostream>
#include <random>

using namespace std;

static random_device rand_dev;
static mt19937 generator(rand_dev());

int
rng(int low, int high)
{
    return uniform_int_distribution<int>(low, high)(generator);
}

int
main(int argc, char** argv)
{
    if (argc != 5 && argc != 6) {
        cout << "Syntax: " << argv[0] << " nNodes maxPrio minDeg maxDeg [seed]" << endl;
        cout.flush();
        return -1;
    }

    // parse arguments
    int n = stoi(argv[1]);
    int maxP = stoi(argv[2]);
    int minD = stoi(argv[3]);
    int maxD = stoi(argv[4]);
    int SL = 0; // changed by PP, previously it was a command-line argument

    if (argc == 6)
        generator.seed(stoi(argv[5])); // added by PP

    // check bad arguments
    if (maxD > n) {
        cout << "max degree >= num nodes?!" << endl;
        cout.flush();
        return -1;
    }
    if (minD > maxD) {
        cout << "min degree >= max degree?!" << endl;
        cout.flush();
        return -1;
    }
    if (maxD == n && SL == 0) {
        maxD--; // just fix the number
    }

    // allocate edge target array
    int *tgt = new int[n];

    // generate game
    cout << "parity " << n << ";" << endl;
    for (int i=0; i<n; i++) {
        // generate priority and owner
        cout << i << " " << rng(0, maxP) << " " << rng(0, 1) << " ";
        // determine number of edges
        int e_count = rng(minD, maxD);
        // initialize edge target array
        for (int j=0; j<n; j++) tgt[j] = j;
        // initialize size of array
        int m = n;
        // maybe remove the self-loop
        if (SL == 0) {
            tgt[i] = n-1;
            m--;
        }
        // generate random edges
        for (int j=0; j<e_count; j++) {
            int x = rng(0, m-1);
            if (j != 0) cout << ",";
            cout << tgt[x];
            tgt[x] = tgt[m-1];
            m--;
        }
        // generate no label
        cout << ";" << endl;
    }

    // free edge target array
    delete[] tgt;

    return 0;
}
