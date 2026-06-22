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
notaMaxima = 10;

%% Gerar gabaritos (executa gerarGabarito.m para atualizar os .mat)
run('gerarGabarito.m');

%% Restaurar variáveis apagadas pelo gerarGabarito.m
imagemResposta = "imagens/prova02.jpg";
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

%% Detectar tipo de prova
fprintf('Detectando tipo de prova...\n');
tipoProva = lerTipo(imgCorrigida);

if tipoProva == '?'
    error('Não foi possível detectar o tipo de prova. Verifique se o campo está preenchido.');
end

%% Carregar gabarito correspondente
arquivoGabarito = sprintf("gabarito/gabarito_%c.mat", tipoProva);
fprintf('Carregando gabarito: %s\n', arquivoGabarito);

load(arquivoGabarito, sprintf('gabarito_%c', tipoProva), 'pesos');

% Acessar a variável dinamicamente
varName = sprintf('gabarito_%c', tipoProva);
gabarito = eval(varName);

%% Localizar bolhas
fprintf('Localizando bolhas...\n');
ROIs = localizarBolhas(imgCorrigida);

%% Ler respostas
fprintf('Lendo respostas...\n');
respostasAluno = lerRespostas(imgCorrigida, ROIs);

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
fprintf('Tipo    : %c\n', tipoProva);
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
resultado.tipoProva = tipoProva;
resultado.acertos = acertos;
resultado.erros = erros;
resultado.nota = nota;

save(arquivoResultado,'resultado');

%% Mostrar imagem corrigida
figure;
imshow(imgCorrigida);
title(sprintf('Tipo %c | Nota = %.2f', tipoProva, nota));
