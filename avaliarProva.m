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

function [nota, acertos, erros, brancos, pontosObtidos] = ...
    avaliarProva(respostasAluno, gabarito, pesos)

% ==============================================================
% AVALIARPROVA
%
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
%
% ==============================================================

%% Inicialização

acertos = 0;
erros = 0;
brancos = 0;
pontosObtidos = 0;

%% Avaliação
for q = 1:length(gabarito)
    resposta = respostasAluno(q);

    fprintf('Q%02d -> Aluno:%c | Gabarito:%c\n',...
    q,...
    respostasAluno(q),...
    gabarito(q));

    % Questão em branco
    if resposta == '-'
        brancos = brancos + 1;
        continue;
    end

    % Questão anulada por múltipla marcação
    if resposta == 'X'
        erros = erros + 1;
        continue;
    end

    % Acerto
    if resposta == gabarito(q)
        acertos = acertos + 1;
        pontosObtidos = pontosObtidos + pesos(q);
    else
        erros = erros + 1;
    end
end

%% Nota
pontuacaoMaxima = sum(pesos);
nota = (pontosObtidos / pontuacaoMaxima) * 10;
end