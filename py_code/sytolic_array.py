import numpy as np

def systolic_array(A, B, verbose=True, max_cycle=None):
    A = np.array(A)
    B = np.array(B)
    n = A.shape[0]
    assert A.shape == (n, n) and B.shape == (n, n), "Chỉ hỗ trợ ma trận vuông NxN"

    PEs = [[{'a': None, 'b': None, 'mult_reg': None, 'acc': 0}
            for _ in range(n)] for _ in range(n)]

    if max_cycle is None:
        max_cycle = 4 * n

    snapshots = []

    for t in range(max_cycle):
        # --- Stage 1: accumulate ---
        for i in range(n):
            for j in range(n):
                pe = PEs[i][j]
                if pe['mult_reg'] is not None:
                    pe['acc'] += pe['mult_reg']
                pe['mult_reg'] = None

        # --- Stage 2: multiply ---
        next_mult = [[None]*n for _ in range(n)]
        for i in range(n):
            for j in range(n):
                a, b = PEs[i][j]['a'], PEs[i][j]['b']
                if a is not None and b is not None:
                    next_mult[i][j] = a * b

        # --- Stage 3: propagate ---
        next_a = [[None]*n for _ in range(n)]
        next_b = [[None]*n for _ in range(n)]
        for i in range(n):
            for j in range(n):
                a, b = PEs[i][j]['a'], PEs[i][j]['b']
                if a is not None and j + 1 < n:
                    next_a[i][j + 1] = a
                if b is not None and i + 1 < n:
                    next_b[i + 1][j] = b

        # --- Stage4:
        # --- Stage 4.1: inject dữ liệu có trễ ---
        for i in range(n):
            if t - i >= 0 and t - i < n:
                next_a[i][0] = A[i, t - i]
        for j in range(n):
            if t - j >= 0 and t - j < n:
                next_b[0][j] = B[t - j, j]

        # --- Stage 4.2: update ---
        for i in range(n):
            for j in range(n):
                PEs[i][j]['a'] = next_a[i][j]
                PEs[i][j]['b'] = next_b[i][j]
                PEs[i][j]['mult_reg'] = next_mult[i][j]

        # --- Trace ---
        snapshots.append([
            [f"a={PEs[i][j]['a']!s}, b={PEs[i][j]['b']!s},mult={PEs[i][j]['mult_reg']} ,acc={PEs[i][j]['acc']}"
             for j in range(n)] for i in range(n)
        ])

        # --- Termination ---
        any_data = any(PEs[i][j]['a'] is not None or PEs[i][j]['b'] is not None
                       for i in range(n) for j in range(n))
        any_mult = any(PEs[i][j]['mult_reg'] is not None
                       for i in range(n) for j in range(n))
        pending_inj = t < 2 * n
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


# ---- Test ----
n = 4
A = np.random.randint(0, 16, (n, n))
B = np.random.randint(0, 16, (n, n))
C = systolic_array(A, B, verbose=True)
print("C (systolic):\n", C)
print("C (numpy.dot):\n", np.dot(A, B))
