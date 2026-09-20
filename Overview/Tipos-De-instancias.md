# TIPOS DE INSTANCIA

O tipo de instancia é responsavel por ditar quanto de CPU, Memoria RAM, Disco e rede a VM irá ter.

**Como ler um tipo de instancia**
Ex:
t3.micro
Ela é composta por tres partes.
t 3.micro
│ │   │
│ │   └── Tamanho
│ └────── Geração
└──────── Família

FAMILIA - Indica para qual finalidade a vm será utilizada.

| Família | Uso                   |
| ------- | --------------------- |
| T       | Uso geral econômico   |
| M       | Uso geral             |
| C       | Computação            |
| R       | Memória               |
| X       | Memória extrema       |
| I       | IOPS/SSD              |
| D       | Armazenamento         |
| G       | GPU                   |
| P       | GPU pesada            |
| Inf     | Inferência IA         |
| Trn     | Treinamento IA        |
| Hpc     | Computação científica |

GERAÇÂO - Quanto maior mais recente

Exemplo: 
t2
↓

t3
↓

t4g

Obs: O "g" significa o tipo de processador que está sendo utiliziado.
g = ARM (Graviton) - Processador da AWS

i = Intel

a = AMD

TAMANHO - É o tamanho 

nano

micro

small

medium

large

xlarge

2xlarge

4xlarge

8xlarge

12xlarge

16xlarge

24xlarge...

RESUMO:
T → econômica para cargas leves e desenvolvimento.
M → uso geral (a escolha mais comum).
C → foco em processamento.                          
R → foco em memória.