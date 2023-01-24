# Eigenvalue Problem

Eigenvalues are very important in numerics. For example when solving Linear Systems of Equations, the eigenvalues of the matrix are used to determine the condition of the system.

For symmetric A, the kondition number is given by:
$$
\kappa(A) = \left|\frac{\lambda_{\max}(A)}{\lambda_{\min}(A)}\right|
$$

it measures the maximum ratio of the relative error accumulated in the computation.

## Symmetric Eigenvalue Problem

The symmetric eigenvalue problem is defined as:

$$
A\mathbf{x} = \lambda \mathbf{x}
$$

where $A$ is a symmetric matrix and $\mathbf{x}$ is a vector.
It is well-conditioned.

### Naive Algorithm

The Standard Algorithm for solving eigenvalue problems is the characteristic polynomial method:

$$
p(\lambda)=\det(A - \lambda I) = 0
$$

The roots of the polynomial are the eigenvalues of $A$.

This way of solving is ill-conditioned.

### Vector Iteration

#### Power Method

The power method is a simple iterative method for finding the largest eigenvector of a matrix $A$.

It works by calculating the matrix-vector product $A^k\mathbf{x}_0$ and normalizing the result.

The algorithm is as follows:

1. Initialize $\mathbf{x}_0$ to a random unit-vector
2. $\omega^{(k)} = Ax^{(k)}$
3. $x^{(k+1)} = \frac{\omega^{(k)}}{\| \omega^{(k)} \|}$ (normalize)
4. Repeat steps 2 and 3 until convergence

The korrisponding eigenvalue is given by:

$$
\lambda^{(k)} =(x^{(k)})^T A x^{(k)}
$$

This method requires $O(n^2)$ operations per iteration. The solution konvergess **linearly** (q=$\frac{\lambda_2}{\lambda_1}$) to the eigenvektor with the largest eigenvalue. The convergence of the eigenvalue is **quadratic**.

The Convergence rate can be improved by shifting the eigenvalues. This is done by calculating the eigenvalues of $A - \sigma I$ and shifting the eigenvalues by $\sigma$.

Ideally $\sigma \approx (\lambda_2 + \lambda_f)/2$. Where $\lambda_f$ is the eigenvalue furthest from $\lambda_2$.

#### Inverse Iteration

The inverse iteration is a simple iterative method for finding **specific** eigenvalue of a matrix $A$. Given a guess $\mu$.

Idea: Perform the power method on the $(A - \mu I)^{-1}$ matrix. After reshifting, this finds the closest eigenvector to $\mu$.

The algorithm is as follows:

1. Initialize $\mathbf{x}_0$ to a random unit-vector
2. Solve $(A - \mu I)\omega^{(k)} = x^{(k)}$
3. $x^{(k+1)} = \frac{\omega^{(k)}}{\| \omega^{(k)} \|}$ (normalize)
4. Repeat steps 2 and 3 until convergence
5. Calculate $\lambda^* = (x^{(k)})^T A x^{(k)} + \mu$

This method is dominated by the cost of solving the linear system. However: The matrix stays the same, so using LU decomposition or Cholesky decomposition the cost of solving the linear system can be reduced to $O(n^2)$.

It converges **linearly** to the eigenvektor with the eigenvalue closest to $\mu$. The convergence of the eigenvalue is **quadratic**.

#### Rayleigh Quotient Iteration

The Rayleigh Quotient Iteration is a simple iterative method for improving a guess for the eigenvalue of a matrix $A$.

Idea: Use the Rayleigh Quotient to compute a better guess for the eigenvalue. It uses the incresingly better approximation of the eigenvalue to improve the guess.

The algorithm is as follows:

1. Initialize $\mathbf{x}_0$ to a random unit-vector
2. $\mu^{(k)} = (x^{(k)})^T A x^{(k)}$
3. Solve $(A - \mu^{(k)} I)\omega^{(k)} = x^{(k)}$
4. $x^{(k+1)} = \frac{\omega^{(k)}}{\| \omega^{(k)} \|}$ (normalize)
5. Repeat steps 2 and 3 until convergence

This method converges **linearly** to the eigenvektor with the eigenvalue closest to $\mu$. But the convergence of the eigenvalue is now **qubically**.

However, the Matrix changes at every iteration, so the cost of solving the linear system is $O(n^3)$.

### QR Iteration

The QR Iteration is a simple iterative method for finding all eigenvalues of a matrix $A$.

Idea: Compute similar matrices $A_k$ wich converge to a diagonal matrix. The diagonal elements are the eigenvalues.

The algorithm is as follows:

1. Initialize $A_0 = A$
2. Calculate $A=QR$ with $Q$ orthogonal and $R$ upper triangular
3. $A_{k+1} = RQ$
4. Repeat steps 2 and 3 until convergence
5. The eigenvalues are the diagonal elements of $A_k$

#### QR Algorithm
