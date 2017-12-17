+++
date = "2017-04-10T19:11:44-03:00"
title = "Programação Literária"
tags = ["Pesquisa Reprodutível", "Msc", "Educação"]
mathjax = true
+++

 Este conceito foi criado por ninguém menos que Donald Knuth (lembra-se do \\( \LaTeX \\)?). Knuth argumenta que os programas de computador devem ser tão legíveis quanto obras literárias. 
 
<!--more-->

 No âmbito de pesquisas reprodutíveis, isto foi uma mudança de paradigma, bastando ver a quantidade de sistemas que "brotaram" e espalharam-se com extrema velocidade: Jupyter (antigo IPython) notebooks, Knitr e Sweave, Matlab publisher. Independente do sistema ou linguagem de programação adotada, a premissa é a mesma: não só o código é documentado, como também a interpretação dos resultados, acrescido de algumas benécies. O próprio script é então convertido em um documento html ou LaTeX, por exemplo, para publicação diretamente a partir do código fonte. A beleza disto é que qualquer pessoa poderá iteragir com tal trabalho, além de poder executa-lo de forma independente. 

 Todas as linguages computacionais científicas adaptaram-se para dar suporte a crescente demanda pela programação literária. Dentre as linguagens que considero mais comuns para análise científica de dados estão: Matlab, R e Python. Demonstrarei a seguir brevemente a capacidade de renderização do código utilizando pacotes/funcionalidades de cada uma.

## Matlab

O [Matlab Publisher](https://www.mathworks.com/help/matlab/matlab_prog/publishing-matlab-code.html) permite que o usuário *publique* (obviamente) o código fonte juntamente com comentários, equações e plots renderizados. A considero ainda uma função subutilizada, apesar de estar disponível, até onde pude constatar, [desde 2009](http://blogs.mathworks.com/community/2009/11/16/publish-to-pdf/). 

Durante meus experimentos/testes, elaboração de hipóteses e exploração de dados, criei um *mfile* contendo tanto o código utilizado para realização de tais tarefas como seus resultados em uma série de arquivos iniciando com o nome **estudo_**. Segue um exemplo sobre o estudo para ganhar intuição sobre uma grandeza da teoria da informação denominada informação mútua:

![Exemplo de arquivo mfile com documento html exibido no navegador.](/img/Matlab_Publisher.png)


## R

Muito mais presente no ecossistema do **R** até pela sua característica open-source, a reprodutibilidade possui ferramentas adicionais. Na IDE denominada **RStudio** (que eu recomendo fortemente) é fácil elaborar não só códigos documentados no formato **Rmd** que podem ser renderizados em html ou pdf, mas também slides html e até integra-los a serviços como github e RPublisher de forma impecável.

![Exemplo de arquivo Rmd no RStudio 1.0.136 com equações renderizadas na IDE.](/img/RStudio_Knittr_html.png)


## Python (?)

 Note a interrogação. Inicialmente criado com o nome *iPython notebook*, o Jupyter é um ambiente web de código aberto que permite a inserção de equações, gráficos, conteúdos digitais bem como explicações juntamente com o código da análise. É interessante notar que Jupyter notebook evoluiu para um projeto que é `linguagem agnóstico`. Isto significa que ao modificar-se o [kernel](https://github.com/jupyter/jupyter/wiki/Jupyter-kernels) pode-se programar em **R**, **Matlab**, **python** ou qualquer outra linguagem suportada, sem precisar para tanto modificar o workflow e adaptar-se a diferentes estilos de *markup*.


![Exemplo de iPython notebook. Fonte: <https://ipython.org/ipython-doc/3/_images/ipy_013_notebook_spectrogram.png>](/img/ipython.png)


# Leitura adicional

 Apenas destaquei a existência das ferramentas em R, Matlab ou python para auxílio na adoção da programação literária. Separei abaixo alguns links de como utilizar tais ferramentas em cada um dos ambientes de programação:

 * <https://www.mathworks.com/help/matlab/matlab_prog/publishing-matlab-code.html>
 * <http://rmarkdown.rstudio.com/>
 * <https://jupyter-notebook-beginner-guide.readthedocs.io/en/latest/>




