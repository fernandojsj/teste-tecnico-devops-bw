*4.1  Desenhe uma esteira de melhoria contínua (CI/CD) para uma aplicação. Descreva as etapas desde o commit do desenvolvedor até a aplicação rodando em produção. Justifique as escolhas.*

O diagrama completo dessa esteira está em [`diagramas/esteira-cicd.png`](../diagramas/esteira-cicd.png). As etapas, do commit até produção, seriam:

1. O desenvolvedor abre um PR a partir de uma feature branch, o que dispara a CI automaticamente.
2. A CI roda testes unitários e a análise estática de código (SonarQube), aplicando o quality gate. Se algo falhar aqui, o pipeline para antes de gastar tempo com build.
3. Com o PR aprovado e mergeado, a CI builda a imagem da aplicação e faz o scan de vulnerabilidades da imagem antes de publicar no registry.
4. A imagem é publicada no registry com uma tag imutável (geralmente o SHA do commit), o que garante rastreabilidade entre o artefato e o código que o gerou. É aqui que termina a responsabilidade da CI.
5. O DevOps atualiza a tag da imagem no repositório de manifests, na branch `dev`. Essa etapa é manual e de responsabilidade de um time diferente do que gerou o artefato: a CI não tem (nem precisa ter) acesso de escrita no repositório de manifests.
6. O ArgoCD do ambiente de dev monitora exclusivamente a branch `dev` e sincroniza o cluster automaticamente assim que detecta a mudança.
7. Depois de validado em dev, a promoção para staging e produção segue o fluxo descrito em 4.2 (a).

A justificativa por trás de cada escolha:

- **PR em vez de push direto pra disparar a CI**: garante revisão de código antes de qualquer coisa, e cria o ponto natural onde o quality gate pode bloquear o merge se algo falhar.
- **Quality gate (testes + SonarQube) antes do build**: falha rápido e barato, não faz sentido buildar e escanear a imagem de um código que nem passa nos critérios básicos de qualidade.
- **Merge antes do build, não o contrário**: garante que o SHA usado pra taguear a imagem corresponde exatamente ao commit que está de fato na main, o que é essencial pra rastreabilidade real entre artefato e código.
- **Scan de vulnerabilidade antes do push pro registry**: evita publicar, ainda que temporariamente, uma imagem com vulnerabilidades conhecidas.
- **Tag imutável (SHA) em vez de tag mutável (ex.: `latest`)**: qualquer ambiente sempre sabe exatamente qual commit está rodando, e um incidente em produção pode ser correlacionado com o código exato que o causou.
- **CI termina no registry, não escreve no repositório de manifests nem no cluster**: separa a responsabilidade de "gerar o artefato" (CI) da de "decidir o que roda em cada ambiente" (DevOps/GitOps). Isso reduz a superfície de acesso, já que se a CI for comprometida, quem a comprometeu não consegue alterar diretamente o que está rodando em produção, e centraliza no Git (e no ArgoCD) a fonte da verdade de cada ambiente.
- **DevOps atualiza a branch `dev` diretamente, sem PR**: dev é o ambiente de menor risco, então o ciclo de feedback fica rápido; já a promoção pra `stg`/`prd` exige PR e revisão, porque o risco de uma mudança ruim ali é maior.

*4.2  Como você trataria, nessa esteira:*

**(a) A promoção entre ambientes (dev → staging → prod)**

O repositório de manifests tem uma branch por ambiente (`dev`, `stg`, `prd`), e cada ArgoCD monitora exclusivamente a branch do seu ambiente. Promover significa abrir um PR mergeando a branch já validada no ambiente anterior na branch do próximo ambiente (por exemplo, `dev` → `stg`, depois que a versão for validada em dev). Esse PR passa por revisão antes de ser mergeado, e o ArgoCD do ambiente seguinte sincroniza assim que o merge acontece na branch correspondente. Isso deixa a promoção explícita, auditável pelo histórico do Git, e reversível.

**(b) O rollback de uma versão ruim**

Como o Git é a fonte da verdade, o rollback é simplesmente reverter o commit que trocou a tag da imagem na branch do ambiente afetado. O ArgoCD detecta essa reversão como qualquer outra mudança no repositório e reaplica a versão anterior automaticamente, sem precisar de nenhuma intervenção manual no cluster.

O próprio ArgoCD também guarda o histórico de sincronizações de cada Application, então em uma emergência dá pra usar `argocd app rollback <app> <ID>` para voltar o cluster pra uma revisão anterior na hora, direto pela CLI ou pela UI. Mas isso é uma medida temporária: como o Git continua com a tag ruim, se o auto sync detectar essa divergência ele vai reaplicar a versão ruim de novo. Por isso, o rollback "de verdade" dentro do fluxo de GitOps sempre precisa terminar em um revert no Git, que é o que garante que o estado fique consistente no próximo sync.

**(c) A segurança e a qualidade dentro do fluxo**

Qualidade é garantida pelo quality gate do SonarQube e pelos testes automatizados na CI, que bloqueiam o merge se não passarem. Segurança envolve o scan de vulnerabilidades da imagem antes da publicação no registry, branch protection nas branches `stg` e `prd` do repositório de manifests (exigindo PR revisado, sem push direto), RBAC restringindo quem pode aprovar esses PRs, e nenhuma credencial de cluster exposta fora do ArgoCD. O histórico de commits, tanto no repositório de código quanto no de manifests, funciona como trilha de auditoria de quem mudou o quê e quando.