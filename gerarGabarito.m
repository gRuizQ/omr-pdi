%% gerarGabarito.m
% Gera 4 gabaritos (A, B, C, D) com alternativas embaralhadas

clear;
clc;

%% Gabarito base das 50 questões (Tipo A - original)
gabarito = [ ...
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'];

%% Peso de cada questão
pesos = ones(50,1);

%% Gerar 4 gabaritos com shift de alternativas
% A: original, B: shift +1, C: shift +2, D: shift +3
alternativas = ['A','B','C','D','E'];

% Função para shift circular nas alternativas
shiftAlt = @(c, n) alternativas(mod(find(alternativas == c) - 1 + n, 5) + 1);

%% Salvar gabarito A (original)
gabarito_A = gabarito;
save('gabarito/gabarito_A.mat', 'gabarito_A', 'pesos');

%% Salvar gabarito B (shift +1)
gabarito_B = arrayfun(@(c) shiftAlt(c, 1), gabarito);
save('gabarito/gabarito_B.mat', 'gabarito_B', 'pesos');

%% Salvar gabarito C (shift +2)
gabarito_C = arrayfun(@(c) shiftAlt(c, 2), gabarito);
save('gabarito/gabarito_C.mat', 'gabarito_C', 'pesos');

%% Salvar gabarito D (shift +3)
gabarito_D = arrayfun(@(c) shiftAlt(c, 3), gabarito);
save('gabarito/gabarito_D.mat', 'gabarito_D', 'pesos');

fprintf('Gabaritos gerados com sucesso!\n');
fprintf('  - gabarito_A.mat (original)\n');
fprintf('  - gabarito_B.mat (shift +1)\n');
fprintf('  - gabarito_C.mat (shift +2)\n');
fprintf('  - gabarito_D.mat (shift +3)\n');
