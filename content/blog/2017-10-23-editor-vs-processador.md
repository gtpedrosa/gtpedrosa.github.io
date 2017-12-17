+++
date = "2017-10-23T17:58:45-03:00"
title = "editor vs processador"
tags = ["Msc","Latex"]
+++

Com o objetivo de redigir textos científicos, qual a ferramenta mais adequada para o trabalho? Editores ou processadores de texto?

<!--more-->

Um editor de texto é um software especializado pura e simplesmente na manipulação de texto. Editores focados em power users, como o vi e emacs, podem ter milhões de ferramentas que auxiliem nesta tarefa. Já um processador de texto permite ao usuário trabalhar também nos aspectos de formatação do texto. O principal representante dessa classe é o Microsoft Word.

Com o foco na produção científica, creio que o descoplamento da forma e conteúdo dos trabalhos seja algo extremamente vantajoso. Desta forma, a preparação de artigos científicos com base em dissertações ou teses é algo que torna-se bem menos trabalhoso. Grandes editoras como a Elsevier disponibilizam estilos em LaTeX por exemplo em que os pesquisadores não precisam se preocupar com formatação alguma. Além disso ao gerenciamento de referências e citações torna-se automático neste sistema.

Dito isto, fica claro minha preferência pelo combo: editor de texto + LaTeX para preparação de textos científicos. Deixo abaixo uma lista com os combos que testei:

* **Kate**: Kate permite navegar entre mútliplas pastas com o mouse e possui um terminal embutido onde é possível chamar o latexmk para compilar o documento;
* **vim**: Utilizei o vim juntamente com o latexbox. A macro \ll para compilar o documento é bastante útil;
* **TexStudio**: Minha opção default para windows. Gostei bastante do completion para comandos com open/end.

Apesar de muito poderoso, o *vim* não é tão simples de ser utilizado, fazendo com que eu trabalhasse principalmente no Kate. Em suma: vale a pena testar as diversas opções existentes e selecionar a que mais se adequa ao seu fluxo de trabalho.




