# Load Balancing  (ELB)

O **AWS Elastic Load Balancing (ELB)** é o serviço responsável por distribuir automaticamente o tráfego de entrada entre múltiplos destinos (como instâncias EC2, contêineres ECS, endereços IP e funções Lambda), garantindo **alta disponibilidade, tolerância a falhas e escalabilidade** da aplicação, tudo isso baseado em regras como (Alto uso / Baixo uso).


```text
                               Internet
                                  │
                                  ▼
                        Elastic Load Balancer
                         ┌────────┼────────┐
                         ▼        ▼        ▼
                        EC2      EC2      EC2

```

> **Abstração de Infraestrutura:** O usuário final interage apenas com o ponto de extremidade (*Endpoint*) do Load Balancer. Ele não conhece e não precisa saber qual instância específica está processando a sua requisição.

---

#### Principais Funcionalidades do ELB

* **Health Checks (Verificação de Saúde):** O ELB monitora continuamente o estado das instâncias. Se uma instância falhar ou parar de responder, o ELB interrompe o envio de tráfego para ela até que volte a ficar saudável.
* **SSL/TLS Termination (Descarga de SSL):** O certificado HTTPS pode ser instalado e gerenciado diretamente no ELB (via *AWS Certificate Manager*). Isso elimina a necessidade de configurar certificados individualmente em cada instância EC2, desonerando o processamento do servidor.
* **Integração com Auto Scaling:** Trabalha em conjunto com os *Auto Scaling Groups (ASG)*. Quando a demanda aumenta (ex: CPU em 95%) e novas instâncias são criadas, o ELB as registra automaticamente para começar a receber tráfego.

---

#### Tipos de Load Balancer na AWS

##### 1. Application Load Balancer (ALB)

* **Camada de Atuação:** Camada 7 (Aplicação) do modelo OSI.
* **Protocolos:** HTTP, HTTPS, HTTP/2 e WebSockets.
* **Recursos:** Roteamento avançado baseado em regras (Caminho/Path, Cabeçalhos HTTP, Cookies e Nomes de Host).
* **Exemplo de Roteamento por Caminho (Path-Based):**
* `[meusite.com/api](https://meusite.com/api)` ➔ Direciona para o grupo de servidores de API.
* `[meusite.com/admin](https://meusite.com/admin)` ➔ Direciona para o grupo de servidores do Painel Administrativo.


* **Indicação:** Escolha ideal para aplicações web modernas, microsserviços e arquiteturas em contêineres.

##### 2. Network Load Balancer (NLB)

* **Camada de Atuação:** Camada 4 (Transporte) do modelo OSI.
* **Protocolos:** TCP, UDP e TLS.
* **Recursos:** Ultra-alta performance, latência extremamente baixa e suporte a endereços IP estáticos.
* **Indicação:** Ideal para jogos online, conexões de redes industriais (MQTT), VoIP, streaming e bancos de dados que processam milhões de requisições por segundo.

##### 3. Gateway Load Balancer (GWLB)

* **Camada de Atuação:** Camada 3 (Rede) e Camada 4 (Transporte).
* **Recursos:** Facilita a implantação, escalabilidade e gerenciamento de *appliances* virtuais de terceiros.
* **Indicação:** Ambientes corporativos que exigem inspeção rigorosa de tráfego via Firewalls virtuais, sistemas IDS/IPS e inspecionadores de pacotes.

##### 4. Classic Load Balancer (CLB) — *Legado / Não Utilizar*

* **Status:** Primeira geração de Load Balancer da AWS (trabalhava em ambas as camadas 4 e 7).
* **Recomendação:** Considerado obsoleto. Para novas soluções, utilize **ALB** ou **NLB**.

| Tipo | Camada OSI | Protocolos | Principais Casos de Uso |
| --- | --- | --- | --- |
| **ALB** | Camada 7 (Aplicação) | HTTP, HTTPS, gRPC | Sites web, APIs, Microsserviços, Roteamento por URL/Host |
| **NLB** | Camada 4 (Transporte) | TCP, UDP, TLS | Jogos, Streaming, Baixa Latência, IP Estático |
| **GWLB** | Camada 3/4 (Rede/Transp.) | IP, GENEVE | Inspecionadores de tráfego, Firewalls virtuais (IDS/IPS) |
| **CLB** | Camada 4/7 (Legado) | Vários | *Obsoleto — Substituído por ALB/NLB* |
