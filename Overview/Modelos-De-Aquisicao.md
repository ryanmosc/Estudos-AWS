#   MODELOS DE AQUISIÇÂO EC2:

**Sob demanda:**
Você paga pelo o que utiliza (Paga pelo tempo de execução). É o modelo mais caro, porém você não tem compromisso e nem contrato com a AWS.
Quando utilizar:
- Desenvolvimento
- Testes
- Free tier
- Ambientes temporarios
  
**IMPORTANTE:**
- Se a instancia estiver desligada, você não irá pagar pelos recursos alocados para a mesma (CPU, Memoria Ram), pois as mesmas podem ser alocadas para outros clientes. Entretanto irá pagar pelo disco utilizado, pois o disco não é possivel alocar novamente. Afinal tem seus metadados neles.
- Se você utilizou 1h15mnt de uma intsnacia Linux, você irá pagar 1h15 de uso, porém se utilizou qualquer outro SO a AWS aredonda o valor para mais. Ou seja, irá pagar 2h.
  
**Reservadas**
Nesta modalidade você faz um compromisso de uso com a AWS, você reserva uma instancia por determinado periodo de uso e com tantos recursos, geralmente entre (1 a 3 anos) e em troca a AWS te retorna um desconto significativo(Dependendo da forma de pagamento também).
Quando utilizar:
- Sistema que irá durar muito tempo
- ERP
- Coisas duraveis que voce tem a certeza que ira utilziar
  
**IMPORTANTE:**
- Mesmo se você ver depois de um tempo que fez um mal negocio alugando uma instancia por ex: 2 anos e nã irá utilziar a mesma, não tem como voltar atrás do contrato, você irá pagar sem utilizar.

**Saving Planes**
Nesta modalidade você tem preços flexiveis em troca de um compromisso de uso especifico (Tanto faz oq vc for fazer) medido em horas por um periodo entre 1 a 3 anos. (Voce se compromete a utilizar a instancia durante x horas por x periodo) (AWS eu me comprometo a utilizar 0,20 por hora durante 2 anos. Usou menos = pagou 0,20 Usou mais = pagou 0,20 + o tanto que usou)
Temos 3 tipos de Saving Plans:
- Saving Plans para computação (Fargate, EC2 e Lambda) economia de até 66% 
- Saving Plans para EC2 economia de até 72%
- Saving planes do Sagermaker economia de até 64%

Analogia:
Imagine uma academia.
Você paga uma mensalidade de R$ 150.
Se você for todos os dias, ótimo.
Se for apenas uma vez, continua pagando R$ 150.
Se não for nenhuma vez, também continua pagando.
O Savings Plan funciona de forma parecida: você paga pelo compromisso assumido, não pela utilização efetiva.
                                
**Spot Instances**
Esta modalidade é a mais barata da AWS. A AWS como empresa, possui serviços ocisosos (Parados) e que podem ser realocados. O ponto negativo é que a AWS pode parar quando quiser este serviço (Ela manda ums msg 2 mnts antes do serviço ser excluido).
Quando usar:
- Processamento em lote (batch)
- Renderização
- Simulações
- Treinamento de IA
- CI/CD
- Processamento de vídeos