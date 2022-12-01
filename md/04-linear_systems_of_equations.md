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
