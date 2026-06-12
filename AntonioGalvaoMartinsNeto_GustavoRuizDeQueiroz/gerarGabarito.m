%% gerarGabarito.m

clear;
clc;

%% Gabarito das 50 questões

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

%% Salvar

save('gabarito/gabarito.mat',...
     'gabarito',...
     'pesos');

fprintf('gabarito.mat criado com sucesso!\n');