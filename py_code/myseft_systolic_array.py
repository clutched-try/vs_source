import numpy as np
import pandas as pd
import random as rd
import IPython.display 

def simulate_systolic_array(A, B, verbose=True, max_cycle=None):
    A = np.array(A)
    B = np.array(B)
    n = A.shape[0]
    assert A.shape == (n, n) and B.shape == (n, n)

    PEs = [[{'a': None, 'b': None, 'mult': None, 'acc': 0} for _ in range(n)] for _ in range(n)]
    snapshots = []
    
    if max_cycle is None:
        max_cycle = 4*n

    for t in range(max_cycle):

        #stage 0: accumulate
        for i in range(n):
            for j in range(n):
                pe = PEs[i][j]
                if pe['mult'] is not None:
                    pe['acc'] += pe['mult']
                pe['mult'] = None
        
        # --- stage 1: multiply ---
        next_mult = np.full((n, n), None)
        for i in range(n):
            for j in range(n):
                pe = PEs[i][j]
                if pe['a'] is not None and pe['b'] is not None:
                    next_mult[i][j] = pe['a'] * pe['b']
        
        # --- stage 2: propagate ---
        next_a = np.full((n, n), None)
        next_b = np.full((n, n), None)
        for i in range(n):
            for j in range(n):
                pe = PEs[i][j]
                if j+1 < n and pe['a'] is not None:
                    next_a[i][j+1] = pe['a']
                if i+1 < n and pe['b'] is not None:
                    next_b[i+1][j] = pe['b']

        # --- stage 3: inject a to right, b down ---
        for i in range(n):
            if 0 <= t - i < n:
                next_a[i][0] = A[i][t - i]
        for j in range(n):
            if 0 <= t - j < n:
                next_b[0][j] = B[t - j][j]

        # --- update to prepare for next clycle ---
        for i in range(n):
            for j in range(n):
                pe = PEs[i][j]
                pe['a'] = next_a[i][j]
                pe['b'] = next_b[i][j]
                pe['mult'] = next_mult[i][j]
        
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