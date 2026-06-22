% Autores: Antonio Galvão Martins Neto; Gustavo Ruiz de Queiroz  %
% Data: 11/06/2026                                               %
% UTFPR - Processamento Digital de Imagens                       %

% Entrada:
%   imgCorrigida - imagem já corrigida geometricamente
%
% Saída:
%   tipoProva - 'A', 'B', 'C', 'D' ou '?' se não detectado

function tipoProva = lerTipo(imgCorrigida)

% converte para cinza
if size(imgCorrigida,3) == 3
    gray = rgb2gray(imgCorrigida);
else
    gray = imgCorrigida;
end

load('layoutFR.mat','tipoROI');

[h,w,~] = size(imgCorrigida);
larguraRef = 2100;
alturaRef  = 2970;
sx = w/larguraRef;
sy = h/alturaRef;

% ajusta a regiao de interesse com base no tamanho/tipo de imagem
ROIsTipo = tipoROI;
for alt = 1:4
    ROIsTipo(alt).x = round(tipoROI(alt).x * sx * 10);
    ROIsTipo(alt).y = round((297 - tipoROI(alt).y) * sy * 10) - 50;
    ROIsTipo(alt).w = round(tipoROI(alt).w * sx * 10);
    ROIsTipo(alt).h = round(tipoROI(alt).h * sy * 10);
end

% verifica o tipo de prova
preenchimento = zeros(1,4);
for alt = 1:4
    x = ROIsTipo(alt).x;
    y = ROIsTipo(alt).y;
    w = ROIsTipo(alt).w;
    h = ROIsTipo(alt).h;

    x1 = max(1,x);
    y1 = max(1,y);
    x2 = min(size(gray,2),x+w);
    y2 = min(size(gray,1),y+h);

    roi = gray(y1:y2,x1:x2);
    roiNorm = double(roi)/255;
    preenchimento(alt) = 1 - mean(roiNorm(:));
end

fprintf('Tipo de Prova -> ');
fprintf('%.2f ',preenchimento);
fprintf('\n');

% seleciona o gabarito mais preenchido
limiarMarcada = 0.50;
[maiorValor,idx] = max(preenchimento);

if maiorValor < limiarMarcada
    tipoProva = '?';
    fprintf('AVISO: Tipo de prova não detectado!\n');
    return;
end

% valida mais de uma marcacao
limiarDupla = 0.80;
candidatos = preenchimento > (maiorValor*limiarDupla);
if sum(candidatos) > 1
    tipoProva = '?';
    fprintf('AVISO: Múltiplos tipos marcados!\n');
    return;
end

% determina tipo de prova
labels = ['A','B','C','D'];
tipoProva = labels(idx);

fprintf('Tipo de prova detectado: %c\n', tipoProva);

end