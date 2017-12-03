+++
date = "2017-01-28T19:11:44-03:00"
title = "Organizando a casa - A estrutura de diretórios"
tags = ["Pesquisa Reprodutível", "Msc", "Educação"]
+++

Antes de inciar o desenvolvimento do meu mestrado me deparei com o seguinte dilema: como organizar o diretório principal? Existe uma maneira ótima e/ou recomendada para organizar os arquivos? 

<!--more-->

Em busca de uma estrutura de organização dos diretórios para realização do mestrado topei com o conceito de *preoductible research* ou pesquisa reprodutível. O tema me fascinou desde o princípio, pois como pesquisador tentar reproduzir o feito de outros autores é algo imprescindível e que todos faremos. Devemos, portanto, estar preparados para auxiliar outros pesquisadores a utilizar o nosso trabalho. Isto é o ápice da disseminação do conhecimento e pode ser feito de diversas formas, dentre elas a mais óbvia (mas não simplies) é a escrita objetiva e lúcida de artigos científicos. 

Para áreas da ciência que lidam com análise de dados, porém, o tema toma outras proporções. Além da metodologia, códigos e dados podem tornar-se fontes de erros, acarretando em discrepâncias entre os resultados obtidos por diferentes pesquisadores. Com o intuito de agilizar e conferir transparência à disseminação do conhecimento correto, há um movimento que tem como objetivo compartilhar os códigos, softwares e dados para que outros pesquisadores possam reproduzir os resultados com maior facilidade. Faço das palavras do [Daniel Marcelino](http://danielmarcelino.github.io/blog/2016/reproducible-research.html) as minhas: **mesmos dados + mesmos scripts = mesmos resultados**. Foi com esta premissa que decidi seguir adiante com o projeto do mestrado, a premissa de uma realizar uma pesquisa reprodutível.

Antes de tudo, gostaria de reforçar que elaborar projetos reprodutíveis necessitarão de uma modificação no modo de trabalho de muitos. Comigo não foi diferente. Três pontos que me chamaram bastante atenção foram:

* Estruturação de diretórios
* Programação literária
* Controle de versão

## Organizando a casa: estrutura de diretórios

O primeiro parece óbvio, mas faz grande diferença no longo prazo. Não, não sou apenas eu quem diz isto. Basta ver iniciativas como [ProjectTemplate](http://projecttemplate.net/index.html) para se ter uma noção. Uma boa estrutura de diretório pode favorecer a boa documentação do projeto, o facilitamento de compartilhamento e promover boa práticas de programação científica como a utilização de testes de unidade e profiling. Adianto que não segui à risca estas recomendações. Contudo, fiquei bastante satisfeito adotando a seguinte estrutura de diretórios:

``` bash

tree -d
.
├── data
│   ├── case_study
├── docear
├── literature
│   ├── Academic works
│   ├── Books
│   ├── Misc
│   ├── Papers
│   ├── Presentations
│   ├── Reports
│   ├── Standards
│   └── White papers
├── other
│   ├── Corrections
│   ├── Meetings
│   └── Schedule
├── routines
│   ├── html
│   └── libs
├── slides
│   └── beamer
└── writeup
    ├── latex
    │   ├── doc
    │   ├── elementos-pos-textuais
    │   │   ├── anexos
    │   │   └── apendices
    │   ├── elementos-pre-textuais
    │   ├── elementos-textuais
    │   ├── figuras
    │   ├── lib
    │   └── tabelas
    └── Notes
``` 

 Enquanto este setup não oferece algumas benécies ofertadas pela adoção de um esquema mais completo como o do ProjectTemplate, ele permitiu:

 * **Portabilidade**: Todos estes diretórios encontram-se em uma pasta denominada *Thesis* dentro do meu Dropbox, permitindo que eu trabalhasse no projeto mesmo em diferentes máquinas;
 * **Integração** entre os resultados dos scripts e o texto da dissertação. Figuras eram salvas diretamente na pasta `./writeup/latex/figuras` e tabelas na pasta `./writeup/latex/tabelas`. Com isto, a medida que correções foram sendo necessárias nestes elementos a atualização do texto foi simplificada, bastando compilar o documento novamente.
 * **Bibliografia**: Incluí toda a bilbiografia utilizada no trabalho bem como o banco de referencias juntamente com o código e documento da dissertação. Vale ressaltar que a portabilidade e integração também ocorreram com o gerenciador de referências (Jabref/Docear), que serão abordados em outros posts.






