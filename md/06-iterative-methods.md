# Iterative Methods

## Introduction

Many Problems occuring in real life require solving a system of linear equations. However, in many cases, the system of equations is too large to be solved analytically (Gauss-Elimination: $\mathcal{O}(n^3)$). In this case, iterative methods are used to solve the system of equations numerically.
Most appearing matrices also have a specific shape (sparse, diagonal-dominant,...) which can be exploited to improve the performance of the methods.

## Terminology

The convergence of an iterative method is defined as the following:

$$
|x^{(i+1)} - \hat{x}| \leq c \cdot |x^{(i)} - \hat{x}|^\alpha
$$

If  $\alpha =1 \land 0< c < 1$ the method converges linearly.

If $\alpha = 2 \land 0< c < 1$ the method converges quadratically and so on.

There exist methods which don't converge globaly. That means that there exists a solution $x$ which is not found by the method. Such methods only converge if the starting guess $x^{(0)}$ is close enough to the solution.

All linear iterative methods converge globaly.

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

#### Richardson Iteration in Python

```python
def richardson(A, b, tol=1e-6, max_iter=1000):
    x = np.zeros_like(b)
    for i in range(max_iter):
        r = b - A @ x
        x = x + r
        if np.linalg.norm(r) < tol:
            break
    return x
```

### Jacobi Iteration

The Jacobi Iteration is an improvement of the Richardson Iteration. It uses the diagonal-dominant property of the matrix to improve the convergence speed.

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

#### Jacobi Iteration in Python

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
r^{(i)}_k&= b_k - \underbrace{\sum_{j=1}^{k-1} a_{kj} x^{(i)}_j}_{\text{Already updated x}} - \underbrace{\sum_{j=k}^{n} a_{kj} x^{(i)}_j}_{\text{Old x}} \\
y_k &= \frac{1}{a_{kk}} r_k^{(i)} \\
x^{(i+1)}_k &= x^{(i)}_k + y_k
\end{aligned}
$$

The update can also be written in Matrix Form:

$$
x^{(i+1)} = x^{(i)} + (D_A+L_A)^{-1} r^{(i)}
$$

where $D_A$ is the diagonal-row part of matrix A and $L_A$ is the lower-triangular part of matrix A.

#### Gauss-Seidel Iteration in Python

```python
def gauss_seidel(A, b, tol=1e-6, max_iter=1000):
    x = np.zeros_like(b)
    for i in range(max_iter):
        r = b - A @ x
        x = x + np.linalg.inv(np.tril(A)) @ r
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

### convergence of those Methods

- Due to construction of the methods, there only exists one possible
solution for $x$ if the iteration converges

- If the spectral radius of the iteration matrix is less than 1, the
  iteration converges

- If $A$ is positive-definite, the SOR method (and therefore the Gauss-Seidel method) converges

- If $A$ is strict diagonal dominant, the Jacobi and Gauss-Seidel methods converges

The smaller the spectral radius ($|\text{smallest eigenvalue}|$) of the iteration matrix, the faster the iteration converges.

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

#### Steepest Descent in Python

```python
def steepest_descent(A, b, tol=1e-6, max_iter=1000):
    x = np.zeros_like(b)
    r = b - A @ x
    for i in range(max_iter):
        alpha = (r.T @ r) / (r.T @ A @ r)
        x = x + alpha * r
        r = r - alpha*A @ r
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

#### Conjugate Direction in Python

```python
def conjugate_direction(A, b, tol=1e-6, max_iter=1000):
    x = np.zeros_like(b)
    r = b - A @ x
    d = r
    for i in range(max_iter):
        alpha = (r.T @ r) / (d.T @ A @ d)
        x = x + alpha * d
        r_new = r - alpha * A @ d
        beta = (r_new.T @ r_new) / (r.T @ r)
        d = r_new + beta * d
        r = r_new
        if np.linalg.norm(r) < tol:
            break
    return x
```

#### Discussion Conjugate Direction

- Is a direct solver: Korrekt solution after $n$ iterations

- The finer the Mesh, the slower the convergence

- Can be improved with a Precondition-Matrix
  - Solve $M^{-1} A x = M^{-1} b$ instead of $A x = b$

## Root finding of Nonlinear Systems of Equations

### Bisecting Method

If a function $f(x)$ is continuous and has a root in the interval $[a,b]$, then the root can be found by bisecting the interval.

Algorithm:

1. Choose $a$ and $b$ such that $f(a) \cdot f(b) < 0$
2. Choose $c = \frac{a+b}{2}$ and calculate $f(c)$
3. Determine the new interval, where the root is located. $[a,c]$ or $[c,b]$
4. Continue until $|f(c)| < \epsilon$

#### Bisecting Method in Python

```python
def bisect(f, a, b, tol=1e-6, max_iter=1000):
    for i in range(max_iter):
        c = (a + b) / 2
        if f(c) == 0 or (b - a) / 2 < tol:
            break
        if f(c) * f(a) < 0:
            b = c
        else:
            a = c
    return c
```

This method converges globaly-linearly. But its easy to compute.

### Regula Falsi Method

The Regula Falsi Method works similar to the Bisecting Method, but uses a different formula to calculate the midpoint.

The new midpoint is calculated by the intersection of the line between $(a,f(a))$ and $(b,f(b))$ and the $x$-axis.

#### Regula Falsi Method in Python

```python
def regula_falsi(f, a, b, tol=1e-6, max_iter=1000):
    for i in range(max_iter):
        c = (a * f(b) - b * f(a)) / (f(b) - f(a))
        if f(c) == 0 or (b - a) / 2 < tol:
            break
        if f(c) * f(a) < 0:
            b = c
        else:
            a = c
    return c
```

This method converges globaly-linearly. But its easy to compute.

### Secant Method

The Secant Method works by calculating the tangent of the function at the last two points and calculating the intersection with the $x$-axis.

Algorithm:

1. Choose $x_0$ and $x_1$ and calculate $f(x_0)$ and $f(x_1)$
2. Draw a line between $(x_0,f(x_0))$ and $(x_1,f(x_1))$. Let $x_2$ be the intersection with the $x$-axis.
3. Continue with $x_1$ and $x_2$ ...

#### Secant Method in Python

```python
def secant(f, x0, x1, tol=1e-6, max_iter=1000):
    for i in range(max_iter):
        x2 = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0))
        if f(x2) == 0 or abs(x2 - x1) < tol:
            break
        x0 = x1
        x1 = x2
    return x2
```

This method converges globaly-linearly. And locally with a rate of $1.618$.

### Newton-Raphson Method

The Newton-Raphson Method works by using the derivative of the function to calculate the next point.

Algorithm:

1. Choose $x_0$ and calculate $f(x_0)$ and $f'(x_0)$
2. Draw a line through $(x_0,f(x_0))$ with slope $f'(x_0)$. Let $x_1$ be the intersection with the $x$-axis.
3. Continue with $x_1$ and $f(x_1)$ and $f'(x_1)$ ...

#### Newton-Raphson Method in Python

```python
def newton_raphson(f, df, x0, tol=1e-6, max_iter=1000):
    for i in range(max_iter):
        x1 = x0 - f(x0) / df(x0)
        if f(x1) == 0 or abs(x1 - x0) < tol:
            break
        x0 = x1
    return x1
```

This method converges localy-quadraticly. But it requires the derivative of the function. So it requires two function evaluations per iteration.

## Multidimensional Root Finding

When dealing with multiple dimensions, the concept of a Derivative needs to be extended to a Jacobian Matrix.

### Jacobian Matrix

The Jacobian Matrix is a matrix of partial derivatives of a function.

$$
\begin{aligned}
f\left(\begin{bmatrix}x_1 \\ x_2 \end{bmatrix} \right) = \begin{bmatrix}f_1(x_1,x_2) \\ f_2(x_1,x_2) \end{bmatrix} = \begin{bmatrix}x^2y \\ 5x+\sin(y) \end{bmatrix} \\
\end{aligned}
$$

$$
\begin{aligned}
F'=J=\begin{bmatrix}
\frac{\partial f_1}{\partial x_1} & \frac{\partial f_1}{\partial x_2} \\
\frac{\partial f_2}{\partial x_1} & \frac{\partial f_2}{\partial x_2}
\end{bmatrix}
= \begin{bmatrix}
2xy & x^2 \\
5 & \cos(y)
\end{bmatrix}
\end{aligned}
$$

### Newton-Raphson Method for Multidimensional Systems

Analog to the 1D Newton-Raphson Method, the multidimensional Newton-Raphson Method works by using the Jacobian Matrix to calculate the next point.

In 1D, the next point was calculated by:
$$
x^{(i+1)} = x^{(i)} - \frac{f(x^{(i)})}{f'(x^{(i)})}
$$

In Higher Dimensions, the next point is calculated by:
$$
x^{(i+1)} = x^{(i)} - (F'(x^{(i)}))^{-1} \cdot F(x^{(i)})
$$

But inverting a matrix is computationally expensive. So the method uses LU-Decomposition to solve the equation.

Algorithm:

1. Choose $x_0$ and calculate $F(x_0)$ and $F'(x_0)$
2. Factorize $F'(x_0)=LU$.
3. Solve $Ly=-F(x_0)$ and $Us=y$.
4. Update $x_0$ with $x_0 + s$.

#### Newton-Raphson Method for Multidimensional Systems in Python

```python
def newton_raphson_multidim(f, J, x0, tol=1e-6, max_iter=1000):
    for i in range(max_iter):
        L, U, _ = scipy.linalg.lu(J(x0))
        y = scipy.linalg.solve_triangular(L, -f(x0), lower=True)
        s = scipy.linalg.solve_triangular(U, y)
        x0 = x0 + s
        if np.allclose(f(x0), 0, atol=tol):
            break
    return x0
```

This method converges localy-quadraticly. But it requires the Jacobian Matrix of the function.

It is very expensive as it needs to solve a linear system for each iteration.

### Improved Newton-Raphson Methods for Multidimensional Systems

1. Newton chords method
   - Idea: Reuse the Jacobian Matrix for several iterations.
2. inexact Newton method
   - Idea: Instead of solving the linear system exactly, solve it approximately. with a inner loop.
3. quasi-Newton method
   - Idea: Approximate $F'(x)$ and update it in each iteration.

## Multigrid Methods

Multigrid Methods are a class of iterative methods that are used to solve linear systems.

It is used to improve Relaxation Methods.

Our previous Relaxation Methods were pretty good at reducing high frequencies noise, but failed to reduce low frequencies noise efficiently.

Main Idea: Reduce high frequencies noise with a coarse grid and few iteration steps. The create a finder grid and use the coarse grid as a starting point. On this finer grid, the low-frequency noise from bevore becomes high-frequency noise. And can again be reduced with a few iteration steps.
Repeat this process until the desired accuracy is reached. And prolongate the solution up to the finer grids.

Algorithm:

Given:

- $A_f,A_c$ describing the linear system on the fine and coarse grid.
- $b_f,b_c$ describing the right hand side on the fine and coarse grid.

1. Create a coarse grid $\Omega_c$ and a finer grid $\Omega_f$. with width $h_c=2h_f$.
2. Smooth the solution $x_c$ on $\Omega_c$ with a few iteration steps.
3. Compute the residual $r_f=b_f-A_f x_c$.
4. Interpolate $r_f$ to $\Omega_c$.
5. Find $e_c$ such that $A_c e_c=r_c$.
6. prolongate $e_c$ to $\Omega_f$.
7. subtract $e_f$ from $x_f$. And repeat from step 2.
