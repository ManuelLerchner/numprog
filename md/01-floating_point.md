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

  - $\mathbb{F}_{B,t} = \{M \cdot B^E \mid M,E \in \mathbb{Z} \land  M \text{ ohne führende Nullen bzw:\ } B^{t-1} \leq M < B^t\}$

  - $\mathbb{F}_{B,t,\alpha,\beta} = \{M \cdot B^E \mid M,E \in \mathbb{Z} \And  M \text{ ohne führende Nullen} \land \alpha \leq E < \beta \}$

- Wobei gilt:

  - $B$ Basis
  - $t$ Anzahl der Bits
  - $\alpha$ kleinster möglicher Exponent
  - $\beta$ größter möglicher Exponent

- Vorteile:
  - Großer Wertebereich, da variable Abstände zwischen zwei Zahlen

In einem solchen System ist:

- $\sigma = B^{t-1} \cdot B^\alpha$ die kleinste positive Zahl, die dargestellt werden kann.
- $\lambda = (B^{t}-1) \cdot B^\beta$ die größte positive Zahl, die dargestellt werden kann.

Beispiel:

- Mit $B=10$ und $t=4$ und $\alpha=-2$ und $\beta=1$ ergibt sich:
  - $\sigma = 10^{4-1} \cdot 10^{-2} = 10$
  - $\lambda = (10^{4}-1) \cdot 10^{1} = 99990$


### Formel zur Berechnung des maximalen relativen Abstands zwei Float-Zahlen

Die Resoluition einer Float-Zahl ist der maximale relative Abstand zu einer anderen Float-Zahl. Sie berechnet sich wie folgt:

- $\varrho = \frac{1}{M} \leq B^{1-t}$

Beispiel:

- Mit einer Basis von $B=2$ und $t=4$ Stellen ergibt sich; $\varrho  \leq 2^{-3} = 0.125$. Damit ist der maximale relative Abstand zwischen zwei Float-Zahlen $0.125$.
