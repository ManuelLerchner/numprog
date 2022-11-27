# Polynom-Interpolation

## Problem

Given a potentially complicated function $f(x)$, find a function $p(x)$ that is ease to construct and handle. $p(x)$ needs to approximates $f(x)$ and should have a _small_ error.

Der resultierende Fehler ist ein Maß für die Qualität der Approximation. Dieser wird als _Fehlerterm_ bzw. _Remainder_ bezeichnet.

$$
f(x)-p(x) = \frac{D^{(n+1)}f(\xi)}{(n+1)!} \prod_{i=0}^{n} (x-x_i)
$$

Wobei $\xi$ ein Punkt zwischen $x_0$ und $x_n$ ist.

### Lagrange Polynomials

Bei der Lagrange Interpolation werden Basisfunktionen verwendet, welche jeweils an allen Stützstellen, bis auf der Stelle $x_i$, den Wert $0$ annehmen.

$$
L_k(x) = \prod_{i=0, i \neq k}^{n} \frac{x-x_i}{x_k-x_i}
$$

Das Resultierende Polynom ergibt sich dann als:

$$
p(x) = \sum_{i=0}^{n} y_i\cdot L_i(x)
$$

### Chebyshev Polynomials

Die Basisfunktionen für die Interpolation sind die Chebyshev Polynome. Diese sind definiert als:

$$
\begin{aligned}
T_0(x) &= 1 \\
T_1(x) &= x \\
T_{k+1}(x) &= 2x\cdot T_k(x) - T_{k-1}(x)\\
\end{aligned}
$$

Damit lassen sich die dazu gehörigen Koeffizienten berechnen:

$$
\begin{aligned}
a_0 &= \frac{1}{2\pi}\int_{-1}^1 \frac{f(x)}{\sqrt{1-x^2}} dx \\
a_k &= \frac{2}{\pi}\int_{-1}^1 \frac{f(x)\cdot T_k(x)}{\sqrt{1-x^2}} dx \\
\end{aligned}
$$

Die Interpolation ist dann gegeben durch:

$$
p(x) = \sum_{k=0}^n a_k T_k(x)
$$

### Bernstein Polynomials

Mithilfe der Bersntein Polynome lässt sich die Interpolation durch Bezier Kurven realisieren. Diese sind definiert als:

$$
B_i^n= \binom{n}{i} (1-t)^{n-i} \cdot t^i
$$

Die Interpolation ist dann gegeben durch:

$$
p(t) = \sum_{i=0}^n b_i B_i^n(t)
$$

Hierbei stellen $b_i$ die Kontrollpunkte dar. (Diese können auch höherdimensional sein)

## Variationen der Problemstellung

Es gibt zwei verschidenen Anwendungen der Interpolation welche auftreten können:

1. Simple Nodes

   - Man hat eine Menge von Punkten $P = \{(x_0, y_0), (x_1, y_1), \dots, (x_n, y_n)\}$, welche durch ein Polynom interpoliert werden sollen.
   - Diese Variante wird auch als _Lagrange Interpolation_ bezeichnet.

2. Multiple Nodes
   - Man hat heine Menge von Knoten $P = \{(x_0, y_0, y_0'), (x_1, y_1, y_1'), \dots, (x_n, y_n, y_n')\}$ welche durch ein Polynom interpoliert werden sollen.
   - Hierbei ist $y_i'$ die Ableitung von $y_i$.
   - Diese Variante wird als _Hermit Interpolation_ bezeichnet.

## Algorithmen

### Schema von Aitken und Neville

Wenn man nicht an der expliziten Representation des Interpolationspolynoms interessiert ist, sonder nur den Funktionswert an einem festen $x$ Wert bestimmen möchte eignet sich das Schema von Aitken und Neville.

Algorithmus:

1. Initialisiere konstante Polynome welche den Funktionswert an den Stützstellen annehmen.
   - $p_{0,0} = y_0, p_{1,0} = y_1, \dots, p_{n,0} = y_n$
2. Verfeinere rekursiv die Polynome durch die Kombibation mehrerer Polynome.
   - $p_{i,j} = \frac{x_{i+k}-x}{x_{i+k}-x_{i}} \cdot p_{i,k-1}(x) + \frac{x-x_{i}}{x_{i+k}-x_{i}} \cdot p_{i+1,k-1}(x)$

Als Psuedo Code:

```python
def neville(x, x_values, y_values):
    n = len(x_values)

    p = np.zeros((n, n))
    p[:, 0] = y_values

    for k in range(1, n):
        for i in range(n - k):
            p[i, k] =   (x[i + k] - x) / (x[i + k] - x[i]) * p[i, k - 1] +
                        (x - x[i])     / (x[i + k] - x[i]) * p[i + 1, k - 1]
    return p[0, n - 1]
```

Diese Form der Interpolation eignet sich nur, wenn nur relative wenige Werte ausgewertet werden müssen. Ansonsten lohnt sich die bestimmung des expliziten Polynoms.

### Newton Interpolation

Die Newton Interpolation ist eine spezielle Form der Lagrange Interpolation. Hierbei werden die Koeffizienten des Polynoms durch die Differenzenquotienten der Stützstellen bestimmt.

Algorithmus:

1. Initialisiere die Differenzenquotienten
   - $[x_i]f = f(x_i)=y_i$
2. Rekursiv berechne die Differenzenquotienten
   - $[x_i, x_{i+1}, \dots, x_{i+k}]f = \frac{[x_{i+1}, \dots, x_{i+k}]f-[x_i, \dots, x_{i+k-1}]f}{x_{i+k}-x_i}$

Die Interpolation ist dann gegeben durch:

$$
p(x) = \sum_{i=0}^n [x_0, x_1, \dots, x_i]f \cdot \prod_{j=0}^{i-1} (x-x_j)
$$

Diese Methode eignet sich gut, um die Explizite Form des Polynoms zu erhalten. Außerdem ist es leicht möglich, weitere Stützstellen hinzuzufügen.

Der entstehende Fehler ist hierbei $\mathcal{O}(h^{n+1})$. Wo $h$ die Distanz zwischen den Stützstellen ist.

## Kondition von Interpolationspolynomen

Die Kondition der Polynomialen Interpolation ist besonders bei einer großen Anzahl von Stützstellen ($n>7$) ein Problem. Da das entstehende Polynom besonders an den Randstellen extrem oszilieren kann.

# Polynom - Splines

## Definition

Anstatt alle Punkte durch ein gemeinsames Polynom zu interpolieren, wird der Bereich in mehrere Intervalle unterteilt und für jedes Intervall ein eigenes Polynom erstellt, welches dann an den Intervallgrenzen mit den anderen Polynomen "zusammengeklebt" wird.

Ein Spline $s(x)$ von der Ordnung $m$ bzw. mit Grad $m-1$ ist eine Kette von Polynomen mit Grad $m-1$, welche jeweils zwischen zwei Stützstellen die Funktion interpolieren. Außerdem ist $s(x)$ auf dem gesamten Intervall jeweils $m-2$ mal stetig differenzierbar ist.

Beispiel:

- $m=1 \rightarrow$ Stückweise konstante Funktion, Treppenfunktion
- $m=2 \rightarrow$ Stückweise lineare Funktion, stetig
- $m=3 \rightarrow$ Stückweise quadratische Funktion, stetig und einmal stetig differenzierbar

## Kubische Splines

Für den Fall $m=4$ erhält man kubische Splines. Diese eignen sich gut für die Interpolation von Datenpunkten. Da sie einfach zu berechnen sind und eine gute Approximation liefern.

Durch geeignete herleitung, erhält man für jedes Teilintervall folgende Basisfunktionen:

$$
\begin{aligned}
\alpha_1(t) &= 1 - 3t^2 + 2t^3 \\
\alpha_2(t) &= 3t^2 - 2t^3 \\
\alpha_3(t) &= t - 2t^2 + t^3 \\
\alpha_4(t) &= t^3 - t^2
\end{aligned}
$$

Damit erhält man für die Funktion $s(x)$ folgende Form:

$$
\begin{aligned}
s(x) &= p*i\left(\frac{x-x_i}{h_i}\right) := p_i(t)\\
&= y_i \cdot \alpha_1(t) + y*{i+1} \cdot \alpha*2(t) + h_i \cdot y_1' \cdot \alpha_3(t) + h_i \cdot y*{i+1}' \cdot \alpha_4(t)
\end{aligned}
$$

Damit kann der Fehler durch $|f(x)-s(x)| = \mathcal{O}(h^4)$ abgeschätzt werden. Dies ist wesentlich besser als bei der Interpolation durch ein einziges Polynom.

Diese Formel garantieren, dass:

$$
s(x_i) = y_i \quad \forall i\\
s(x_{i+1}) = y_{i+1} \quad \forall i\\
s'(x_i) = y'_i \quad \forall i\\
s'(x_{i+1}) = y'_{i+1} \quad \forall i
$$

# Trigonometrische Interpolation
