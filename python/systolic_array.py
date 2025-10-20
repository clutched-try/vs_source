#no pinline
import numpy as np
import pandas as pd
import random as rd
import IPython.display

def simulate_systolic_array(A, B, verbose=True, max_cycle=None):
    A = np.array(A)
    B = np.array(B)
    n = A.shape[0]

    assert A.shape == (n, n) and B.shape == (n, n)

    PEs = np.full((n, n),{'a': None, 'b': None, 'mult': None, 'acc': 0})
    snapshots = []
    if(max_cycle is None):
        max_cycle = n*2+2
    for t in range(max_cycle):

        # --- inject a, b to PEs ---
        next_a = np.full((n, n), None)
        next_b = np.full((n,n), None)
        for k in range(n):
            if k <= t and t - k < n:
                next_a[k][0] = A[t-k][k]
                next_b[0][k] = B[k][t-k]
        
        # --- multilply ----
        for i in range(n):
            for j in range(n):
                a = PEs[i][j]['a']
                b = PEs[i][j]['b']
                if a is not None and b is not None:
                    PEs[i][j]['mult'] = a * b
        
        # --- accummulate ---
        for i in range(n):
            for j in range(n):
                pe = PEs[i][j]
                if pe ['mult'] is not None:
                    pe['acc'] += pe['mult']
                pe['mult'] = None
        
        # --- propagate ---
        for k in range(n):
            if t== k:
                for i in range(n):
                    pe = PEs[i][k]
                    if pe['a'] is not None and i-1 < n:
                        next_a[i-1][k] = pe['a']

        for k in range(n):
            if t== k:
                for j in range(n):
                    pe = PEs[k][j]
                    if pe['b'] is not None and j-1 < n:
                        next_b[k][j-1] = pe['b']                    

        # --- update ----
        for i in range(n):
            for j in range(n):
                pe = PEs[i][j]
                pe['a'] = next_a[i][j]
                pe['b'] = next_b[i][j]
        
        snapshots.append([
            [f"a={PEs[i][j]['a']!s}, b={PEs[i][j]['b']!s},mult={PEs[i][j]['mult']} ,acc={PEs[i][j]['acc']}"
             for j in range(n)] for i in range(n)
        ])

        # --- Termination ---
        any_data = any(PEs[i][j]['a'] is not None or PEs[i][j]['b'] is not None
                       for i in range(n) for j in range(n))
        any_mult = any(PEs[i][j]['mult'] is not None
                       for i in range(n) for j in range(n))
        pending_inj = t < 2 * n - 2
        if not (any_data or any_mult or pending_inj) and t > 0:
            print(f"Finish at {t+1}th cycle")
            break

    C = np.array([[PEs[i][j]['acc'] for j in range(n)] for i in range(n)])

    if verbose:
        print("=== TRACE SYSTOLIC ARRAY ===")
        for t, grid in enumerate(snapshots):
            print(f"\nCycle {t}:")
            for row in grid:
                print("  " + " | ".join(row))
            print("-"*60)

    return C

n = 4
A = np.random.randint(0, 16, (n, n))
B = np.random.randint(0, 16, (n, n))
C = simulate_systolic_array(A, B)
print("C (systolic):\n", C)
print("C (numpy.dot):\n", np.dot(A, B))
        