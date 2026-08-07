*2.1  Descreva um cenário concreto em que adotar GitOps ajuda a resolver um problema. Especifique em quais pontos ela ajuda e por quê.*

Na Evolutix (empresa atual), antes de termos o ArgoCD, o time de Dev vivia fazendo alterações diretamente no cluster, e com isso perdíamos o controle do que era mudança necessária. Outro problema era que os ambientes dos clientes viviam diferentes um do outro: em momentos de atualização de release, onde era preciso trocar a image tag para pegar as novas versões, alguns ambientes funcionavam perfeitamente e outros não, o que aumentava bastante a complexidade de cada atualização.

Hoje em dia temos visibilidade do que está rodando e o deploy ficou mais simples. O time de Dev tem acesso ao ArgoCD apenas como leitura, para verificar o que está rodando no Kubernetes, mas sem precisar de acesso ao cluster em si nem de credenciais para alterar recursos. Agora só a equipe de DevOps realiza as atualizações em todos os ambientes, mantendo um padrão, já que o ArgoCD garante que o que está no repositório é realmente o que está rodando no cluster.

Os principais pontos em que o GitOps ajudou, e por quê:

- **Visibilidade**: o time de Dev consegue ver o que está rodando sem precisar de acesso direto ao cluster.
- **Segurança / redução de acesso**: só a equipe de DevOps tem credenciais de escrita no cluster, o que reduz o risco de mudanças não controladas.
- **Padronização entre ambientes**: todos os ambientes de clientes seguem o mesmo processo de atualização, evitando o "funciona em um, quebra em outro".
- **Consistência garantida**: o ArgoCD compara continuamente repositório e cluster, garantindo que os dois fiquem sempre iguais.
