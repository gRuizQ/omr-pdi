% Autores: Antonio Galvão Martins Neto; Gustavo Ruiz de Queiroz  %
% Data: 11/06/2026                                               %
% UTFPR - Processamento Digital de Imagens                       %

function respostas = lerRespostas(imgCorrigida, ROIs)

% Lê as respostas marcadas pelo aluno
% Entrada:
%   imgCorrigida
%   ROIs
%
% Saída:
%   respostas(50,1)

% conversao para cinza
if size(imgCorrigida,3) == 3
    gray = rgb2gray(imgCorrigida);
else
    gray = imgCorrigida;
end

respostas = repmat('-',50,1);
alternativas = ['A' 'B' 'C' 'D' 'E'];
limiarMarcada = 0.55;
limiarDupla   = 0.90;

% leitura das respostas
for q = 1:50
    preenchimento = zeros(1,5);
    for alt = 1:5
        % define e garante que os rois estejam dentro da imagem
        x = ROIs(q,alt).x;
        y = ROIs(q,alt).y;
        w = ROIs(q,alt).w;
        h = ROIs(q,alt).h;
        x1 = max(1,x);
        y1 = max(1,y);
        x2 = min(size(gray,2),x+w);
        y2 = min(size(gray,1),y+h);
        roi = gray(y1:y2,x1:x2);

        % escurecimento medio
        roiNorm = double(roi)/255;
        preenchimento(alt) = 1 - mean(roiNorm(:));
    end

    fprintf('Q%02d -> ',q);
    fprintf('%.2f ',preenchimento);
    fprintf('\n');

    % seleciona a alternativa mais escura
    [maiorValor,idx] = max(preenchimento);

    % nenhuma alternativa valida
    if maiorValor < limiarMarcada
        respostas(q) = '-';
        continue;
    end

    % mais de uma alternativa marcada
    candidatos = preenchimento > (maiorValor*limiarDupla);
    if sum(candidatos) > 1
        respostas(q) = 'X';
        continue;
    end

    respostas(q) = alternativas(idx);
end
end