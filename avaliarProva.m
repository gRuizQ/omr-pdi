% Autores: Antonio Galvão Martins Neto; Gustavo Ruiz de Queiroz  %
% Data: 11/06/2026                                               %
% UTFPR - Processamento Digital de Imagens                       %

function [nota, acertos, erros, brancos, pontosObtidos] = ...
    avaliarProva(respostasAluno, gabarito, pesos)

% Entrada:
%   respostasAluno (50x1)
%   gabarito       (50x1)
%   pesos          (50x1)
%
% Saída:
%   nota
%   acertos
%   erros
%   brancos
%   pontosObtidos

acertos = 0;
erros = 0;
brancos = 0;
pontosObtidos = 0;

for q = 1:length(gabarito)
    resposta = respostasAluno(q);

    fprintf('Q%02d -> Aluno:%c | Gabarito:%c\n',...
    q,...
    respostasAluno(q),...
    gabarito(q));

    % analisa brancos
    if resposta == '-'
        brancos = brancos + 1;
        continue;
    end

    % anula erros por mais de uma resposta
    if resposta == 'X'
        erros = erros + 1;
        continue;
    end

    % count de acertos
    if resposta == gabarito(q)
        acertos = acertos + 1;
        pontosObtidos = pontosObtidos + pesos(q);
    else
        erros = erros + 1;
    end
end

% nota
pontuacaoMaxima = sum(pesos);
nota = (pontosObtidos / pontuacaoMaxima) * 10;
end