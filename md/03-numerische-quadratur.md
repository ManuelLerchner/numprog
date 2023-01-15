# Numerische Quadratur

## Problem

Gegeben sei eine Funktion $f(x)$, die auf einem Intervall $[a,b]$ definiert ist. Wir wollen nun die Fläche unter der Kurve numerisch $f(x)$ berechnen. Die Integration kann auch als gewichtete Summe der Funktionswerte auf einem Gitter gesehen werden.

$$
I(f) \approx Q(f) := \sum_{i=0}^n g_i \cdot y_i
$$

Idee: Anstatt eine komplizierte Funktion zu integrieren, und diese womöglich sehr oft ausrechnen zu müssen, um die benötigten Stützpunkte zu erhalten, können wir die Funktion durch Polynome interpolieren und dann die Fläche unter dieser Polynome exakt berechnen.

$$
  Q(f) = \int_a^b \tilde{f}(x) dx := \int_a^b p(x) dx
$$

Hierbei stellt $\tilde{f}(x) = p(x)$ die Interpolationsfunktion dar.

Sonderfall: Wenn man $p(x)$ mittels Lagrange Interpolation berechnet, kann man die Resultierenden Faktoren vorberechnen.

## Kondition der numerischen Quadratur

Wenn alle gewichte $g_i$ der Interpolation positiv sind, dann ist die die numerischen Quadratur gut konditioniert. Der Fehler des Ergebnisses ist dann proportional zum Fehler der Eingabedaten.

Sollten jedoch manche Gewichte negativ sein, dann ist die numerische Quadratur schlecht konditioniert.

## Algorithmen

### Rechteckregel

Die Rechteckregel ist die einfachste Form der numerischen Quadratur. Hierbei wird die Fläche unter der Kurve durch ein Rechtecke abgeschätzt. Im gesamten Intervall $[a,b]$ ergibt sich dann:

$$
Q_R(f):= H \cdot f\left(\frac{a+b}{2}\right)
$$

Für das Integrationsintervall der Länge $H$ wird also der Mittelpunkt berechnet und eine Konstante Funktion durch diesen Punkt gelegt. Dieses einfache Polynom wird nun exakt integriert.

Der entstandene Fehler bei dieser Variante ist in $O(H^3 \cdot f''(\xi))$.

### Trapezregel

Ansatz: Die Fläche unter der Kurve kann im Intervall $[a,b]$ auch durch ein Trapez abgeschätzt werden. Dieses Polynom wird nun exakt integriert.

$$
Q_T(f):= H\cdot \frac{ \left(f(a) + f(b)\right)}{2}
$$

Der entstandene Fehler bei dieser Variante ist immer noch in $O(H^3 \cdot f''(\xi))$.

### Kepler'sche Regel

Anstatt die Funktion $f(x)$ durch ein lineares Polynom abzuschätzen verwenden wir ein quadratisches Polynom. Dieses Polynom wird nun exakt integriert.

Für das Intervall $[a,b]$ ergibt sich:

$$
Q_F(f):= H\cdot  \frac{\left(f(a) + 4 \cdot f\left(\frac{a+b}{2}\right) + f(b)\right)}{6}
$$

Die Fehlerordnung ist hier in: $O(H^5 \cdot f^{(4)}(\xi))$.

### Trapezregel mit mehreren Teilintervallen

Die Trapezregel kann auch auf mehrere Teilintervalle der Länge $h=\frac{b-a}{n}$ angewendet werden. Hierbei wird die Fläche unter der Kurve in Jedem Intervall durch ein Trapez abgeschätzt.

Auf dem gesamten Intervall $[a,b]$ ergibt sich:

$$
Q_{TS}(f):= h \cdot (\frac{f_0}{2} + f_1 + f_2 + \dots + f_{n-1} + \frac{f_n}{2})
$$

Der Fehler ist hier in $O(H\cdot h^2 \cdot f''(\xi))$.

### Simpson'sche Regel

Die Simpson'sche Regel ist eine Erweiterung der Trapezregel. Hierbei wird die Funktionin Jedem Intervall durch ein Parabel-Polynom abgeschätzt.

Auf dem gesamten Intervall $[a,b]$ ergibt sich:

$$
Q_{SS}(f):= \frac{h}{3} \cdot \left(f_0 + 4 \cdot f_1 + 2 \cdot f_2 + 4 \cdot f_3 + \dots + 2 \cdot f_{n-2} + 4 \cdot f_{n-1} + f_n\right)
$$

Der Fehler ist hier in $O(H\cdot h^4 \cdot f^{(4)}(\xi))$.

## Nicht gleichmäßige Gitter

Um mehrere Abtastpunkte am Rand des Intervalls können die Abtastpunkte auch anders gewählt werden.

$x_i = a + H \cdot \frac{1- \cos\left(\frac{i \cdot \pi}{n}\right)}{2}$

## Extrapolation

Bei der Extrapolation wird die numerische Quadratur mit verschider Anzahl von Teilintervallen berechnet. Die daraus resultierenden Ergebnisse werden dann intelligent miteinander kombiniert (extrapoliert), um so ein um ein Vielfaches genaueres Ergebnis zu erhalten.

![Extrapolation](images/extrapolation.png)

## Monte Carlo Integration

Bei der Monte Carlo Integration wird die Fläche unter der Kurve durch eine große Anzahl von Zufallszahlen abgeschätzt. Dabei wird die zu integrierende Funktion $f(x)$ in einen Bereich eingebettet, der die Fläche unter der Kurve umfasst. Die Zufallszahlen werden nun in diesem Bereich verteilt. Die Anzahl der Zufallszahlen, die unter der Kurve liegen, ist proportional zur Fläche unter der Kurve.

## Gaussian Quadrature

Bei der Gaussian Quadrature werden die Gewichte und die Stützstellen der Interpolation so gewählt, dass die Interpolation exakt ist.

Bei $n$ Stützstellen ergibt sich eine maximale exakte Interpolation von Polynomen der Ordnung $2n-1$.

Zum Beispiel:

$$
\int_{-1}^{1} f_k(x) \cdot dx = \sum_{i=1}^{n} w_i \cdot f_k(x_i)
$$

Erstelle Gleichungsystem für $f_k \in \{
  1, x, x^2, x^3, \dots,\}$

## Archimedes Quadrature

Eine Divide-and-Conquer Variante der Integration. Hierbei wird iterativ die Fläche unter einer Kurve bestimmt, indem man Teilflächen konstruiert, die sich immer weiter an die Fläche annähern.
