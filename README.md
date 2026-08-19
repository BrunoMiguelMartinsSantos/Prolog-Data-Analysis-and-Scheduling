# Logic Programming in Prolog

A collection of **logic programming problems implemented in Prolog**, covering data analysis, list processing, word comparison algorithms and constraint-based scheduling.

The project explores the declarative programming paradigm through three main components:

1. statistical analysis of student data
2. word-processing and clue-generation algorithms
3. constraint-based scheduling of a movie marathon

The implementation makes extensive use of **recursion, predicates, list manipulation, higher-order operations and logical search**.

## Overview

The project is divided into three independent sections, each focused on different applications of Prolog.

```text
Project
│
├── Part 1 — Student Data Analysis
│
├── Part 2 — Word Processing & Clue Generation
│
└── Part 3 — Movie Marathon Scheduling
```

---

## Part 1 — Student Data Analysis

The first part performs statistical analysis over a database containing information about students, exams, activities and health-related indicators.

### Average Calculation

A generic predicate computes the arithmetic mean of a list of numerical values.

```prolog
media(ListaValores, Media)
```

Example:

```prolog
?- media([1,2,4,6], M).
M = 3.25.
```

---

### Exam Performance by Age

The system can calculate the average exam grade of students within a specified age interval.

```prolog
mediaNotasPorIdade(IdadeMin, IdadeMax, Media)
```

Student grades are collected dynamically using `findall/3` and then processed to obtain the average.

---

### Class Attendance by Gender

The project also analyses average class attendance according to student gender.

```prolog
freqPorGenero(Genero, MediaFreq)
```

This demonstrates how Prolog can query relational data and aggregate results from multiple facts.

---

### Health Risk Detection

A predicate identifies students that satisfy several health-risk conditions simultaneously.

The criteria include:

* weak diet
* insufficient sleep
* low physical exercise
* low mental-health score

```prolog
alertaSaude(HorasSono, Exercicio, SaudeMental, ListaAlunos)
```

The resulting student identifiers are returned in sorted order.

---

### Conditional Probability

The system estimates the probability that a student achieves a grade above a given threshold when their daily screen time exceeds a specified value.

```prolog
probEcraNotasAltas(HorasEcra, Nota, Probabilidade)
```

This involves:

1. identifying students satisfying the screen-time condition
2. selecting those whose exam grades exceed the threshold
3. calculating the ratio between both groups

---

### Correlation

The project implements a correlation coefficient calculation between two numeric datasets.

Supporting predicates include:

```prolog
subtraiValorDeLista/3
somaQuadrados/2
produtoEscalar/3
correlacao/3
```

The correlation calculation follows the general structure:

```text
             Σ((Xi - X̄)(Yi - Ȳ))
r = ─────────────────────────────────
      √(Σ(Xi - X̄)² × Σ(Yi - Ȳ)²)
```

This section combines recursive list processing with numerical computation.

---

## Part 2 — Word Processing & Clue Generation

The second part focuses on manipulating words represented as strings and lists of characters.

It includes functionality for:

* measuring word length
* filtering words by size
* filtering words by first character
* removing list elements
* identifying character positions
* generating comparison clues between words

---

### Word Statistics

The following predicates analyse collections of words:

```prolog
quantasN(Id, N, Quantas)
```

Counts how many words have length `N`.

```prolog
quantasC(Id, C, Quantas)
```

Counts how many words begin with character `C`.

---

### Character Positions

The predicate:

```prolog
posicoesPalavra(Palavra, Posicoes)
```

associates each character with its position in the word.

Example:

```prolog
?- posicoesPalavra(batata, Posicoes).

Posicoes =
[(a,2),(a,4),(a,6),(b,1),(t,3),(t,5)].
```

---

## Word-Clue System

Three increasingly sophisticated word-comparison predicates are implemented.

The idea is similar to the feedback mechanism used in word-guessing games.

The values used are:

```text
2 -> correct character in the correct position
1 -> character exists but is in another position
0 -> character is not available
```

---

### Clue 1

```prolog
pista1(Palavra1, Palavra2, Pista)
```

This first version checks only whether characters match in the same position.

Example:

```prolog
?- pista1(lara, pera, L).

L = [0,0,2,2].
```

---

### Clue 2

```prolog
pista2(Palavra1, Palavra2, Pista)
```

This version distinguishes between:

* correct characters in the correct position
* characters appearing elsewhere in the target word
* characters not present in the word

Example logic:

```text
Target:    r a m a l
Guess:     a r a r a
           ↓ ↓ ↓ ↓ ↓
Clue:      1 1 1 1 1
```

---

### Clue 3 — Duplicate-Aware Matching

```prolog
pista3(Palavra1, Palavra2, Pista)
```

The third version handles repeated characters correctly.

A character can only be marked as present if an unused occurrence of that character remains available in the target word.

The algorithm is performed in two stages:

```text
Target Word
     │
     ▼
Mark exact matches
     │
     ▼
Store unmatched characters
     │
     ▼
Process remaining guess characters
     │
     ├── available -> 1
     │
     └── unavailable -> 0
     ▼
Final clue
```

Supporting predicates include:

```prolog
marca_2/4
marca_1_0/4
apagaElemento/3
```

Example:

```prolog
?- pista3(babaa, aabca, L).

L = [1,2,2,0,2].
```

This prevents duplicate letters from being counted more times than they appear in the target word.

---

## Part 3 — Movie Marathon Constraint Solver

The final part uses Prolog's search capabilities to solve a **constraint-satisfaction problem**.

The objective is to create a valid schedule of up to seven movies while satisfying a set of restrictions.

```prolog
maratonaFilmes(ListaFilmes, ListaRestricoes, Programacao)
```

If fewer than seven movies are provided, the remaining sessions are automatically filled with:

```prolog
empty
```

---

## Supported Constraints

The scheduler supports several types of logical restrictions.

### Fixed Session

```prolog
soPode(Filme, Sessao)
```

The movie must appear in exactly that session.

---

### Forbidden Session

```prolog
nunca(Filme, Sessao)
```

The movie cannot appear in the specified session.

---

### Consecutive Movies

```prolog
seguido(Filme1, Filme2)
```

`Filme2` must appear immediately after `Filme1`.

---

### Non-Consecutive Movies

```prolog
naoSeguido(Filme1, Filme2)
```

The two movies cannot appear consecutively in either order.

---

### Ordering Constraint

```prolog
antes(Filme1, Filme2)
```

`Filme1` must appear in an earlier session than `Filme2`.

---

### Horror Movie Constraint

```prolog
terror(Filme)
```

Horror movies can only appear in specific later sessions:

```text
Session 3
Session 4
Session 7
```

---

## Constraint Solving Process

The scheduler works by generating possible permutations and validating each one against all supplied restrictions.

```text
Movie List
    │
    ▼
Complete to 7 sessions
    │
    ▼
Generate permutations
    │
    ▼
Check every constraint
    │
    ├── invalid -> discard
    │
    └── valid   -> keep
    ▼
Valid schedules
```

Restrictions are checked using a generic predicate:

```prolog
respeita(Programacao, Restricao)
```

This allows different constraint types to be handled through Prolog's pattern matching and predicate dispatch.

---

## Main Predicates

### Data Analysis

```text
media/2
mediaNotasPorIdade/3
freqPorGenero/2
alertaSaude/4
probEcraNotasAltas/3
subtraiValorDeLista/3
somaQuadrados/2
produtoEscalar/3
correlacao/3
```

### Word Processing

```text
tamanho/2
quantasN/3
quantasC/3
apagaElemento/3
posicoesPalavra/2
pista1/3
pista2/3
pista3/3
```

### Constraint Solving

```text
maratonaFilmes/3
completar_para_7/2
programacao_respeita/2
respeita/2
```

---

## Prolog Concepts Used

The project explores several important logic-programming concepts:

* declarative programming
* facts and predicates
* unification
* backtracking
* recursion
* pattern matching
* list decomposition
* logical negation
* cuts (`!`)
* higher-order predicates
* search and permutation generation
* constraint validation
* aggregation of query results

Several built-in predicates are used throughout the implementation, including:

```prolog
findall/3
member/2
length/2
sort/2
nth1/3
nextto/3
maplist/2
permutation/2
append/3
```

---

## Project Structure

```text
.
├── Projeto_Prolog.pl
├── codigoAuxiliar.pl
├── bd_estudantes.pl
└── listas_palavras.pl
```

`Projeto_Prolog.pl` contains the implemented predicates.

The remaining files provide auxiliary functionality and datasets used by the project.

---

## Technologies & Concepts

* **Prolog**
* Logic Programming
* Declarative Programming
* Recursion
* Backtracking
* List Processing
* Pattern Matching
* Higher-Order Predicates
* Data Analysis
* Correlation
* String Processing
* Search Algorithms
* Constraint Satisfaction
* Combinatorial Search

---

## Key Technical Highlights

The project demonstrates:

* relational querying over structured student data
* statistical calculations implemented through logical predicates
* recursive numerical list processing
* implementation of a correlation coefficient
* recursive string and character processing
* Wordle-like clue generation
* correct handling of repeated characters
* permutation-based search
* flexible constraint representation
* use of Prolog's native backtracking and unification mechanisms

---

## Academic Context

Developed as an academic **Logic Programming project at Instituto Superior Técnico (IST)**.

The project demonstrates how the Prolog programming paradigm can be applied to very different problems, from statistical data analysis and word-processing algorithms to combinatorial scheduling and constraint satisfaction.
