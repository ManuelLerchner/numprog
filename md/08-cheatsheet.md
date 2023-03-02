# Cheatsheet

## Float

### IEEE Floating Point

|      | Sign | Exponent | Mantissa |
|:----:|:----:|:--------:|:--------:|
| Bits | 1    | 8        | 23       |

+ **Sign:** 0 = positive, 1 = negative

+ **Exponent:** e wird um 127 erhöht

+ **Mantissa:** 1. + 23 bits

### Machinengenauigkeit

+ $\rho = B^{1-t}$
  
mit $B$ Basis und $t$ Mantissenstelle (inklusive impliziter 1)

Dadurch wird der maximale relative Abstand zwischen zwei Zahlen festgelegt.

### Runden

Es wird immer gerundet. Falls die Zahl genau in der Mitte liegt, wird auf die nächste gerade Zahl gerundet.

Der maximale relative Rundungsfehler ist: $\epsilon_{mach} \leq \rho$

### Auslöschung

Auslöschung tritt auf, wenn zwei ähnlich große Zahlen mit ähnlichen Mantissen subtrahiert werden. Dabei gehen signifikante Stellen verloren.

## Kondition

+ Eigenschaft des Problems
+ Um wie viel kann sich die Lösung verändern, wenn man die Eingabe leicht ändert?
  
$cond_{abs}(f,x)= \frac{f(x+\delta x)-f(x)}{\delta x}$

$cond_{rel}(f,x)= \left|\frac{err_{rel}}{\frac{\delta x}{x}}\right|= \left | \frac{x \cdot f'(x)}{f(x)} \right |$

Grundrechenarten $\{+,-\}$ sind schlecht konditioniert.

## Stabilität

+ Eigenschaft des Algorithmus
+ numerisch stabil $\iff$ abweichendes Ergebnis kann durch leicht abweichende Eingaben erklärt werden
+ Grundrechenarten sind numerisch stabil
+ Komposition von numerisch stabilen Algorithmen nicht umbedingt numerisch stabil

1. Berechnung der Gerundeten Funktion $rd(f)$:

   + Ersetze alle Operationen $op$ durch $\dot{op}$
     + $a\ \dot{op} \ b = (a\ op\ b) \cdot (1+ \epsilon_{rel_i})$
     + $\epsilon_1 \cdot \epsilon_2 :=0$

2. Untersuche, ob der relative Fehler unendlich groß werden kann.

   + $\epsilon_{rel}=\left|\frac{rd(f)(x)-f(x)}{f(x)} \right|$

## Interpolation

### Basispolynome

+ Bernsteinpolynom / Bezierpolynom:
  
    $B_{n,i}(x)=\binom{n}{i}x^i(1-x)^{n-i}$

    $X(t) = \sum_{i=0}^n b_i B_{n,i}(t)$

+ Lagrangepolynom:
  
    $L_{n,i}(x)=\prod_{j=0,j\neq i}^n\frac{x-x_j}{x_i-x_j}$

    $p(x) = \sum_{i=0}^n y_i L_{n,i}(x)$

### Interpolationfehler

$f(\bar{x})-p(\bar{x}) = \frac{f^{(n+1)}(\xi)}{(n+1)!} \cdot \prod_{i=0}^n (\bar{x}-x_i)$

Bei gleichmäßig verteilten Stützstellen ist der Fehler $\mathcal{O}(h^{n+1})$.

### Aitken-Neville Interpolation

Interpolation-**Wert** wird bestimmt. $O(n^2)$

Lohnt sich bei wenigen zu bestimmenden Werten.

Eignet sich gut, zusätzliche Stützstellen im Nachhinein zu ergänzen.

---

|$x_i$  | $i \diagdown k$ | 0 | 1  | 2 |
|:----: |:----:|:--------:  |:--------: | :--------:|
| $x_0$ | 0    | $p_0$     | $p_{0,1}$ | $\bold{\color{green}p_{0,2}=f(x)}$ |
| $x_1$ | 1    | $y_1$      | $p_{1,1}$ |           |
| $x_2$ | 2    | $y_2$      |           |           |

+ $p_{i,k} = p_{i,k-1} + \frac{x-x_i}{x_{i+k}-x_i} \cdot (p_{i+1,k-1}-p_{i,k-1})\quad=\quad \leftarrow- \frac{x-x_{row}}{x_{\#diag}-x_{row}} \cdot (\swarrow - \leftarrow)$

### Newton Polynominterpolation / Dividierte Differenzen

Interpolation-**Polynom** wird bestimmt. $O(n^2)$

Lohnt sich bei vielen zu berechnenden Funktionswerten.

Eignet sich gut, zusätzliche Stützstellen im Nachhinein zu ergänzen.

Es brauch jedoch jeweils $O(n)$ um das Polynom bei $x$ zu berechnen.

|$x_i$  | $i \diagdown k$ | 0 | 1  | 2 |
|:----: |:----:|:--------:  |:--------: | :--------:|
| $x_0$ | 0    | $\bold{\color{green}y_0}$     | $\bold{\color{green}c_{0,1}}$ | $\bold{\color{green}c_{0,2}}$ |
| $x_1$ | 1    | $y_1$      | $c_{1,1}$ |           |
| $x_2$ | 2    | $y_2$      |           |           |

+ $c_{i,k} = \frac{c_{i+1,k-1}-c_{i,k-1}}{x_{i+k}-x_i} = \frac{\swarrow - \leftarrow}{x_{\#diag} - x_{row}}$

+ $P(x) = c_{0,0} + c_{0,1}(x-x_0) + c_{0,2}(x-x_0)(x-x_1)+\dots + c_{0,n} \prod_{j=0}^{n-1} (x-x_j)$

### Runge Effekt

Bei hohen Polynomgraden oszilliert das Interpolationspolynom an den Rändern stark. Lösung: Abtastpunkte an den Rändern erhöhen (Clenshaw-Curtis-Interpolation $x_i = a+H\cdot \frac{i-\cos(i\pi/n)}{2}$), oder Splines verwenden.

## Stückweise Hermite-Interpolation

Benötigt: $P_H=\{(x_0,y_0,y'_0),\dots,\}$

### Hermit Basispolynome

1. $H_0(t)=1-3t^2+2t^3$
2. $H_1(t)=3t^2-2t^3$
3. $H_2(t)=t-2t^2+t^3$
4. $H_3(t)=-t^2+t^3$

Die Interpolationsfunktion soll jeweils zwischen zwei Punkten interpolieren:

+ $S_{[i,i+1]}(t)=y_i \cdot H_0(t)+y_{i+1} \cdot H_1(t)+y'_i\cdot h \cdot H_2(t)+y'_{i+1} \cdot h\cdot H_3(t)$
+ mit $t_i(x)=\frac{x-x_i}{x_{i+1}-x_i} \in [0,1]$

$$
\begin{aligned}
P(x) = \begin{cases}
S_{[0,1]}(t_0(x)) & \text{für } x \in [x_0,x_1] \\
S_{[1,2]}(t_1(x)) & \text{für } x \in [x_1,x_2] \\
& \vdots \\
S_{[n-1,n]}(t_{n-1}(x)) & \text{für } x \in [x_{n-1},x_n]
\end{cases}
\end{aligned}
$$

### Splines

Benötigt: $P_L=\{(x_0,y_0),\dots,\}$, $y'_0$ und $y'_n$.

Bei Splines fordert man $\mathcal{C}^2$-stetigkeit.

Dafür berechnet man die Steigungen, welche die Splines an den Stützstellen verbinden.

$$
\begin{bmatrix}
 4 & 1 &   &  &  \\ 1 & 4 & \ddots &  &  \\   & \ddots & \ddots & 1  \\   &   & 1 & 4 & \\
\end{bmatrix} \cdot \begin{bmatrix}
y'_1 \\ y'_2 \\ \vdots \\ y'_{n-2} \\ y'_{n-1}
\end{bmatrix} = \frac{3}{h} \cdot \begin{bmatrix}
y_2-y_0- \frac{h}{3} \cdot y'_0 \\ y_3-y_1 \\ \vdots \\ y_{n-1}-y_{n-3} \\ y_n-y_{n-2}- \frac{h}{3} \cdot y'_n
\end{bmatrix}
$$

Damit hat man alle Steigungen, welche die Splines an den Stützstellen verbinden. Somit kann man mit $P_H=\{(x_0,y_0,y'_0),\dots,\}$ Hermit interpolation durchführen.

## Fourier Transformation

Eingabe: $Punkte = \{(v_0),\dots,(v_{n-1})\}$ gleichmäßig verteilt

$\omega = e^{2\pi i/n}$

Gesucht:

+ $p(t) = \sum_{k=0}^{n-1} c_k \cdot e^{2\pi i \cdot k \cdot t}$ mit $t \in [0,1]$

Berechne $c_k$:

### DFT

$$
\begin{aligned}
\begin{bmatrix}
c_0 \\ c_1 \\ \vdots \\ c_{n-1}
\end{bmatrix} = \frac{1}{n} \cdot \underbrace{\begin{bmatrix}
1 & 1 & \dots & 1 \\ 1 & \overline \omega^{1\cdot 1} & \dots & \overline \omega^{1\cdot (n-1)} \\ \vdots & \vdots & \ddots & \vdots \\ 1 & \overline \omega^{(n-1)\cdot 1} & \dots & \overline \omega^{(n-1)\cdot (n-1)}
\end{bmatrix}}_{\text{DFT Matrix}} \cdot
\begin{bmatrix}
v_0 \\ v_1 \\ \vdots \\ v_{n-1}
\end{bmatrix}
\end{aligned}
$$

### IDFT

$$
\begin{aligned}
\begin{bmatrix}
v_0 \\ v_1 \\ \vdots \\ v_{n-1}
\end{bmatrix} =  \underbrace{\begin{bmatrix}
1 & 1 & \dots & 1 \\ 1 & \omega^{1\cdot 1} & \dots & \omega^{1\cdot (n-1)} \\ \vdots & \vdots & \ddots & \vdots \\ 1 & \omega^{(n-1)\cdot 1} & \dots & \omega^{(n-1)\cdot (n-1)}
\end{bmatrix}}_{\text{IDFT Matrix}} \cdot
\begin{bmatrix}
c_0 \\ c_1 \\ \vdots \\ c_{n-1}
\end{bmatrix}
\end{aligned}
$$

### Zusammenhang

$\text{DFT}(v) =\frac{1}{n} \cdot \overline{\text{IDFT}(\overline{v})}$

$\text{DFT}(v+w) = \text{DFT}(v) + \text{DFT}(w)$

$\text{DFT}(\text{IDFT}(v)) = v$

### IFFT

Butterfly-Operator:

$$
\begin{aligned}
\begin{matrix}
\begin{bmatrix}
a_j
\end{bmatrix}\\
\rule{0px}{12px}
\begin{bmatrix}
b_j
\end{bmatrix}
\end{matrix}
\rightarrow
\begin{bmatrix}
a_j + \omega^j \cdot b_j \\ a_j - \omega^j \cdot b_j
\end{bmatrix}
\end{aligned}
$$

1. $c_{even} = \{c_0,c_2,\dots,c_{n-2}\}$ und $c_{odd} = \{c_1,c_3,\dots,c_{n-1}\}$
2. $even = \text{IFFT}(c_{even})$ und $odd = \text{IFFT}(c_{odd})$
3. $\omega = e^{2\pi i/n}$
4. $k \in [0,\frac{n}{2}-1]$
   + $v_k = even_k + \omega^k \cdot odd_k$ für $k \in [0,\frac{n}{2}-1]$
   + $v_{k+\frac{n}{2}} = even_k - \omega^k \cdot odd_k$ für $k \in [0,\frac{n}{2}-1]$
5. $v = \{v_0,\dots,v_{n-1}\}$

## Integration

### Rechteckregel

$Q_R= H \cdot f(\frac{a+b}{2})$

$R_R=-H^3 \cdot \frac{f''(\xi)}{24}$

### Trapezregel

$Q_T= \frac{H}{2} \cdot (f(a)+f(b))$

$R_T=H^3 \cdot \frac{f''(\xi)}{12}$

#### Trapezsumme

$Q_{TS}=h \cdot (\frac{f(0)}{2} + f(1) + \dots + f(n-1) + \frac{f(n)}{2})$

$R_{TS}=h^2 H \cdot \frac{f''(\xi)}{12}$

### Keplersche Regel

$Q_K= \frac{H}{6} \cdot (f(a)+4f(\frac{a+b}{2})+f(b))$

$R_K=H^5 \cdot \frac{f^{(4)}(\xi)}{2880}$

#### Simpsonsumme

$Q_{SS}=\frac{h}{3} \cdot (f(0)+4f(1)+2f(2)+4f(3)+\dots+2f(n-2)+4f(n-1)+f(n))$

$R_{SS}=h^4 H \cdot \frac{f^{(4)}(\xi)}{180}$

### Romberg-Integration

Kombiniere Trapezsummen unterschiedlicher Schrittweite $h$, und schätze mit extrapolation den Fall $h \rightarrow 0$. ab.

|$h_i$  | $i \diagdown k$ | 0 | 1  | 2 |
|:----: |:----:|:--------:  |:--------: | :--------:|
| $\frac{b-a}{1}$ | $0$ | $Q_{TS}(f,h=h_i)$ | | |
| $\frac{b-a}{2}$ | $1$ | $Q_{TS}(f,h=h_i)$ | $Q_{1,1}$ | |
| $\frac{b-a}{4}$ | $2$ | $Q_{TS}(f,h=h_i)$ | $Q_{2,1}$ | $\bold{\color{green}{Q_{2,2}} \approx Q_{TS}(f,0)}$

$Q_{i,k} = Q_{i,k-1} + \frac{Q_{i,k-1}-Q_{i-1,k-1}}{\frac{h_{i-k}^2}{h_{i}^2}-1} \quad = \quad \leftarrow + \frac{\leftarrow - \nwarrow}{\frac{h_{\#diag}^2}{h_{row}^2}-1}$

Alternativ: Extrapoliere die Punkte $\{(h_0,Q_{TS}(f,h_0)),(h_1,Q_{TS}(f,h_1)),\dots,\}$ in einem Koordinatensystem und schätze den Wert für $h=0$ ab.

Fehler: $|p(0) - I(f)| = O(h_1^2 \cdot \ \dots \ \cdot h_i^2)$

### Gauss-Quadratur

Idee: Integral als Summe von Funktionswerten an unregelmäßigen Stützstellen mit verschiedenen Gewichten.

$\int_a^b p_k(x) \, dx \stackrel{!}{=} \sum_{i=1}^n w_i \cdot p_k(x_i)$ mit $k \in [0,2n-1]$

Bei einem Polynom von Grad $n$ können $n$ Gleichungen aufgestellt werden (z.B. $p_0(x)=1, p_1(x)=x, \dots$). Nun muss man die Stützstellen $x_i$ und die Gewichte $w_i$ bestimmen.

Mit $n$ Punkten kann man Polynome von Grad $2n-1$ exakt integrieren.

#### Archimedes

Nähere die Fläche mit Dreiecken an. In jedem Schritt werden neue Dreiecke hinzugefügt um die Fläche noch besser abzuschätzen.

## Lineare Gleichungssysteme

### Kondition von Matrizen

Die Kondition ergibt sich als Verhältnis der größten zu der kleinsten Eigenwert der Matrix.

$\kappa(A) = ||A|| \cdot ||A^{-1}|| = \sqrt{\lambda_{max}(A^TA)} \cdot \sqrt{\lambda_{max}(A^{-T} A^{-1})} =\sqrt{\frac{\lambda_{max}(A^TA)}{\lambda_{min}(A^TA)}} \stackrel{\text{A symmetrisch?}}{=} \left|\frac{\lambda_{max}(A)}{\lambda_{min}(A)}\right|$.

### Residuum

$r = b - A\tilde{x} = -A \cdot \underbrace{(x -  \tilde{x})}_{\text{error e}}$

Gleichungsysteme werden iterativ gelöst, indem das Residuum immer wieder reduziert wird.

### Gauss Elimination

Laufzeit: $O(n^3)$

1. loop $j$ von $0$ bis $n-1$
   1. loop $k$ von $j+1$ bis $n-1$
      1. $m_{k,j} = -\frac{a_{k,j}}{a_{j,j}}$
      2. loop $i$ von $j+1$ bis $n$
         1. $a_{k,i} = a_{k,i} + m_{k,j} \cdot a_{j,i}$
      3. $b_k = b_k + m_{k,j} \cdot b_j$
2. loop $j$ von $n-1$ bis $0$
   1. $x_j = \frac{b_j}{a_{j,j}}$
   2. loop $k$ von $n-1$ bis $j+1$
      1. $x_j  = x_j - a_{j,k} \cdot x_k$
   3. $x_j = \frac{x_j}{a_{j,j}}$

#### Spaltenpivotisierung

Bevor die Elimination durchgeführt wird, wird die Zeile mit dem größten Betragswert der derzeitigen Spalte mit der aktuellen Zeile vertauscht.
Dabei muss der Vektor $b$ auch vertauscht werden.

#### Zeilenpivotisierung

Bevor die Elimination durchgeführt wird, wird die Spalte mit dem größten Betragswert der derzeitigen Zeile mit der aktuellen Spalte vertauscht.
Dabei muss der Vektor $x$ auch vertauscht werden.

#### Totalpivotisierung

Man kann auch Zeilen und Spalten gleichzeitig vertauschen. Um das betragsmäßig größte Element aus der restlichen Matrix an die aktuelle Position zu bringen.

### LR-Zerlegung

Laufzeit: $O(n^3)$ konstruktion, $O(n^2)$ Auswertung

1. Führe Gauss Elimination durch, aber speichere die Multiplikatoren $-m_{k,j}$ in einer Matrix $L$. (Hauptdiagonale von $L$ ist $1$)
2. Die Matrix $R$ ergibt sich aus der Matrix nach der Elimination.
3. $A=LR$

Zum Berechnen der Lösung LR x = b, wird erst L y = b gelöst und dann R x = y gelöst. Beide Schritte sind $O(n^2)$.

## Cholesky-Zerlegung

Laufzeit: $O(n^3)$ konstruktion, $O(n^2)$ Auswertung
Braucht aber in der Praxis nur halb so viel Zeit und Speicherplatz wie die LR-Zerlegung.

1. loop $j$ von $0$ bis $n-1$
   1. $L_{j,j} = \sqrt{A_{j,j} - \sum_{k=0}^{j-1} L_{j,k}^2}$
   2. loop $i$ von $j+1$ bis $n-1$
      1. $L_{i,j} = \frac{A_{i,j} - \sum_{k=0}^{j-1} L_{i,k} \cdot L_{j,k}}{L_{j,j}}$

Es gilt $A = LL^T$.

## Differentialgleichungen

$y' = f(t,y)$

### Trennung der Variablen

$y' = f(t,y) \Rightarrow \frac{dy}{dt} = g(t)*f(y) \Rightarrow \frac{dy}{f(y)} = g(t) \cdot dt \Rightarrow \int \frac{dy}{f(y)} = \int g(t) dt$

Falls die Steigung immer endlich ist, ist durch die Lipschitzbedingung sichergestellt, dass die Lösung eindeutig ist und existiert.

### Explizites Euler-Verfahren

$y_{k+1} = y_k + \delta t \cdot f(t_k, y_k)$

Die Ordnung des Verfahrens ist $O(\delta t)$.

Dieses Verfahren tendiert dazu der Funktion hinterher zu hinken.

### Implizites Euler-Verfahren

$y_{k+1} = y_k + \delta t \cdot f(t_{k+1}, y_{k+1})$

Diese Gleichung wird auf $y_{k+1}$ aufgelöst. Gegebenenfalls muss die Lösung iterativ berechnet werden.

Die Ordnung des Verfahrens ist $O(\delta t)$.

Dieses Verfahren tendiert dazu der Funktion voraus zu sein.

### Heun-Verfahren

$y_{k+1} = y_k + \frac{\delta t}{2} \cdot (f(t_k, y_k) + f(t_{k+1}, y_k+\delta t \cdot f(t_k, y_k)))$

Die Ordnung des Verfahrens ist $O(\delta t^2)$.

### Runge-Kutta-Verfahren

$y_{k+1} = y_k + \frac{\delta t}{6} \cdot (T_1 + 2T_2 + 2T_3 + T_4)$

mit
$$
\begin{aligned}
T_1 &= f(t_k, y_k) \\
T_2 &= f(t_k + \frac{\delta t}{2}, y_k + \frac{\delta t}{2} \cdot T_1) \\
T_3 &= f(t_k + \frac{\delta t}{2}, y_k + \frac{\delta t}{2} \cdot T_2) \\
T_4 &= f(t_{k+1}, y_k + \delta t \cdot T_3)
\end{aligned}
$$

Die Ordnung des Verfahrens ist $O(\delta t^4)$.

### Mittelpunktsregel

$y_{k+1} = y_{k-1} + 2 \delta t \cdot f(t_k, y_k)$

Mehrschrittverfahren

Der Erste Schritt wird hierbei mit dem expliziten Euler-Verfahren berechnet.

#### Lokaler Fehler

Der lokale Fehler ist der maximale Fehler, der bei einem Schritt entsteht.
Angenommen alle Schritte vorher waren korrekt.

#### Globaler Fehler

Der globale Fehler ist der maximale Fehler, der bei allen Schritten entsteht.

### Konsistenz

Ein Verfahren ist konsistent, wenn der lokale Fehler mit kleineren Schritten gegen Null geht.

### Stabilität (ode)

Ein Verfahren ist stabil, wenn es gegen kleinen Störungen (runden...) unempfindlich ist.

Eigenschaft des Verfahrens.

### Steifheit

Diferentialgleichung ist steif, wenn der lokale Fehler nur mit sehr kleinen Schrittweiten gegen Null geht.

### Konvergenz

Ein Verfahren ist konvergent, wenn der globale Fehler mit kleineren Schritten gegen Null geht.

Bei Einschrittverfahren gilt: $Konsistenz \implies Konvergenz$.

Bei Mehrschrittverfahren gilt: $Konsistenz + Stabilität \iff Konvergenz$.

## Iterative Gleichungslöser

$r=A\tilde{x}-b$

### Richardson-Iteration

$x_{k+1}^{(i+1)} = x_k^{(i)} + r_k^{(i)}$

Oder: $x^{(i+1)}=x+I\cdot (b-Ax)$

### Jacobi-Iteration

$y_{k}^{(i)} = \frac{1}{a_{kk}}\cdot r_k^{(i)}$

$x_{k}^{(i+1)} = x_k^{(i+1)} + y_k^{(i)}$

Oder: $x^{(i+1)}=x+{(Diag_A)}^{-1}\cdot (b-Ax)$

### Gauss-Seidel-Iteration

$r_k^{(i)} = b_k - \sum_{j=1}^{k-1} a_{kj} \cdot x_j^{(i+1)} - \sum_{j=k}^{n} a_{kj} \cdot x_j^{(i)}$

$y_{k}^{(i)} = \frac{1}{a_{kk}}\cdot r_k^{(i)}$

$x_{k}^{(i+1)} = x_k^{(i)} + \alpha \cdot y_k^{(i)}$

Oder: $x^{(i+1)}=x+{(LowerTriang_A)}^{-1}\cdot (b-Ax)$

### Steepest-Descent-Iteration

$\alpha^{(i)} = \frac{(r^{(i)})^T \cdot r^{(i)}}{(r^{(i)})^T \cdot A \cdot r^{(i)}}$

$x^{(i+1)} = x^{(i)} + \alpha^{(i)} \cdot r^{(i)}$

### Conjugate-Gradient-Iteration

Konvergiert nach $n$ Schritten zur idealen Lösung. Da in jedem Schritt ein Eintrag der Lösung exakt berechnet wird.

## Nullstellen

### Bisektionsverfahren

1. Berechne die Funktionswerte an den Endpunkten $f(a)$ und $f(b)$.
2. Berechne den Funktionswert in der Mitte $f(c)$.
3. Wähle den Teilbereich, in dem sich die Nullstelle befindet.
4. Wiederhole

### Regula Falsi

1. Berechne die Funktionswerte an den Endpunkten $f(a)$ und $f(b)$.
2. Verbinde die Punkte $(a, f(a))$ und $(b, f(b))$ mit einer Geraden. Berechne den Schnittpunkt mit der x-Achse. Und berechne $f(c)$.
3. Wähle den Teilbereich, in dem sich die Nullstelle befindet.
4. Wiederhole

### Sekantenverfahren

1. Starte mit zwei Startwerten $x_0$ und $x_1$.
2. Berechne die Funktionswerte an den Endpunkten $f(x_0)$ und $f(x_1)$.
3. Bestimme die Gerade durch die Punkte $(x_0, f(x_0))$ und $(x_1, f(x_1))$. Und finde den Schnittpunkt mit der x-Achse. Und berechne $(x_2,f(x_2))$.
4. Wiederhole mit Punkten $(x_1, f(x_1))$ und $(x_2, f(x_2))$ ...

### Newton-Verfahren

$x^{(i+1)} = x^{(i)} - \frac{f(x^{(i)})}{f'(x^{(i)})}$

## Symetrische Eigenwertprobleme

Gut Konditioniert

### Reyleigh-Quotient

Aus einem Eigenvektor $v$ folgt der Eigenwert $\lambda$.

$\lambda = \frac{v^T \cdot A \cdot v}{v^T \cdot v}$

Für $||v|| = 1$ gilt $\lambda = v^T \cdot A \cdot v$

### Power-Iteration

$x^{(i+1)} = \frac{A \cdot x^{(i)}}{||A \cdot x^{(i)}||}$

Konvergiert zu einem Eigenvektor mit dem (betragsmäßig) größten Eigenwert.

$O(n^2)$ pro Iteration. Konvergenz Eigenvektor: $O(n)$, Konvergenz Eigenwert: $O(n^2)$

Durch Shifting ($A-\mu I$) kann man alle Eigenwerte um $-\mu$ verschieben.

Die Konvergenzrate ist $q=|\frac{\lambda_{2}}{\lambda_{1}}|$ mit $\lambda_1$ der größte Eigenwert und $\lambda_2$ der zweitgrößte Eigenwert.

Um alle Eigenwerte iterativ zu berechnen, muss man die Matrix $A$ nach der bestimmung von $\lambda_1$ in $A'=A-\lambda_1 v_1 v_1^T$ transformieren. Die neue Marix hat die Gleichen Eigenwerte, aber ohne $\lambda_1$.

### Inverse-Iteration

Um Einen Speziellen Eigenwert in der nähe von $\mu$ zu bestimmen, wird
die Power Iteration auf der Matrix $(A-\mu I)^{-1}$ durchgeführt.

Wenn man $(A-\mu I) x^{(k+1)} = x^{(k)}$ durch iterative Gleichungssystem löser auf $x^{(k+1)}%$ umformt muss man die Matrix nicht invertieren. Der Vektor $x$ muss nach jedem Schritt normalisiert werden.

Der Vektor $x$ konvergiert zum Eigenvektor des Eigenwertes in der nähe von $\mu$.

LU-Zerlegung, beschleunigt die Berechnung.

### Rayleight Quotient Iteration

Ähnlich wie Inverse Iteration, aber $(A-\mu^{(k)} I)$ wird jedes mal neu berechnet. mit $\mu^{(k)} = (x^k)^T A x^k$

Konvergenz des Eigenwerts: $O(n^3)$

Sehr teuer, Eigenvektoren konvergieren jedoch immer noch $O(n)$

### QR-Zerlegung

$A = Q \cdot R$ mit $Q$ Orthogonal und $R$ Obere Dreiecksmatrix.

Finde ein $G$ sodass $G A = R$  eine obere Dreiecksmatrix ist. und $G$ orthogonal ist. Dies kann mit Givens Rotationen erreicht werden, welche jeweils Einträge der Matrix auf 0 drehen.
