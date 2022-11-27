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
