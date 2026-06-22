% Autores: Antonio Galvão Martins Neto; Gustavo Ruiz de Queiroz  %
% Data: 11/06/2026                                               %
% UTFPR - Processamento Digital de Imagens                       %

clear;
clc;
close all;

imagemResposta = "imagens/provaA-horizontal.jpeg";
notaMaxima = 10;

run('gerarGabarito.m');

% carrega imagem | detectar marcadores | corrigir perspectiva
fprintf('Carregando imagem...\n');
img = imread(imagemResposta);
marcadores = detectarMarcadores(img);
imgCorrigida = corrigirPerspectiva(img, marcadores);
tipoProva = lerTipo(imgCorrigida);

if tipoProva == '?'
    error('Não foi possível detectar o tipo de prova. Verifique se o campo está preenchido.');
end

% carrega gabarito
arquivoGabarito = sprintf("gabarito/gabarito_%c.mat", tipoProva);
fprintf('Carregando gabarito: %s\n', arquivoGabarito);
load(arquivoGabarito, sprintf('gabarito_%c', tipoProva), 'pesos');
varName = sprintf('gabarito_%c', tipoProva);
gabarito = eval(varName);

% leitura e avaliacao da prova
ROIs = localizarBolhas(imgCorrigida);
respostasAluno = lerRespostas(imgCorrigida, ROIs);
[nota, acertos, erros] = avaliarProva( ...
    respostasAluno,...
    gabarito,...
    pesos);

% resultados
fprintf('\n');
fprintf('=============================\n');
fprintf('RESULTADO\n');
fprintf('=============================\n');
fprintf('Tipo    : %c\n', tipoProva);
fprintf('Acertos : %d\n', acertos);
fprintf('Erros   : %d\n', erros);
fprintf('Nota    : %.2f\n', nota);
fprintf('=============================\n');

% gera arquivo de resultado
[~, nomeProva, ~] = fileparts(imagemResposta);

arquivoResultado = fullfile( ...
    'resultados', ...
    strcat(nomeProva,'_resultado.mat'));

resultado.respostas = respostasAluno;
resultado.tipoProva = tipoProva;
resultado.acertos = acertos;
resultado.erros = erros;
resultado.nota = nota;

save(arquivoResultado,'resultado');

figure;
imshow(imgCorrigida);
title(sprintf('Tipo %c | Nota = %.2f', tipoProva, nota));