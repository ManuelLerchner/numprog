# Iterative Methods

## Introduction

Many Problems occuring in real life require solving a system of linear equations. However, in many cases, the system of equations is too large to be solved analytically (Gauss-Elimination: $\mathcal{O}(n^3)$). In this case, iterative methods are used to solve the system of equations numerically.
Most appeaing matrices also have a specific shape (sparse, diagonal-domintant,...) which can be exploited to improve the performance of the methods.

## Relaxation Methods

Relaxation methods are iterative methods for solving linear systems of equations. They use the residual to improve the solution.

$$
r^{(i)} = b - A x^{(i)} = -A e^{(i)}
$$

Where $r^{(i)}$ is the residual at Iteration-Step $i$, $b$ is the right hand side of the equation, and $x^{(i)}$ is the approximation of the solution at Iteration-Step $i$.

### Richardson Iteration

The Richardson Iteration is the easiest way of updating the guessed solution. It works by just adding the Residual each step.

$$
x^ {(i+1)} = x^{(i)} + r^{(i)}
$$

The Update can also be written in Matrix form:

$$
x^ {(i+1)} = x^{(i)} + I r^{(i)}
$$

```python
def richardson(A, b tol=1e-6, max_iter=1000):
    x = np.zeros_like(b)
    for i in range(max_iter):
        r = b - A @ x
        x = x + r
        if np.linalg.norm(r) < tol:
            break
    return x
```

### Jacobi Iteration

The Jacobi Iteration is an improvement of the Richardson Iteration. It uses the diagonal-domintant property of the matrix to improve the konvergence speed.

If you use a for-loop based implementation, in order to not overwrite the values of the previous iteration, the update-vector needs to be precomputed. This needs to be done, becausethe residual $r=b-Ax^{(i)}$ changes with every step.

$$
\begin{aligned}
y_k &= \frac{1}{a_{kk}} r_k^{(i)} \\
x^{(i+1)}_k &= x^{(i)}_k + y_k
\end{aligned}
$$

The Update can also be written in Matrix Form:

$$
x^{(i+1)} = x^{(i)} + D^{-1} r^{(i)}
$$

where $D$ is the diagonal-row part of matrix A.

```python
def jacobi(A, b, tol=1e-6, max_iter=1000):
    x = np.zeros_like(b)
    for i in range(max_iter):
        r = b - A @ x
        x = x + np.diag(1 / np.diag(A)) @ r
        if np.linalg.norm(r) < tol:
            break
    return x
```

### Gauss-Seidel Iteration

The Gauss-Seidel Iteration is an improvement of the Jacobi Iteration. It uses doesnt use a `freezed` residual during each update step. Instead it
recalculates the residual after each improvement and uses the improved residual for future steps.

$$
\begin{aligned}
r^{(i)}_k&= b_k - \sum_{j=1}^{k-1} a_{kj} x^{(i)}_j - \sum_{j=k}^{n} a_{kj} x^{(i)}_j \\
y_k &= \frac{1}{a_{kk}} r_k^{(i)} \\
x^{(i+1)}_k &= x^{(i)}_k + y_k
\end{aligned}
$$

The update can also be written in Matrix Form:

$$
x^{(i+1)} = x^{(i)} + (D_A+L_A)^{-1} r^{(i)}
$$

where $D_A$ is the diagonal-row part of matrix A and $L_A$ is the lower-triangular part of matrix A.

```python
def gauss_seidel(A, b, tol=1e-6, max_iter=1000):
    x = np.zeros_like(b)
    for i in range(max_iter):
        for k in range(len(b)):
            r = b[k] - A[k, :k] @ x[:k] - A[k, k + 1 :] @ x[k + 1 :]
            y = r / A[k, k]
            x[k] = x[k] + y
        if np.linalg.norm(r) < tol:
            break
    return x
```

In all of the Methods above a damping-factor $0< \alpha < 2$ can be used to improve the convergence speed. $x^{(i+1)} = x^{(i)} + \alpha y$.

### SOR Iteration

The SOR Iteration is an improvement of the Gauss-Seidel Iteration. It uses a damping-factor $\alpha$ to improve the convergence speed.

$$
x^{(i+1)} = x^{(i)} + \alpha (D_A+L_A)^{-1} r^{(i)}
$$

### Konvergence of those Methods

- Due to construction of the methods, there only exists one possible
solution for $x$ if the iteration konverges

- If the spectral radius of the iteration matrix is less than 1, the
  iteration konverges

- If $A$ is positive-definite, the SOR method (and therefore the Gauss-Seidel method) konverges

- If $A$ is strict diagonal dominant, the Jacobi and Gauss-Seidel methods konverges

The smaller the spectral radius ($|\text{smallest eigenvalue}|$) of the iteration matrix, the faster the iteration konverges.

In generall, the finer the mesh, the bigger the spectral radius. This is bad for big simulations.

## Minimization Methods

Linear systems of equations can also be solved by minimizing a function.

For example:

$$
\begin{aligned}
f(x)&=\frac{1}{2}x^TAx-b^Tx \\
f'(x)&=Ax-b = -r(x) \\
\implies f'(x)&=0 \iff A x = b
\end{aligned}
$$

### Method of Steepest Descent

The Method of Steepest Descent is an iterative method for minimizing a function. It works by taking the steepest descent of the function at each step.

$$
\begin{aligned}
r^{(0)}&=b-Ax^{(0)} \\
\alpha_i  &= \frac{r^{(i)^T} r^{(i)}}{r^{(i)^T}Ar^{(i)}} \\
x^{(i+1)} &= x^{(i)} - \alpha_i A r^{(i)}
\end{aligned}
$$

```python
def steepest_descent(A, b, tol=1e-6, max_iter=1000):
    x = np.zeros_like(b)
    r = b - A @ x
    for i in range(max_iter):
        alpha = r.T @ r / (r.T @ A @ r)
        x = x - alpha * A @ r
        r = b - A @ x
        if np.linalg.norm(r) < tol:
            break
    return x
```

#### Discussion Steepest Descent

- The convergence can take arbitrary long. For Example $A=I$ and $b=0$.

### Conjugate Direction Method

The Conjugate Direction Method is an iterative method for minimizing a function. It works by taking a step in the correct direction at each step. (The error in the $i+1$-step is orthogonal to all the errors in the previous steps.)

$$
\begin{aligned}
d^{(0)} &=b-Ax^{(0)} \\
\beta_i &= \frac{r^{(i+1)^T} r^{(i+1)}}{r^{(i)^T} r^{(i)}} \\
\alpha_i  &= \frac{r^{(i)^T} r^{(i)}}{r^{(i)^T}Ar^{(i)}} \\
d^{(i+1)} &= r^{(i+1)} + \beta_i d^{(i)}\\
x^{(i+1)} &= x^{(i)} - \alpha_i A d^{(i)} \\
r^{(i+1)} &= r^{(i)} - \alpha_i A d^{(i)} \\
\end{aligned}
$$

```python
def conjugate_direction(A, b, tol=1e-6, max_iter=1000):
    x = np.zeros_like(b)
    r = b - A @ x
    d = r
    for i in range(max_iter):
        alpha = r.T @ r / (r.T @ A @ r)
        x = x - alpha * A @ d
        r = b - A @ x
        beta = r.T @ r / (r.T @ A @ r)
        d = r + beta * d
        if np.linalg.norm(r) < tol:
            break
    return x
```

#### Discussion Conjugate Direction

- Is a direct solver: Korrekt solution after $n$ iterations

- The finer the Mesh, the slower the convergence

- Can be improved with a Precondition-Matrix
  - Solve $M^{-1} A x = M^{-1} b$ instead of $A x = b$
