# ESTRATEGIAS DE DEPLOY

**Rolling Update** - Ele substitue de forma gradual os serviços que estão em execução pelas novas tasks.
Exemplo: Você possui 6 tasks rodando, ele irá substituir as mesmas de forma gradual. Tira 2 coloca 2 e etc...
IMPORTANTE: Não gera custos altos, mas pode ter lentidão e travamento e rolback demorado.

**Blue / Green** - Ele cria um ambiente separado para homologação e quando você valida o de homologação ele substitui o de prod.
IMPORTANTE - Ele redireciona o trafego de um ambiente para o outro