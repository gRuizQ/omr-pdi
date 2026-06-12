% ============================================================== % 
% Autores: Antonio Galvão Martins Neto; Gustavo Ruiz de Queiroz  %
% Data: 11/06/2026                                               %
%                                                                %
% UTFPR - Processamento Digital de Imagens                       %
%                                                                %
% Projeto OMR para automação de avaliações de uma ou mais folhas %
% de respostas com base ao um gabarito reservado.                %
%                                                                %
% ============================================================== %

clear;
clc;
close all;

%% Configurações

imagemResposta = "imagens/prova02.jpg";

arquivoGabarito = "gabarito/gabarito.mat";

notaMaxima = 10;

%% Carregar imagem

fprintf('Carregando imagem...\n');

img = imread(imagemResposta);

%% Detectar marcadores fiduciais

fprintf('Detectando marcadores...\n');

marcadores = detectarMarcadores(img);

%% Corrigir perspectiva

fprintf('Corrigindo perspectiva...\n');

imgCorrigida = corrigirPerspectiva(img, marcadores);

%% Localizar bolhas

fprintf('Localizando bolhas...\n');

ROIs = localizarBolhas(imgCorrigida);

%% Ler respostas

fprintf('Lendo respostas...\n');

respostasAluno = lerRespostas(imgCorrigida, ROIs);

%% Carregar gabarito

fprintf('Carregando gabarito...\n');

load(arquivoGabarito,'gabarito','pesos');

%% Avaliar prova

fprintf('Calculando nota...\n');

[nota, acertos, erros] = avaliarProva( ...
    respostasAluno,...
    gabarito,...
    pesos);

%% Exibir resultados

fprintf('\n');
fprintf('=============================\n');
fprintf('RESULTADO\n');
fprintf('=============================\n');
fprintf('Acertos : %d\n', acertos);
fprintf('Erros   : %d\n', erros);
fprintf('Nota    : %.2f\n', nota);
fprintf('=============================\n');

%% Gerar nome do arquivo de resultado

[~, nomeProva, ~] = fileparts(imagemResposta);

arquivoResultado = fullfile( ...
    'resultados', ...
    strcat(nomeProva,'_resultado.mat'));

%% Salvar resultado

resultado.respostas = respostasAluno;
resultado.acertos = acertos;
resultado.erros = erros;
resultado.nota = nota;

save(arquivoResultado,'resultado');

%% Mostrar imagem corrigida

figure;
imshow(imgCorrigida);
title(sprintf('Nota = %.2f',nota));