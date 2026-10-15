# AWS WAF

## 1. O que é o AWS WAF

O AWS WAF (Web Application Firewall) é um firewall de aplicações web disponibilizado pela Amazon Web Services (AWS), desenvolvido para monitorar, filtrar e controlar requisições HTTP e HTTPS direcionadas a aplicações web e APIs.

Seu principal objetivo é proteger aplicações contra ataques comuns da camada de aplicação, como tentativas de exploração de vulnerabilidades, injeção de SQL (SQL Injection), Cross-Site Scripting (XSS), tráfego automatizado indesejado e outras requisições que correspondam a padrões de ameaça definidos nas regras de segurança.

Diferentemente de um Security Group ou de uma Network ACL, que controlam o tráfego de rede com base em critérios como endereços IP, portas e protocolos, o AWS WAF permite analisar características das requisições HTTP e HTTPS, incluindo endereços IP de origem, cabeçalhos, caminhos, parâmetros e conteúdo do corpo da requisição, conforme as condições e os limites de inspeção configurados.

## 2. Para que serve o AWS WAF

O AWS WAF pode ser utilizado para:

* Bloquear requisições identificadas como maliciosas.
* Permitir somente requisições que atendam a determinadas condições.
* Restringir o acesso com base em endereços IP, países, caminhos e outros critérios.
* Mitigar ataques comuns contra aplicações web.
* Controlar requisições automatizadas, como bots, conforme as regras utilizadas.
* Implementar limites de requisições para reduzir abusos e determinados tipos de sobrecarga.
* Registrar e analisar requisições permitidas, bloqueadas ou contabilizadas.
* Aplicar políticas de segurança centralizadas em aplicações e APIs compatíveis.

O AWS WAF não substitui todas as demais camadas de segurança. Ele deve ser utilizado em conjunto com controles de rede, autenticação, autorização, atualizações de software, monitoramento e boas práticas de desenvolvimento seguro.

## 3. Principais componentes

### 3.1. Web ACL (Web Access Control List)

A Web ACL é o recurso responsável por agrupar as regras de segurança aplicadas ao tráfego de uma aplicação.

Dentro de uma Web ACL, é possível definir quais condições serão avaliadas, quais ações serão executadas e qual será a ordem de processamento das regras.

Uma Web ACL pode ser associada a recursos compatíveis, como:

* Amazon CloudFront.
* Application Load Balancer (ALB).
* Amazon API Gateway.
* AWS AppSync.
* Amazon Cognito User Pool.
* AWS App Runner e AWS Verified Access, conforme a modalidade de integração suportada.

A disponibilidade e as características de cada associação dependem do tipo de recurso e da configuração regional ou global do AWS WAF.

### 3.2. Rules (Regras)

As regras definem as condições que uma requisição precisa atender para receber determinada ação.

Exemplos de regras:

* Bloquear requisições provenientes de endereços IP específicos.
* Bloquear acessos a determinados caminhos da aplicação.
* Identificar padrões associados a SQL Injection ou Cross-Site Scripting.
* Aplicar limites de requisições por endereço IP.
* Inspecionar cabeçalhos e parâmetros HTTP.
* Restringir métodos HTTP não utilizados pela aplicação.

As regras podem ser criadas individualmente ou agrupadas em Rule Groups.

### 3.3. Rule Groups (Grupos de regras)

Os Rule Groups permitem organizar e reutilizar conjuntos de regras de segurança.

A AWS disponibiliza grupos de regras gerenciadas, conhecidos como AWS Managed Rules, que ajudam a proteger aplicações contra ameaças comuns. Também é possível utilizar grupos de regras próprios ou fornecidos por parceiros.

Os grupos gerenciados reduzem o trabalho necessário para criar regras individualmente, mas precisam ser avaliados e ajustados de acordo com as características da aplicação protegida.

### 3.4. Web ACL Capacity Units (WCUs)

As WCUs representam a capacidade computacional utilizada pelas regras de uma Web ACL.

Cada regra possui um custo de capacidade que varia de acordo com o tipo de inspeção e a complexidade das condições utilizadas. A capacidade total disponível deve ser considerada durante o planejamento da Web ACL.

As WCUs não representam diretamente a quantidade de requisições processadas nem o custo financeiro total do serviço.

### 3.5. Logging e monitoramento

O AWS WAF permite registrar informações sobre as requisições avaliadas, facilitando auditorias, investigações de incidentes e ajustes nas regras.

Os logs podem ser encaminhados para destinos compatíveis, como Amazon CloudWatch Logs, Amazon S3 e Amazon Data Firehose, respeitando os requisitos e as limitações de cada integração.

Além disso, métricas podem ser acompanhadas pelo Amazon CloudWatch, permitindo monitorar indicadores como requisições permitidas, bloqueadas e correspondências com determinadas regras.

É importante revisar os campos registrados e configurar a proteção de dados sensíveis para evitar a exposição desnecessária de informações nos logs.

## 4. Principais ações das regras

O AWS WAF disponibiliza diferentes ações para determinar como uma requisição será tratada.

**Allow:** permite que a requisição prossiga pelo processamento do WAF.

**Block:** bloqueia a requisição, impedindo que ela prossiga para o recurso protegido por meio daquele fluxo.

**Count:** contabiliza as requisições que correspondem à regra sem bloqueá-las. É útil para testar regras e identificar possíveis falsos positivos.

**CAPTCHA:** exige que o cliente resolva um desafio CAPTCHA antes de continuar, conforme o comportamento e o contexto da requisição.

**Challenge:** exige uma verificação de desafio do AWS WAF para avaliar se a requisição é originada de um cliente que consegue responder corretamente ao mecanismo de verificação.

As ações CAPTCHA e Challenge dependem de suporte e configuração compatíveis com o tipo de recurso e a aplicação.

A ordem das regras é importante. O AWS WAF avalia as regras conforme suas prioridades e aplica o comportamento correspondente, podendo encerrar a avaliação quando uma regra produz uma ação de encerramento, como Allow ou Block.

## 5. Como funciona o AWS WAF

De maneira simplificada, o fluxo de processamento ocorre da seguinte forma:

1. O cliente realiza uma requisição HTTP ou HTTPS para a aplicação.
2. A requisição chega ao recurso associado à Web ACL, como uma distribuição CloudFront ou um Application Load Balancer.
3. O AWS WAF avalia a requisição conforme as regras configuradas.
4. Caso uma regra corresponda à requisição, a ação definida é executada.
5. Se a requisição for permitida, ela continua o processamento em direção à aplicação de destino.
6. Os eventos podem ser registrados em logs e métricas para análise e monitoramento.

A posição do WAF na arquitetura depende do recurso protegido. Quando associado ao CloudFront, por exemplo, ele pode avaliar requisições na camada de distribuição antes que elas sejam encaminhadas à origem.

## 6. Exemplo prático de utilização

Considere uma aplicação web hospedada em uma instância Amazon EC2 com endereço IP público.

Sem uma camada adicional de proteção, os usuários podem acessar diretamente o endereço da instância, desde que as regras de rede e o serviço web permitam a conexão.

Uma arquitetura com CloudFront e AWS WAF pode funcionar da seguinte forma:

1. O usuário acessa o domínio público da aplicação.
2. O Amazon CloudFront recebe a requisição.
3. O AWS WAF, associado à distribuição CloudFront, avalia a requisição.
4. Requisições permitidas seguem para a origem configurada.
5. Requisições que correspondam a regras de bloqueio são rejeitadas pelo WAF.
6. O CloudFront encaminha as requisições permitidas à origem, que pode ser uma instância EC2 ou um Application Load Balancer.

Para que essa arquitetura ofereça proteção efetiva, é necessário impedir que usuários contornem o CloudFront acessando diretamente a origem. Isso pode exigir restrições no Security Group, uso de mecanismos de autenticação entre a distribuição e a origem ou outras medidas compatíveis com a arquitetura adotada.

O CloudFront e o WAF não eliminam a necessidade de proteger a própria instância EC2, seus serviços, suas credenciais e o sistema operacional.

## 7. AWS WAF e outros serviços de segurança

Cada serviço possui uma função específica dentro da arquitetura.

**AWS WAF:** analisa requisições HTTP e HTTPS e aplica regras de proteção na camada de aplicação.

**AWS Shield:** oferece proteção contra ataques de negação de serviço distribuído (DDoS), com diferentes níveis de proteção conforme o plano e os recursos utilizados.

**Security Groups:** controlam o tráfego de entrada e saída das interfaces de rede de recursos compatíveis, como instâncias EC2.

**Network ACLs:** aplicam controles de tráfego de rede nas sub-redes de uma VPC.

**Amazon CloudFront:** distribui conteúdo e recebe requisições dos usuários, podendo atuar como ponto de entrada para aplicações protegidas pelo WAF.

**Application Load Balancer:** distribui requisições entre destinos, como instâncias EC2, e pode ter uma Web ACL associada.

Esses serviços são complementares e podem ser combinados para implementar uma arquitetura de defesa em profundidade.

## 8. Monitoramento e análise de eventos

Após a implantação do AWS WAF, é importante acompanhar o comportamento das regras para verificar se a proteção está funcionando corretamente.

Entre as principais atividades de monitoramento estão:

* Acompanhar a quantidade de requisições permitidas e bloqueadas.
* Identificar aumentos inesperados no tráfego.
* Analisar regras que apresentam muitas correspondências.
* Investigar possíveis falsos positivos.
* Revisar os logs para identificar padrões de acesso suspeitos.
* Ajustar regras de acordo com as necessidades da aplicação.
* Validar o funcionamento das regras antes de aplicá-las em produção.

Durante a implantação, a ação Count pode ser utilizada para observar o impacto de uma regra antes de começar a bloquear requisições. Essa abordagem reduz o risco de interromper acessos legítimos por causa de regras excessivamente restritivas.

## 9. Custos do AWS WAF

O custo do AWS WAF depende da configuração e do volume de utilização.

Os principais fatores de cobrança incluem:

* Quantidade de Web ACLs utilizadas.
* Quantidade de regras adicionadas.
* Volume de requisições processadas.
* Recursos adicionais ou grupos de regras gerenciadas que possuam cobranças próprias.

Serviços associados, como CloudFront, CloudWatch Logs e mecanismos de entrega de logs, também podem gerar custos independentes.

Antes de implementar o WAF em um ambiente de produção, é recomendável consultar a página oficial de preços da AWS e estimar os custos considerando o volume esperado de tráfego, as regras utilizadas e os recursos associados.

## 10. Boas práticas

Para uma implementação segura e eficiente do AWS WAF, recomenda-se:

1. Utilizar regras gerenciadas como ponto de partida para a proteção contra ameaças comuns.
2. Avaliar as regras inicialmente com Count quando houver risco de bloquear tráfego legítimo.
3. Definir regras específicas para as necessidades da aplicação.
4. Manter a origem protegida contra acessos diretos não autorizados.
5. Habilitar logging e configurar métricas para acompanhamento operacional.
6. Revisar periodicamente as regras e investigar bloqueios inesperados.
7. Evitar registrar informações sensíveis desnecessariamente.
8. Monitorar o impacto das regras sobre a latência e a experiência dos usuários.
9. Revisar custos e capacidade das regras antes de ampliar a configuração.
10. Combinar o WAF com controles de rede, atualizações, autenticação e monitoramento.
