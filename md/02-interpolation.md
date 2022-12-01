# Polynom-Interpolation

## Problem

Für eine gegebene Funktion $f(x)$, suchen wir eine Funktion $p(x)$ welche einfach zu konstruieren und für weitere Anwendungen nutzbar ist. $p(x)$ soll dabei $f(x)$ annähern und einen _geringen_ Fehler aufweisen.

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

Mithilfe der Bernstein Polynome lässt sich die Interpolation durch Bezier Kurven realisieren. Diese sind definiert als:

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

Wenn man nicht an der expliziten Representation des Interpolationspolynoms interessiert ist, sondern nur den Funktionswert an einem festen $x$ Wert bestimmen möchte eignet sich das Schema von Aitken und Neville.

Algorithmus:

1. Initialisiere konstante Polynome welche den Funktionswert an den Stützstellen annehmen.
   - $p_{0,0} = y_0, p_{1,0} = y_1, \dots, p_{n,0} = y_n$
2. Verfeinere rekursiv die Polynome durch die Kombibation mehrerer Polynome.
   - $p_{i,j} = \frac{x_{i+k}-x}{x_{i+k}-x_{i}} \cdot p_{i,k-1}(x) + \frac{x-x_{i}}{x_{i+k}-x_{i}} \cdot p_{i+1,k-1}(x)$

Zur Berechnung mit Hand kann folgendes Schema herangezogen werden:

![Dreiecks-Schema für Aitken-Neville](images/aitken_neville_schema.png)

Als Pseudo-Code:

![aitken_neville_code](images/aitken_neville_pseudocode.png)

Diese Form der Interpolation eignet sich nur, wenn nur relative wenige Werte ausgewertet werden müssen. Ansonsten lohnt sich die Bestimmung des expliziten Polynoms.

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

Diese Methode eignet sich gut, um die explizite Form des Polynoms zu erhalten. Außerdem ist es leicht möglich, weitere Stützstellen hinzuzufügen.

Der entstehende Fehler ist hierbei $\mathcal{O}(h^{n+1})$. Wobei $h$ die Distanz zwischen den Stützstellen ist.

Auch für die Newton Interpolation gibt es ein Schema für die händische Berechnung:

![newton_interpolation_schema](images/newton_interpolation_schema.png)

Dementsprechend sind auch die Variablen in den Formeln anders benannt:

![newton_interpolation_formeln](images/newton_interpolation_formeln.png)

## Kondition von Interpolationspolynomen

Die Kondition der Polynomialen Interpolation ist besonders bei einer großen Anzahl von Stützstellen ($n>7$) ein Problem. Da das entstehende Polynom besonders an den Randstellen extrem oszillieren kann.

# Polynom - Splines

## Definition

Anstatt alle Punkte durch ein gemeinsames Polynom zu interpolieren, wird der Bereich in mehrere Intervalle unterteilt und für jedes Intervall ein eigenes Polynom erstellt, welches dann an den Intervallgrenzen mit den anderen Polynomen "zusammengeklebt" wird.

Ein Spline $s(x)$ von der Ordnung $m$ bzw. mit Grad $m-1$ ist eine Kette von Polynomen mit Grad $m-1$, welche jeweils zwischen zwei Stützstellen die Funktion interpolieren. Außerdem ist $s(x)$ auf dem gesamten Intervall jeweils $m-2$ mal stetig differenzierbar ist.

Beispiel:

- $m=1 \rightarrow$ Stückweise konstante Funktion, Treppenfunktion
- $m=2 \rightarrow$ Stückweise lineare Funktion, stetig
- $m=3 \rightarrow$ Stückweise quadratische Funktion, stetig und einmal stetig differenzierbar

## Kubische Splines

Für den Fall $m=4$ erhält man kubische Splines. Diese eignen sich gut für die Interpolation von Datenpunkten, da sie einfach zu berechnen sind und eine gute Approximation liefern.

Durch geeignete Herleitung, erhält man für jedes Teilintervall folgende Basisfunktionen:

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

Diese Formel garantiert, dass:

$$
\begin{aligned}
s(x_i) &= y_i \quad &\forall i\\
s(x_{i+1}) &= y_{i+1} \quad &\forall i\\
s'(x_i) &= y'_i \quad &\forall i\\
s'(x_{i+1}) &= y'_{i+1} \quad &\forall i
\end{aligned}
$$

Der Fehler für kubische Splines kann durch $|f(x)-s(x)| = \mathcal{O}(h^4)$ abgeschätzt werden. Dies ist wesentlich besser als bei der Interpolation durch ein einziges Polynom.

Hierbei benötigt man allerdings die Ableitung des gewünschten Polynoms an den Stützstellen. Sollten diese aber nicht bekannt sein, können diese unter der Annahme von 2-mal stetiger Differenzierbarkeit folgendermaßen ermittelt werden:

![Berechnung der Ableitungen](images/kubische_splines_ableitungen.png)

Somit müssen lediglich die Ableitungen in den Randpunkten des Interpolationsintervalls müssen angegeben werden.

# Trigonometrische Interpolation

## Definition

Bei dieser Form von Interpolation werden die Basisfunktionen durch Sinus- und Kosinus-Funktionen ersetzt. Diese Form der Interpolation ist besonders gut geeignet, wenn die zu interpolierenden Datenpunkte periodisch sind.

Um den Rechenaufwand zu minimieren behilft man sich der komplexen Darstellung von Sinus- und Kosinus-Funktionen. $e^{i\theta} = \cos(\theta) + i\sin(\theta)$

Die verwendeten Stützstellen liegen gleichverteilt auf dem Einheitskreis. Es gilt:
$z_j = e^{\frac{2\pi i}{n}j}$

Der kontinuierliche Interpolant ist gegeben durch: $z_t=e ^{2 \pi i t} \quad t \in [0, 1]$

Das resultierende Polynom hat die Form:

$$
p(t) = \sum_{k=0}^n c_k \cdot z^k = \sum_{k=0}^n c_k \cdot e^{2\pi i kt}
$$

### Diskrete Fourier Transformation

Es soll eine Interpolation gefunden werden die die gleichverteilten Punkte $P=[ (x_0, y_0), (x_1, y_1), \dots, (x_n, y_n) ]$ interpoliert.
Hierbei ist $\omega = e^{\frac{2\pi i}{n}}$ die $n$-te Wurzel von $1$.

$$
\begin{aligned}
 \begin{bmatrix}
           c_{0} \\
           c_{1} \\
           \vdots \\
           c_{n-1} \\
         \end{bmatrix}
 =
 \frac{1}{n}
   \begin{bmatrix}
            1 & 1 & 1& \dots & 1 \\
           1 & \bar{\omega} & \bar{\omega}^{2}  &\dots & \bar{\omega}^{n-1} \\
           \vdots & \vdots & \vdots & \ddots & \vdots \\
             1 & \bar{\omega}^{n-1} & \bar{\omega}^{2(n-1)} & \dots & \bar{\omega}^{(n-1)^2} \\
         \end{bmatrix}
   \begin{bmatrix}
           y_{0} \\
           y_{1} \\
           \vdots \\
           y_{n-1} \\
         \end{bmatrix}
\end{aligned}
$$

Man erhält jetzt also die Werte $[(f_0, c_0), (f_1, c_1), \dots, (f_{n-1}, c_{n-1})]$. Welche jeweils die Frequenz und die Amplitude der jeweiligen Basisfunktionen darstellen.

Damit kann das Polynom $p(t)$ berechnet werden.

### Inverse Diskrete Fourier Transformation

Die Inverse Diskrete Fourier Transformation ist die Umkehrung der Diskreten Fourier Transformation. Sie berechnet die Funktionswerte $y_i$ aus den Koeffizienten $c_i$.

$$
\begin{aligned}
\begin{bmatrix}
           y_{0} \\
           y_{1} \\
           \vdots \\
           y_{n-1} \\
         \end{bmatrix}
 =
   \begin{bmatrix}
            1 & 1 & 1& \dots & 1 \\
           1 & \omega & \omega^{2}  &\dots & \omega^{n-1} \\
           \vdots & \vdots & \vdots & \ddots & \vdots \\
             1 & \omega^{n-1} & \omega^{2(n-1)} & \dots & \omega^{(n-1)^2} \\
         \end{bmatrix}
   \begin{bmatrix}
           c_{0} \\
           c_{1} \\
           \vdots \\
           c_{n-1} \\
         \end{bmatrix}
\end{aligned}
$$

### Fast Fourier Transformation

Die Fast Fourier Transformation ist eine effiziente Methode zur Berechnung der Diskreten Fourier Transformation. Sie ist eine rekursive Methode, die die Berechnung der Diskreten Fourier Transformation in $\mathcal{O}(n \log n)$ durchführt.

Algorithmus:

- Divide:
  1. Teile die Daten in zwei Teile auf. Einmal die geraden und einmal die ungeraden Indizes.
  2. Wiederhole Schritt 1 für die beiden Teile, solange bis nur noch ein Wert übrig ist.
- Konquer:
  1. Kombiniere jeweils die geraden und ungeraden Werte eines Teils zu einem neuen Wert.
  2. Wende dazu den _Butterfly_ Operator an.
     - $[a_j, b_j] \mapsto [a_j +\omega^j b_j, a_j - \omega^j b_j]$
