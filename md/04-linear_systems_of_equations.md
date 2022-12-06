# Lineare Gleichungssysteme

Lineare Gleichungssysteme sind ein sehr wichtiges Thema in der Mathematik. Mit ihnen lassen sich Matrix-Vektor-Produkte, Eigenwerte, Differentialgleichungen ... berechnen.

## Arten von Matrizen

### Volle Matrizen

Eine volle Matrix ist eine Matrix, in der die meisten Elemente nicht Null sind. Sie wird auch als dicht bezeichnet.

### Sparse Matrix

Eine Sparse Matrix ist eine Matrix, bei der die meisten Elemente 0 sind. Diese Nullen tauchen oft in einem speziellen Muster auf.

Beispiel:

$$
\begin{aligned}
Diagonalmatrix &= \begin{pmatrix}
1 & 0 & 0 & 0 & 0 \\
0 & 1 & 0 & 0 & 0 \\
0 & 0 & 1 & 0 & 0 \\
0 & 0 & 0 & 1 & 0 \\
0 & 0 & 0 & 0 & 1 \\
\end{pmatrix}\\
Tridiagonalmatrix &= \begin{pmatrix}
1 & 1 & 0 & 0 & 0 \\
1 & 1 & 1 & 0 & 0 \\
0 & 1 & 1 & 1 & 0 \\
0 & 0 & 1 & 1 & 1 \\
0 & 0 & 0 & 1 & 1 \\
\end{pmatrix}\\
BandedMatrix &= \begin{pmatrix}
1 & 1 & 1 & 0 & 0\\
1 & 0 & 0 & 1 & 0\\
1 & 0 & 0 & 0 & 1\\
0 & 1 & 0 & 0 & 1\\
0 & 0 & 1 & 1 & 1\\
\end{pmatrix}\\
\end{aligned}
$$

## Lösungsverfahren

Es gibt zwei verschiedene Arten von Lösungsverfahren für lineare Gleichungssysteme:

1. Direkte Verfahren

   - Bei diesen Verfahren wird (bis auf Rundungsfehler) das exakte Ergebnis berechnet.

2. Indirekte Verfahren

   - Bei diesen Verfahren wird iterativ ein Näherungswert berechnet.

Die offensichtliche Lösungen, das Gleichungssystem einfach durch invertieren der Matrix zu lösen, sowie die Cramer-Regel sind für große Matrixen unbrauchbar, da sie sehr viel Rechenzeit benötigen.

## Vektor Normen

Eine Vektor Norm besitzt folgende Eigenschaften:

$$
\begin{aligned}
\|x\| \geq 0 &\qquad \text{ (positivität)}\\
\|x\| = 0 & \qquad \text{ (nur wenn } x = 0)\\
\|x+y| \leq |x|+  |y|  &\qquad\text{ (Triangulare Ungleichung)}\\
\|ax\| = |a|\|x\| & \qquad\text{ (Skalierung)}\\
\end{aligned}
$$

Beispiele für Vektor Normen:

$$
\begin{aligned}
\textrm{Euklidische Norm: }\qquad \|x\|_2 &= \sqrt{\sum_{i=1}^n x_i^2}\\
\text{Manhattan Norm: }\qquad \|x\|_1 &= \sum_{i=1}^n |x_i|\\
\text{Maximum Norm: }\qquad \|x\|_\infty &= \max_{i=1,\ldots,n} |x_i|\\
\end{aligned}
$$

## Matrix Normen

Eine Matrix Norm wird von einer Vekor Norm abgeleitet.
Sie wird definiert als:

$$
||A|| = \max_{||x||=1} ||Ax||
$$

Die Kondizionszahl einer Matrix ist definiert als:

$$
\kappa(A) = \frac{\max_{||x||=1} ||Ax||}{\min_{||x||=1} ||Ax||}
$$

Bei einer invertierbaren Matrix ist $\kappa(A) = ||A||\cdot ||A^{-1}||$.

## Kondition Lösen von Gleichungssystemen

Der relative Fehler der Lösung eines Gleichungssystems, bei denen alle relativen Fehler kleiner als $\epsilon$ sind, ist:

$$
\frac{||\delta x||}{||x||} \leq \frac{2\epsilon\kappa(A)}{1-\epsilon\kappa(A)}
$$

Somit wird auch der Fehler sehr schnell groß, wenn die Kondition der Matrix groß ist.

## Das Residuum

Das Residuum ist definiert als $r:=b-A\tilde{x}$. Wobei $\tilde{x}$ die Annäherung von $x$ ist.

Der Fehler hängt nicht umbedingt vom residuum ab.
$\tilde{x}$ kann auch als exakte Lösung von einem gestörten Gleichungssystem verstanden werden.

$$
r = b-A\tilde{x} \iff A\tilde{x} = b - r
$$

## LR-Zerlegung

Ziel: $Ax=b$ zu lösen.

Art: Führe Gauss-Verfahren durch und Speichere die Verwendeten Koeffizienten in einer Matrix $L$ ab.

Speichert man sich die verwendeten Koeffizienten für jede Zeilen-Subtraktion Elementweise in einer neuen Matrix ab erhält man $L$. Zusammen mit $R$, der vom Gausverfahren übriggebliebenen Dreicksmatrix, kann man $A$ mit $A=LR$ wiederherstellen. Man erhält also eine Faktorisierung von $A$.

Dadurch kann man $Ax = LRx = L(Rx) = b$ lösen.

## Cholesky-Zerlegung

Bei der Cholesky-Zerlegung wird eine Matrix $A$ in eine Matrix $L$ und deren Transponierte $L^T$ zerlegt.

Dadurch kann das Gleichungssystem $Ax=b$ mit halber Rechenzeit gelöst werden. Die asymptotische Komplexität ist jedoch immernoch $O(n^3)$.

## Pivotsuche

Bei der Pivotsuche wird die Zeile mit dem größten Element in der Spalte, bzw. der restlichen Matrix gesucht.

Damit kann verhindert werden, dass bei der Berechnung der Zeilensubtraktions-Koeffizienten, durch 0 geteilt wird. Außerdem werden die benötigten Faktoren und Fehler kleiner.

- Partielle Pivotsuche

  - In der Spalte wird nach dem betragsmäßig größten Element gesucht.
  - Die Zeile wird mit der Zeile mit dem größten Element vertauscht.

- Totale Pivotsuche

  - Es wird nach dem größten Element in der gesamten Rest-Matrix gesucht.
  - Es müssen womöglich Zeilen und Spalten vertauscht werden.
    - Dabei müssen auch eventuell die Elemente im Lösungsvektor vertauscht werden.

Die Umordnung der Matrix und der Vektoren ändert nichts an der Lösung des Gleichungssystems.
