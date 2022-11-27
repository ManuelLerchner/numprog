# Floating-Point

## Fixed-Point

### Representation

Bei Fixed-Point wird die Zahl in eine ganze Zahl und eine Bruchzahl aufgeteilt. Diese werden jeweils "normal" kodiert.

- Nachteile:
    - Schneller Overflow, da nur kleine Zahlen dargestellt werden können
    - Konstanter Abstand zwischen zwei Zahlen. Oft nicht benötigt.

## Floating-Point

### Representation

Eine Floating-Point Zahl wird in Mantisse und Exponent aufgeteilt. Zusammen mit einem Vorzeichenbit, lässt sich so ein sehr großer Wertebereich darstellen.

- Definition normalisierte, t-stellige Float-Zahl

- $\mathbb{F}_{B,t} = \{M \cdot B^E \mid M,E \in \mathbb{Z} \land  M \text{ ohne führende Nullen bzw:\ } B^{t-1} \leq M < B^t\}$

- $\mathbb{F}_{B,t,\alpha,\beta} = \{M \cdot B^E \mid M,E \in \mathbb{Z} \And  M \text{ ohne führende Nullen} \land \alpha \leq E < \beta \}$

- Wobei gilt:

- $B$ Basis
    - $t$ Anzahl der Bits
    - $\alpha$ kleinster möglicher Exponent
    - $\beta$ größter möglicher Exponent

- Vorteile:
    - Großer Wertebereich, da variable Abstände zwischen zwei Zahlen

### Kleinste bzw. größte Zahl

In einem solchen System ist:

- $\sigma = B^{t-1} \cdot B^\alpha$ die kleinste positive Zahl, die dargestellt werden kann.
- $\lambda = (B^{t}-1) \cdot B^\beta$ die größte positive Zahl, die dargestellt werden kann.

Beispiel:

- Mit $B=10$ und $t=4$ und $\alpha=-2$ und $\beta=1$ ergibt sich:
    - $\sigma = 10^{4-1} \cdot 10^{-2} = 10$
    - $\lambda = (10^{4}-1) \cdot 10^{1} = 99990$

### Formel zur Berechnung des maximalen relativen Abstands zwei Float-Zahlen

Die Resolution einer Float-Zahl ist der maximale relative Abstand zu einer anderen Float-Zahl. Sie berechnet sich wie folgt:

- $\varrho = \frac{1}{M} \leq B^{1-t}$

Beispiel:

- Mit einer Basis von $B=2$ und $t=4$ Stellen ergibt sich; $\varrho  \leq 2^{-3} = 0.125$. Damit ist der maximale relative Abstand zwischen zwei Float-Zahlen $0.125$.

## Rundung

Da nur eine endliche Anzahl von Float-Zahlen existieren, muss grundsätzlich nach jeder Operation gerundet werden.

Diese Rundungsfunktion wird als `rd(x)` bezeichnet:
Es gilt:

- $rd : \mathbb{R} \rightarrow \mathbb{F}$
- surjektiv: $\forall f \in \mathbb{F}\ \exists x \in \mathbb{R} \Rightarrow rd(x) = f$
- idempotent: $rd(rd(x)) = rd(x)$
- monoton: $x \leq y \Rightarrow rd(x) \leq rd(y)$

### Rundungsmodi

1. Abrunden:
      - $rd_-(x) = f_l(x)$ wobei $f_l(x)$ die nächstkleinere Float-Zahl ist.
2. Aufrunden:
      - $rd_+(x) = f_r(x)$ wobei $f_r(x)$ die nächstgrößere Float-Zahl ist.
3. Abschneiden:

- Rundet immer in Richtung 0.
     - $rd_0(x) = f_-(x)$ wenn $x \geq 0$ und $f_+(x)$ wenn $x \leq 0$.

4. Korrektes Runden:
      - Rundet immer zur nächstgelegenen Float-Zahl.
      - Falls die nächstgelegene Zahl gleich weit entfernt ist, wird die gerade Zahl gewählt.

### Rundungsfehler

Durch jeden Rundungsschritt entsteht zwangsläufig ein Rundungsfehler.

- Absolute Rundungsfehler:
    - $rd(x) - x$
- Relative Rundungsfehler:
    - $\epsilon = \frac{rd(x) - x}{x}$
    - Dieser Rundungsfehler kann bei direktem Runden mit: $|\epsilon| \leq \varrho$ abgeschätzt werden.
    - Beim korekten Runden gilt: $|\epsilon| \leq \frac{1}{2} \cdot \varrho$

Durch diese Konstruktion des relativen Rundungsfehlers, gilt:

- $rd(x) = x * (1 + \epsilon)$

Um die Operationen, welche Rundungsfehler verursachen, von den "sauberen" Operationen zu unterscheiden, wird eine neue Notation eingeführt:

- $a * b$ bezeichnet den Wert der Multiplikation ohne Rundung
- $a \ \dot{*}\ b$ bzw. $rd(a*b)$ bezeichnet den Wert nach der Rundung

Es gibt zwei Möglichkeiten, die entstehenden Rundungsfehler zu modellieren:

1. Als Funktion des exakten Ergebnisses: (Starke Hypothese)

- $a \ \dot{*} \ b = f(a*b) = (a*b) \cdot \epsilon(a,b)$
     - Diese Variante wird von fast allen Systemen unterstützt.

2. Als Funktion der Rundungsfehler der Operanden: (Schwache Hypothese)
      - $a \ \dot{*} \ b = f(a,b) = (a \cdot (1+ \epsilon_1)) * (b \cdot (1+ \epsilon_2))$

Wobei alle $\epsilon$-Werte betragsmäßig durch die Maschinengenauigkeit $\bar{\epsilon}$ begrenzt sind. Diese entspricht je nach verwendetem Rundungsmodus entweder $\varrho$ oder $\frac{1}{2} \cdot \varrho$.

---

**Achtung:**

Die gerundeten Varianten der Operatoren sind nicht mehr assoziativ!

- $(a \ \dot{*} \ b) \ \dot{*} \ c \neq a \ \dot{*} \ (b \ \dot{*} \ c)$

Außerdem findet Absorption statt. Das bedeutet, dass z.B. bei der Subtraktion von ähnlich großen Zahlen, die Anzahl der signifikanten Stellen deutlich abnimmt. Und dadurch ein extrem hoher Rundungsfehler entsteht.

# Fehleranalyse

Es gibt die Möglichkeit der Vorwärts- und Rückwärtsfehleranalyse.

### Vorwärts Fehleranalyse

Hierbei wird das Ergebnis als Funktion des exakten Ergebnisses modelliert.

- $a \ \dot{+} \ b = (a+b) \cdot (1 + \epsilon)$
- $a \ \dot{*} \ b = (a*b) \cdot (1 + \epsilon)$

Diese Modellierung ist einfach, jedoch in der Praxis nur schwer berechenbar, da die Fehler korreliert sind.

### Rückwärts Fehleranalyse

Hierbei wird das Ergebnis als Funktion der Rundungsfehler der Operanden modelliert.

- $a \ \dot{+} \ b = (a \cdot (1 + \epsilon)) + (b \cdot (1 + \epsilon))$
- $a \ \dot{*} \ b = (a \cdot \sqrt{1 + \epsilon}) * (b \cdot \sqrt{1 + \epsilon})$

# Kondition

Die Kondition eines Problems ist ein Maß für die Sensitivität des Problems gegenüber Änderungen der Eingabedaten.
Diese ist unabhänging vom verwendeten Algorithmus.

Ist ein Problem gut konditioniert, so ist es sehr stabil gegenüber kleinen Änderungen der Eingabedaten. Bei solchen Problemen lohnt sich die Verwendung eines guten Algorithmus.

Ist ein Problem schlecht konditioniert, so ist es sehr empfindlich gegenüber kleinen Änderungen der Eingabedaten. Somit hat sogar der bestmögliche Algorithmus keinen signifikanten Einfluss auf die Genauigkeit des Ergebnisses. Da dieses eh durch die Fehlerfortpflanzung dominiert wird.

Man betrachtet wiederum den absoluten und den relativen Fehler:

- $err_{abs}=f(x+\delta x) - f(x)$
- $err_{rel}=\frac{f(x+\delta x) - f(x)}{f(x)}$

Die Konditionszahl wird nun wie folgt definiert:

- $kond_{abs}=\frac{err_{abs}}{\delta x}$
- $kond_{rel}=\frac{err_{rel}}{\frac{\delta x}{x}}$

Im Algemeinen ist die Konditionszahl eines Problems $p(x)$ bei der Eingabe $x$ als:

- $kond(p(x))=\frac{\partial p(x)}{\partial x}$

Laut dieser Definition haben alle Grundrechenarten, außer die Addition / Subtraktion, eine Konditionszahl von ca. 1 und sind somit gut konditioniert.

Die Subtraktion sind schlecht konditioniert, da sie bei ca. gleich großen Zahlen zu einem extremen Rundungsfehler führt.

Beispiele für gute und schlechte Kondition:

- Gut konditionierte Probleme:

- Berechnung der Fläche eines Rechtecks
    - Berechnung von Schnittpunkten fast orthogonalen Geraden

- Schlecht konditionierte Probleme:

- Berechnung von Nullstellen von Polynomen
    - Berechnung von Schnittpunkten zweier fast paralleler Geraden

## Anwendung der Kondition bei konkreten Algorithmen

### Akzeptable Ergebnisse

Ein numerisch akzeptables Ergebnis ist dann gegeben, wenn das berechnete
Ergebnis, auch als exaktes Ergebnis von nur leicht gestörten Eingabedaten
erklärt werden kann.

- $\tilde{y}$ ist akzeptables Ergebnis für $y=f(x)$, wenn $\tilde{y} \in \{ f(\tilde{x}) \mid \tilde{x} \ \text{nahe von x}\}$

### Numerische Stabilität

Ein Algorithmus ist numerisch stabil, wenn für alle erlaubten Eingabedaten
ein _akzeptables_ Ergebnis berechnet wird.

Beispiele:

- Die Grundrechenarten sind numerisch stabil (Basierend auf schwacher Hypothese)
- Die Komposition von numerisch stabilen Algorithmen ist nicht zwingend stabil

Beispiel:

- Numerisch instabil:

- Berechnung der Wurzel als: $x = \sqrt{\left(\frac{p}{2}\right)^2-q}-\frac{p}{2}$

- Numerisch stabil:
    - Berechnung der Wurzel als: $x = \frac{ -q}{\sqrt{\left(\frac{p}{2}\right)^2-q}+\frac{q}{2}}$
