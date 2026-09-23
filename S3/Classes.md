# CLASSES DE S3

O S3 aloca ao minimo 3 zonas de durabilidade diferentes para seu storage (Modificavel para amortizar custos) e sua taxa de durabilidade é de (99,999999999%) (onze noves) e sua taxa de disponibilidade é de 99,9% / 99,99%.

**S3 Standart** - Alta disponibilidade e versátil para todos os casos

**S3 Intelligent-Tiering** - Alta disponibilidade e menor preços. Faz metricas baseadas em acessos (Quanto mais acessos mais caro)

**S3 Express One Zone** - Alta disponibilidade e faz o roteamento baseado em uma zona de disponibilidade, assim deixando o acesso aos dados em até 10x mais rápido

**S3 Standard-IA** - Feita para dados com acessos infrequentes (Pouca frequencia) porém com alta disponibilidade. Armazena em pelos menos 3 A-Z distintas

**S3 One Zone-IA** - Feita para dados acessados com pouca frequencia, armazenando em apenas 1 A-Z e com custo até 20% inferior ao S3 Standart  ou S3 Standart IA

**S3 Glacier IR** - Feita para arquivamento, tem custos baixos para dados de longa duração e que raramente são acessados (Arquivo morto). Para dados acessados em intervalos de 1 Trimestre, o valor de desconto pode chegar até 68%.

**S3 Glacier Flexible** - Feita para arquivamento. Ideal para dados acessados de 1 a 2 vezes ao ano ou recuperados. Suporta SSL

**S3 Glacier Deep Archive** - É a classe mais acessivel da AWS. Projetada para clientes que guardam dados em um intervalode 7 a 10 anos ou mais (Precisa seguir os requisitos obrigatorios, se atende a isso). Tempo de recuperação de 12 Hrs

**S3 Outposts** - Projetada para on-premises e workloads

| Classe de Armazenamento | Frequência de Acesso | Redundância | Tempo de Recuperação | Principal Caso de Uso |
| :--- | :--- | :--- | :--- | :--- |
| **S3 Standard** | Frequente | 3+ AZs | Imediato | Fotos, vídeos, assets de apps ativos. |
| **S3 Express One Zone** | Extremamente alta / Latência mínima | 1 AZ | Imediato (ms) | Treinamento de ML, IA, Analytics crítico. |
| **S3 Intelligent-Tiering** | Desconhecida / Variável | 3+ AZs | Imediato | Arquivos com padrão de acesso imprevisível (move automaticamente entre camadas sem taxa de recuperação). |
| **S3 Standard-IA** | Infrequente (ex: 1x/mês) | 3+ AZs | Imediato | Backups recentes, relatórios mensais. |
| **S3 One Zone-IA** | Infrequente | 1 AZ | Imediato | Backups secundários, dados recriáveis. |
| **S3 Glacier Instant Retrieval** | Raríssimo (ex: 1x/trimestre) | 3+ AZs | Imediato (milissegundos) | Registros médicos, imagens arquivadas com acesso instantâneo. |
| **S3 Glacier Flexible Retrieval** | Arquivo (1-2x/ano) | 3+ AZs | Minutos a Horas (3 a 5h padrão) | Backups antigos, dados de compliance com tolerância a espera. |
| **S3 Glacier Deep Archive** | Arquivo Morto (7-10 anos) | 3+ AZs | 12 a 48 Horas | Retenção regulatória de longo prazo (custo baixíssimo por GB). |