# Ordinary Differential Equations

## Definition

A differential equation is an equation that relates one or more functions and their derivatives.
An example of a differential equation is $\dot{y}(t) = y(t)$

The difference between ordinary and partial differential equations is that ordinary differential equations only have one independent variable, while partial differential equations have more than one independent variable.

The Heat Equation is an example of a partial differential equation.

$$
u_t(x,t) = u_{xx}(x,t)
$$

Nearly all physical phenomena can be described by differential equations. But a differential equation does not specify a unique solution. There is a need for additional constraints to determine a unique solution.

Such constraints appear in:

- Initial conditions
- Boundary conditions

## Initial Conditions

Initial conditions describe the state of the system at the beginning of the simulation. For example:

$$
\begin{aligned}
y(0) &= 1 \\
\dot{y}(0) &= 0
\end{aligned}
$$

## Boundary Conditions

Boundary conditions describe the state of the system at the boundary of the simulation. For example:

$$
\begin{aligned}
y(0) &= 1 \\
y(1) &= 0
\end{aligned}
$$

## Analytical Solution

In simple cases, a differential equation can be solved analytically. This means that the solution can be expressed in terms of elementary functions. This is not always possible.

## Lipschitz Condition

The Lipschitz condition is a necessary condition for the existence of a unique solution to a differential equation. It states that the derivative of the solution must be bounded.

$$
\left| \frac{dy}{dt} \right| \leq L
$$

## Condition of Differential Equations

In general differential equations are ill conditioned. This means that small changes in the input can lead to large changes in the output. This is a problem for numerical methods.

## Differential Equations as Integration Problems

A differential equation can be seen as an integration problem. The solution of the differential equation is the integral of the right hand side of the equation.

$$
y(t+\delta t) = y(t) + \int_{t}^{t+\delta t} \dot{y}(t) dt
$$

## Numerical Solutions

Let $\dot{y}(t) = f(t,y(t))$ be a differential equation. With $t \in [a,b]$ and $y(a) = y_a$.

### Finite Difference Method / Euler Method

The finite difference method is a numerical method for solving differential equations. It is based on the Taylor expansion of the solution.

The derivative of the solution is approximated by a finite difference.

$$
\frac{dy}{dt} \approx \frac{y(t + \delta t) - y(t)}{\delta t}
$$

This yields to the following approximation of the solution:

$$
\begin{aligned}
y(a+ \delta t) &\approx y(a) + \delta t \cdot f(a,y(a)) \\
y_{k+1} &\approx y_k + \delta t \cdot f(t_k,y_k)\\
\end{aligned}
$$

The Euler method corrisponds with the rectangular rule for numerical integration.

The Error of the Euler method is:

- $l_{\delta t} = \mathcal{O}(\delta t)$
- $e_{\delta t} = \mathcal{O}(\delta t)$

#### Euler Method in Python

```python
def euler(f, t0, y0, dt, n):
    t = t0
    y = y0

    for i in range(n):
        y = y + dt*f(t,y)
        t = t + dt
    return y
```

### Method of Heun

The method of Heun uses two steps of the Euler method to improve the accuracy of the solution.

$$
y_{k+1} \approx y_k + \frac{\delta t}{2} \cdot (f(t_k,y_k) + f(t_{k+1},y_k + \delta t \cdot f(t_k,y_k) )) \\
$$

The method of Heun corrisponds with the trapezoidal rule for numerical integration.

The Error of the method of Heun is:

- $l_{\delta t} = \mathcal{O}((\delta t)^2)$
- $e_{\delta t} = \mathcal{O}((\delta t)^2)$

#### Method of Heun in Python

```python
def heun(f, t0, y0, dt, n):
    t = t0
    y = y0

    for i in range(n):
        y = y + dt/2*(f(t,y) + f(t+dt, y+dt*f(t,y)))
        t = t + dt
    return y
```

### Runge-Kutta Method

The Runge-Kutta method is a generalization of the Euler method. It uses multiple steps of the Euler method to improve the accuracy of the solution.

$$
y_{k+1} \approx y_k + \frac{\delta t}{6} \cdot (T_1 + 2 \cdot T_2 + 2 \cdot T_3 + T_4)
$$

where
$$
\begin{aligned}
T_1 &= f(t_k,y_k) \\
T_2 &= f(t_k + \frac{\delta t}{2}, y_k + \frac{\delta t}{2} \cdot T_1) \\
T_3 &= f(t_k + \frac{\delta t}{2}, y_k + \frac{\delta t}{2} \cdot T_2) \\
T_4 &= f(t_k + \delta t, y_k + \delta t \cdot T_3) \\
\end{aligned}
$$

The Runge-Kutta method corrisponds with the Kepler rule for numerical integration.

The Error of the Runge-Kutta method is:

- $l_{\delta t} = \mathcal{O}((\delta t)^4)$
- $e_{\delta t} = \mathcal{O}((\delta t)^4)$

#### Runge-Kutta Method in Python

```python
def rungeKutta(f, t0, y0, dt, n):
    t = t0
    y = y0

    for i in range(n):
        T1 = f(t,y)
        T2 = f(t+dt/2, y+dt/2*T1)
        T3 = f(t+dt/2, y+dt/2*T2)
        T4 = f(t+dt, y+dt*T3)

        y = y + dt/6*(T1 + 2*T2 + 2*T3 + T4)
        t = t + dt
    return y
```

## Consistency and Convergence

- Local Discretization Error:
  - This is the error which happens in a single step of the numerical method, if we suppose that the starting conditions are known exactly.
- Global Discretization Error:
  - This is the error which accumulates ver the whole simulation, if we suppose that the starting conditions are known exactly.

### Local Discretization Error

The local discretization error is the maximum error which arrises from a single step of the numerical method.

$$
l_{\delta t} = \max_{t \in [a,b]} \left| \frac{y(t+\delta t) - y(t)}{\delta t} - \dot{y}(t) \right|
$$

If $\lim_{\delta t \to 0} l_{\delta t} = 0$ then the method is called consistent.

### Global Discretization Error

The global discretization error is the maximum error between the numerical solution and the exact solution.

$$
e_{\delta t} = \max_{k=0,\ldots,N} \left| y_k - y(t_k) \right|
$$

If $\lim_{\delta t \to 0} e_{\delta t} = 0$ then the method is called convergent. This means that increasing the number of steps leads to a better approximation of the solution.

## Multistep Methods

Multistep methods are numerical methods for solving differential equations. They use the solution of the previous steps to improve the accuracy of the solution.

### Adams-Bashforth Method

The Adams-Bashforth method works by replacing $f$ with a polynomial approximation of $f$. This polynomial is then integrated exactly.

$$
y_{k+1} \approx y_k + \frac{\delta t}{2} \cdot (3 \cdot f(t_k,y_k) - f(t_{k-1},y_{k-1}))
$$
