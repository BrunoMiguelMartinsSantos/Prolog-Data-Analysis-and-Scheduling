:- encoding(utf8).
% ist1118057 - Bruno Miguel Martins dos Santos
:- style_check(-discontiguous).   % para nao se queixar descontinuidade da BD
:- set_prolog_flag(answer_write_options,[max_depth(0)]).  % ver listas completas
:- ['codigoAuxiliar'].       % Ficheiro dado
:- ['bd_estudantes'].        % Ficheiro dado
:- ['listas_palavras'].      % Ficheiro dado
% O teu código deve começar na próxima linha
% Parte 1
% media(ListaValores, Media): Calcula a média de uma lista numérica. 
% Se a lista for [], média = 0.
% Ex.: ?- media([1,2,4,6], M). dá M = 3.25.
media([], 0) :- !.
media(ListaValores, Media) :-
    sum_list(ListaValores, Soma),
    length(ListaValores, Comprimento),
    M is Soma/Comprimento,
    arredonda(M, Media).

% mediaNotasPorIdade(IdadeMin, IdadeMax, Media):
% Recolhe todas as notas dos estudantes com:
% IdadeMin < idade =< IdadeMax e calcula a média. 
% Ex.: ?- mediaNotasPorIdade(16, 18, Media). dá Media = 69.87.
mediaNotasPorIdade(IdadeMin, IdadeMax, Media) :-
    findall(Nota,
        (estudante(Id, Idade, _),
        Idade > IdadeMin,
        Idade =< IdadeMax,
        exame(Id, Nota)),
        ListaNotas),
    media(ListaNotas, Media).

% freqPorGenero(Genero, MediaFreq): 
% Média da frequência das aulas dos alunos de um género.
% Ex.: ?- freqPorGenero(feminino, Media). dá Media = 84.70.
freqPorGenero(Genero, MediaFreq) :-
    findall(Frequencia,
        (estudante(Id, _, Genero),
        atividade(Id, _, _, Frequencia)), 
        ListaFreqs),
    media(ListaFreqs, MediaFreq).

% alertaSaude(HorasSono, Exercicio, SaudeMental, ListaAlunos):
% Lista ordenada dos alunos com alimentação fraca, que dormem menos de HorasSono,
% exercício físico < Exercicio e saúde mental < SaudeMental.
% Ex.: ?- alertaSaude(6, 3, 5, ListaAlunos). dá ListaAlunos = [s1067,s1212,s1348,s1598].
alertaSaude(HorasSono, Exercicio, SaudeMental, ListaAlunos) :-
    findall(Id,
            (saude(Id, HorasSono_2, fraca, ExercicioFisico, SaudeMental_2),
             HorasSono_2 < HorasSono,
             ExercicioFisico < Exercicio,
             SaudeMental_2 < SaudeMental),
            Lista_Ids),
    sort(Lista_Ids, ListaAlunos).

% probEcraNotasAltas(HorasEcra, Nota, Probabilidade):
% Probabilidade aproximada de ter nota > Nota, sabendo que horas de ecrã > HorasEcra.
% Ex.: ?- probEcraNotasAltas(4, 80, Probabilidade). dá Probabilidade = 0.21.
probEcraNotasAltas(HorasEcra, Nota, Probabilidade) :-
    findall(Id,
            (atividade(Id, _, HorasEcr, _),
             HorasEcr > HorasEcra),
             ListaB),
    length(ListaB, TotalB),
    findall(Id,
            (member(Id,ListaB),
             exame(Id, NotaExame),
             NotaExame > Nota),
            ListaAB),
    length(ListaAB, TotalAB),
    Prob is TotalAB / TotalB,
    arredonda(Prob, Probabilidade).

% subtraiValorDeLista(Lista, Valor, Resultado):
% Transforma a lista subtraindo Valor a cada elemento.
% Ex.: ?- subtraiValorDeLista([2,7,8,1], 4, Resultado). dá Resultado = [-2,3,4,-3].
subtraiValorDeLista([], _, []).
subtraiValorDeLista([X|T], Valor, [Y|Resto]) :-
    Y is X - Valor,
    subtraiValorDeLista(T, Valor, Resto).

% somaQuadrados(Lista, Resultado) : Soma os quadrados dos elementos da lista.
% Ex.: ?- somaQuadrados([2, 7, 8, 1], Resultado).  dá Resultado = 118.
somaQuadrados([], 0).
somaQuadrados([X|T], Resultado) :-
    somaQuadrados(T, ResultadoParcial),
    Resultado is ResultadoParcial + X*X.

% produtoEscalar(Lista1, Lista2, Resultado): 
% Calcula o produto escalar entre duas listas
% (multiplica elementos da mesma posição e soma).
% Falha se as listas não tiverem o mesmo tamanho.
% Ex.: ?- produtoEscalar([2, 4, 6], [1, 2, 3], Resultado). dá Resultado = 28.
produtoEscalar([], [], 0).
produtoEscalar([X|T1], [Y|T2], Resultado) :-
    produtoEscalar(T1, T2, ResultadoParcial),
    Resultado is ResultadoParcial + X*Y.

% correlacao(Lista1, Lista2, ResultadoFinal):
% Calcula o Coeficiente de Correlação entre os valores das listas Lista1 e Lista2.
% Ex.: ?- correlacao([1,2,3], [60,70,90], Resultado). dá Resultado = 0.98.
correlacao([], [], 0).
correlacao(Lista1, Lista2, ResultadoFinal) :-
    media(Lista1, Media1),
    media(Lista2, Media2), 
    subtraiValorDeLista(Lista1, Media1, ListaMenosMedia1),
    subtraiValorDeLista(Lista2, Media2, ListaMenosMedia2),
    produtoEscalar(ListaMenosMedia1,ListaMenosMedia2, ResultadoNumerador),
    somaQuadrados(ListaMenosMedia1, Soma1),
    somaQuadrados(ListaMenosMedia2, Soma2),
    ResultadoDenominador is sqrt(Soma1 * Soma2),
    Resultado is ResultadoNumerador/ResultadoDenominador,
    arredonda(Resultado, ResultadoFinal).

% Parte 2
% tamanho(Palavra, Tamanho): Calcula o número de caracteres de uma string.
tamanho(Palavra, Tamanho) :-
    string_chars(Palavra, ListaCaracteres),
    length(ListaCaracteres, Tamanho).    

% verificaECalcula(Palavra1, Palavra2, CaracteresPalavra1, CaracteresPalavra2):
% Verifica se duas palavras têm o mesmo tamanho.
verificaECalcula(Palavra1, Palavra2, CaracteresPalavra1, CaracteresPalavra2) :-
    tamanho(Palavra1, Tamanho),
    tamanho(Palavra2, Tamanho),
    string_chars(Palavra1, CaracteresPalavra1),
    string_chars(Palavra2, CaracteresPalavra2).

% quantasN(Id, N, Quantas): 
% Conta palavras com tamanho N para um Id.
% Ex.: ?- quantasN(mini, 7, Quantas). dá Quantas = 3.
quantasN(Id, N, Quantas) :-
    lista_palavras(Id, Lista),
    findall(Palavra,
        (member(Palavra, Lista),
        tamanho(Palavra, N)),
        Palavras),
    length(Palavras, Quantas).

% quantasC(Id, C, Quantas):
% Conta palavras cujo primeiro caracter é C para um Id.
% Ex.: ?- quantasC(mini, f, Quantas). dá Quantas = 1
quantasC(Id, C, Quantas) :-
    lista_palavras(Id, Lista),
    findall(Palavra,
        (member(Palavra, Lista),
        string_chars(Palavra, [C|_])), % verifica se a palavra começa pelo carácter C.
        Palavras),
    length(Palavras, Quantas).

% apagaElemento(Elemento, Lista1, Lista2):
% Remove a primeira ocorrência do elemento E da lista Lista1, obtendo Lista2.
% Ex.: ?- apagaElemento(8, [2,8,3,8,4], L). dá L = [2,3,8,4]
apagaElemento(_, [], []).
apagaElemento(E, [E|T], T) :- !.
apagaElemento(E, [H|T1], [H|T2]) :-
    apagaElemento(E, T1, T2).  

% posicoesPalavra(Palavra, Posicoes):
% Associa a cada letra da palavra Palavra a sua posição na palavra
% e devolve a lista desses pares, ordenada.
% Ex.: ?- posicoesPalavra(batata, Posicoes).
%      Posicoes = [(a,2),(a,4),(a,6),(b,1),(t,3),(t,5)].
posicoesPalavra(Palavra, Posicoes) :- 
    string_chars(Palavra, Letras),
    findall((Letra, Posicao),
        nth1(Posicao, Letras, Letra),
        Pares),
    sort(Pares, Posicoes).

% pista1(Palavra1, Palavra2, Pista) : 
% Verdadeiro se Pista é uma lista de 0 ou 2 com:
% - 2 na posição i, se os caracteres de Palavra1 e Palavra2 forem iguais nessa posição
% - 0 na posição i, caso contrário
% Ex.: ?- pista1(lara, pera, L). dá L = [0,0,2,2].
pista1(Palavra1, Palavra2, Pista) :-
    verificaECalcula(Palavra1, Palavra2, L1, L2),
    pista1_aux(L1, L2, Pista).

% pista1_aux(Lista1, Lista2, Pista):
% Percorre as duas listas em paralelo e constrói a pista.
pista1_aux([], [], []).
pista1_aux([H1|T1], [H2|T2], [2|R]) :-
    H1 == H2, !,
    pista1_aux(T1, T2, R).
pista1_aux([_|T1], [_|T2], [0|R]) :-
    pista1_aux(T1, T2, R).

% pista2(Palavra1, Palavra2, Pista):
% Verdadeiro se Pista é uma lista de 0/1/2:
% - 2 se a letra for igual na mesma posição em Palavra1 e Palavra2
% - 1 se a letra de Palavra2 (na posição i) existir algures em Palavra1,
%   mas não estiver na posição certa
% - 0 caso contrário
% Ex.: ?- pista2(ramal, arara, L). dá L = [1,1,1,1,1].
pista2(Palavra1, Palavra2, Pista) :-
    verificaECalcula(Palavra1, Palavra2, L1, L2),
    pista2_aux(L1, L2, L1, Pista).

% pista2_aux(Lista1, Lista2, Lista1Original, Pista):
% Verdadeiro se Pista é a lista que resulta da comparação, posição a posição,
% entre Lista1 (Palavra1) e Lista2 (Palavra2), tal que:
% - Pista contém 2 na posição i se o carácter da Palavra1 e o da Palavra2
%   forem iguais nessa posição.
% - Pista contém 1 na posição i se o carácter da Palavra2 na posição i
%   for diferente do carácter da Palavra1 nessa posição, 
%   mas existir algures na Palavra1.
% - Pista contém 0 na posição i em todos os outros casos.
pista2_aux([], [], _, []).
pista2_aux([H1|T1], [H2|T2], L1, [2|R]) :-
    H1 == H2, !,
    pista2_aux(T1, T2, L1, R).
pista2_aux([H1|T1], [H2|T2], L1, [1|R]) :-
    H1 \== H2,
    member(H2, L1), !,
    pista2_aux(T1, T2, L1, R).
pista2_aux([_|T1], [_|T2], L1, [0|R]) :-
    pista2_aux(T1, T2, L1, R). 

% pista3(Palavra1, Palavra2, Pista):
% Palavra1: Mistério , Palavra2: Palpite
% Verdadeiro se Pista é uma lista de 0/1/2 com o mesmo comprimento das palavras,tal que:
% - 2 na posição i se Palavra1 e Palavra2 têm o mesmo carácter na posição i;
% - 1 na posição i se o carácter de Palavra2 na posição i é diferente,
%   mas ocorre em Palavra1 noutra posição, 
%   respeitando o número de ocorrências ainda disponíveis
% - 0 caso contrário.
% ?- pista3(babaa, aabca, L). dá L = [1,2,2,0,2].
pista3(Palavra1, Palavra2, Pista) :-
    verificaECalcula(Palavra1, Palavra2, L1, L2),
    marca_2(L1, L2, Parcial, Disponiveis),
    marca_1_0(L2, Parcial, Disponiveis, Pista).

% marca_2(Lista1, Lista2, Parcial, Disponiveis):
% Percorre as palavras:
% - se a letra coincide na mesma posição: 
%   coloca 2 em Parcial e nao adiciona essa letra a Disponiveis
% - se não coincide: coloca 'x' em Parcial e guarda a letra de Lista1 em Disponiveis
marca_2([], [], [], []).
marca_2([C|T1], [C|T2], [2|R], Disp) :-  % letra certa na posição certa
    !, % impede tentar a cláusula seguinte
    marca_2(T1, T2, R, Disp).
marca_2([C1|T1], [_|T2], [x|R], [C1|DispResto]) :-  % posição errada
    marca_2(T1, T2, R, DispResto).

% marca_1_0(Tentativa, Parcial, Disponiveis, PistaFinal):
% Verdadeiro se PistaFinal for obtida ao substituir os 'x' da pista parcial
% por 1 (a letra da tentativa existe na lista de letras disponíveis)
% ou por 0 (a letra não existe ou já foi utilizada).
% Cada letra usada para atribuir um 1 é removida de Disponiveis,
% garantindo que cada ocorrência é contabilizada apenas uma vez.
marca_1_0([], [], _, []).
marca_1_0([_|T2], [2|ParcialR], Disp, [2|R]) :-     % já era 2, mantém
    marca_1_0(T2, ParcialR, Disp, R).
marca_1_0([C2|T2], [x|ParcialR], DispAntes, [1|R]) :-   % pode ser 1
    member(C2, DispAntes), !,
    apagaElemento(C2, DispAntes, DispDepois),
    marca_1_0(T2, ParcialR, DispDepois, R).
marca_1_0([_|T2], [x|ParcialR], Disp, [0|R]) :- 
    marca_1_0(T2, ParcialR, Disp, R). 

% Parte 3
% maratonaFilmes(ListaFilmes, ListaRestricoes, Programacao): 
% Gera todas as programações(listas de7) e filtra as que respeitam todas as restrições.
% Se houver menos de 7 filmes, completa com 'empty' até perfazer 7.
% Ex.: ?- maratonaFilmes([f1, f2, f3, f4, f5], [soPode(f1, 1), seguido(f1, f2),
%         terror(f3), soPode(f4, 7), naoSeguido(f4, f3), nunca(f5, 6)], Programacao).
% Programacao = [[f1,f2,empty,f3,f5,empty,f4], [f1,f2,f3,empty,f5,empty,f4],
% [f1,f2,f3,f5,empty,empty,f4], [f1,f2,f5,f3,empty,empty,f4]].
maratonaFilmes(ListaFilmes, ListaRestricoes, Programacao) :-
    completar_para_7(ListaFilmes, Filmes7),
    findall(Prog, 
        (permutation(Filmes7, Prog), % gera todas as possíveis ordens dos filmes
        programacao_respeita(ListaRestricoes, Prog)),
        Validas),  
    sort(Validas, Programacao).

% completar_para_7(Filmes, Filmes7):
% Completa a lista de filmes com 'empty' até ter exatamente 7 elementos.
% Se a lista já tiver 7 elementos, mantém-se inalterada.
completar_para_7(Filmes, Filmes7) :-
    length(Filmes, N),
    N =< 7,
    Faltam is 7 - N, % calcula quantos filmes faltam
    length(Empties, Faltam),  % cria uma lista com Faltam posições vazias
    maplist(=(empty), Empties),  % preenche essas posições com 'empty'
    append(Filmes, Empties, Filmes7).

% programacao_respeita(Restricoes, Programacao):
% Verdadeiro se a Programacao respeitar todas as restrições fornecidas.
programacao_respeita(Restricoes, Programacao) :-
    maplist(respeita(Programacao), Restricoes).  

% respeita(Programacao, soPode(Filme, Sessao)):
% Verdadeiro se o filme Filme estiver exatamente na sessão Sessao.
respeita(Programacao, soPode(Filme, Sessao)) :- 
    nth1(Sessao, Programacao, Filme).

% respeita(Programacao, nunca(Filme, Sessao)): 
% Verdadeiro se o filme Filme não estiver na sessão Sessao.
respeita(Programacao, nunca(Filme, Sessao)) :- 
    \+ nth1(Sessao, Programacao, Filme).

% respeita(Programacao, seguido(Filme1, Filme2)):
% Verdadeiro se Filme2 surgir imediatamente a seguir a Filme1 na Programacao.
respeita(Programacao, seguido(Filme1, Filme2)) :- 
    nextto(Filme1, Filme2, Programacao).

% respeita(Programacao, naoSeguido(Filme1, Filme2)):
% Verdadeiro se Filme1 e Filme2 não surgirem consecutivamente,
% em nenhuma das duas ordens, na Programacao.
respeita(Programacao, naoSeguido(Filme1, Filme2)) :-
    \+ nextto(Filme1, Filme2, Programacao),
    \+ nextto(Filme2, Filme1, Programacao).

% respeita(Programacao, antes(Filme1, Filme2)):
% Verdadeiro se Filme1 surgir numa sessão anterior à de Filme2.
respeita(Programacao, antes(Filme1, Filme2)) :-
    nth1(Pos1, Programacao, Filme1),
    nth1(Pos2, Programacao, Filme2),
    Pos1 < Pos2.

% respeita(Programacao, terror(Filme)):
% Verdadeiro se o filme de terror estiver apenas em sessões a partir das 20h,
% ou seja, nas sessões 3, 4 ou 7.
respeita(Programacao, terror(Filme)) :-
   nth1(Pos, Programacao, Filme),
   member(Pos, [3, 4, 7]).