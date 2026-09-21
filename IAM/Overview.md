# O que é IAM

O AWS Identity and Access Management (IAM) é o serviço responsável por gerenciar credenciais, permissões e acessos a recursos da AWS de forma segura.

**Principais Funcionalidades**
- Controle de Acesso e Login: Gerencia quem pode se autenticar e os métodos de autenticação permitidos.
- Gestão de Permissões e Perfis (Roles): Define acessos granulares baseados no princípio do menor privilégio.
- Organização em Grupos: Simplifica a atribuição de políticas para múltiplos usuários simultaneamente.

**Boas Práticas de Segurança**
Usuário Root: Criado no momento da abertura da conta com acesso irrestrito. Por motivos de segurança, o uso do usuário root deve ser evitado no dia a dia. É altamente recomendável criar usuários ou funções específicas para as atividades operacionais.

**Infraestrutura e Custos**
Disponibilidade Global: O IAM é um serviço global e replicado entre regiões, sem dependência de uma única Zona de Disponibilidade (AZ).

**Custo: O serviço é gratuito e não gera custos adicionais na sua conta AWS.**

**Formas de Autenticação das Entidades**
- Usuário Root: Autenticado via e-mail e senha cadastrados na criação da conta.
  
- Entidade Principal Federada: Autenticação realizada por um Provedor de Identidade (IdP) externo, que passa as credenciais para a AWS (suportado pelo IAM e AWS IAM Identity Center).
  
- Usuários do AWS IAM Identity Center: Entram pelo Portal de Acesso da AWS utilizando o diretório padrão (nome de usuário e senha).














Usuário do IAM: Autentica-se pelo ID/alias da conta, nome de usuário e senha. Para automações via API/CLI, utiliza credenciais temporárias (assumindo perfis) ou credenciais de longo prazo (chaves de acesso/secretas).