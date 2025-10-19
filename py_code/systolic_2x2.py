import numpy as  np
import pandas as pd
from IPython.display import display

def simulate_systolic_2x2(A, B):
    A = np.array(A)
    B = np.array(B)
    assert A.shape == (2, 2) and B.shape == (2, 2)

    PEs = [[{'a': None, 'b' : None, 'mult' : 0, 'acc' : 0} for _ in range(2)] for _ in range(2)]

    max_cycle = 6
    trace = []

    valid_prop = np.full([2, 2], False, dtype=bool)
    for t in range(max_cycle):
        left_input = np.full(2, None)
        top_input = np.full(2, None)
        for i in range(2):
            for k in range(2):
                if(t == i):
                    left_input[k] = A[k][i]
        
        for j in range(2):
            for k in range(2):
                if(t == j):
                    top_input[k] = B[j][k]

        for i in range(2):
            for j in range(2):
                PEs[i][j]['b'] = top_input[j]

        for j in range(2):
            for i in range(2):
                PEs[i][j]['a'] = left_input[i]
        
        #stage 1: acc
        for j in range(2):
            for i in range(2):
                if(valid_prop[i][j]):
                    valid_prop[i][j] = False
                    pe = PEs[i][j]
                    pe['acc'] =  pe['acc'] + pe['mult']

        #stage 0: mult
        for j in range(2):
            for i in range(2):
                pe = PEs[i][j]
                if pe['a'] is not None and pe['b'] is not None:
                    pe['mult'] =  pe['a'] * pe['b']
                    valid_prop[i][j] = True
        
        snapshot = {
            'cycle': t,
            'PEs': [[(PEs[i][j]['a'], PEs[i][j]['b'], PEs[i][j]['mult'], PEs[i][j]['acc']) for j in range(2)] for i in range(2)]
        }
        trace.append(snapshot)

        # termination check
        any_data_flowing = any(PEs[i][j]['a'] is not None or PEs[i][j]['b'] is not None for i in range(2) for j in range(2))
        # injections pending if t < max(k+i) or t < max(k+j); for 2x2 max injection time = 1+1=2
        pending_injections = t < 2
        if not any_data_flowing and not pending_injections and t>0:
            print(f"Finish at {t+1}th cycle")
            break
        #Cần kiểm tra xem dữ liệu đã chảy hết hay chưa

    C = np.zeros((2,2), dtype=int)
    for i in range(2):
        for j in range(2):
            C[i,j] = PEs[i][j]['acc']
    return trace, C

A = [[1,2],[3,4]]
B = [[5,6],[7,8]]
trace, C = simulate_systolic_2x2(A, B)

for snap in trace:
    t = snap['cycle']
    print(f"Cycle {t}:")
    for i in range(2):
        row_str = []
        for j in range(2):
            a, b, mult, acc = snap['PEs'][i][j]
            row_str.append(f"PE[{i},{j}] a={a!s}, b={b!s}, mult={mult}, acc={acc}")
        print("  " + " | ".join(row_str))
    print("-"*60)

print("Final C from systolic array:")
print(C)
print("Expected numpy.dot:")
print(np.dot(np.array(A), np.array(B)))

df = pd.DataFrame(C, index=["row0","row1"], columns=["col0","col1"])
display(df)