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

function respostas = lerRespostas(imgCorrigida, ROIs)

% ==============================================================
% Lê as respostas marcadas pelo aluno
%
% Entrada:
%   imgCorrigida
%   ROIs
%
% Saída:
%   respostas(50,1)
%
% ==============================================================

%% Converter para cinza

if size(imgCorrigida,3) == 3
    gray = rgb2gray(imgCorrigida);
else
    gray = imgCorrigida;
end

%% Inicialização
respostas = repmat('-',50,1);
alternativas = ['A' 'B' 'C' 'D' 'E'];

%% Limiares
limiarMarcada = 0.50;
limiarDupla   = 0.80;

%% Processar questões
for q = 1:50
    preenchimento = zeros(1,5);
    for alt = 1:5
        x = ROIs(q,alt).x;
        y = ROIs(q,alt).y;
        w = ROIs(q,alt).w;
        h = ROIs(q,alt).h;

        % Garantir que ROI fique dentro da imagem
        x1 = max(1,x);
        y1 = max(1,y);

        x2 = min(size(gray,2),x+w);
        y2 = min(size(gray,1),y+h);

        roi = gray(y1:y2,x1:x2);

        %% Escurecimento médio
        roiNorm = double(roi)/255;
        preenchimento(alt) = 1 - mean(roiNorm(:));
    end

    %% DEBUG
    fprintf('Q%02d -> ',q);
    fprintf('%.2f ',preenchimento);
    fprintf('\n');

    %% Encontrar alternativa mais escura
    [maiorValor,idx] = max(preenchimento);

    %% Questão em branco
    if maiorValor < limiarMarcada
        respostas(q) = '-';
        continue;
    end

    %% Múltiplas marcações
    candidatos = preenchimento > (maiorValor*limiarDupla);

    if sum(candidatos) > 1
        respostas(q) = 'X';
        continue;
    end

    %% Resposta válida
    respostas(q) = alternativas(idx);
end
end