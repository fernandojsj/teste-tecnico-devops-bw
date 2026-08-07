*4.1  Desenhe uma esteira de melhoria contínua (CI/CD) para uma aplicação. Descreva as etapas desde o commit do desenvolvedor até a aplicação rodando em produção. Justifique as escolhas.*

O diagrama completo dessa esteira está em `diagramas/esteira-cicd.mmd`. As etapas, do commit até produção, seriam:

1. O desenvolvedor abre um PR a partir de uma feature branch, o que dispara a CI automaticamente.
2. A CI roda lint, testes unitários e a análise estática de código (SonarQube), aplicando o quality gate. Se algo falhar aqui, o pipeline para antes de gastar tempo com build.
3. Com o PR aprovado e mergeado, a CI builda a imagem da aplicação e faz o scan de vulnerabilidades da imagem antes de publicar no registry.
4. A imagem é publicada no registry com uma tag imutável (geralmente o SHA do commit), o que garante rastreabilidade entre o artefato e o código que o gerou.
5. A CI atualiza a tag da imagem no repositório de manifests, no overlay do ambiente de dev. É aqui que termina a responsabilidade da CI.
6. O ArgoCD detecta a mudança no repositório de manifests e sincroniza o ambiente de dev automaticamente.
7. Depois de validado em dev, a promoção para staging e produção segue o fluxo descrito em 4.2 (a).

A justificativa principal para esse desenho é a separação clara entre CI e CD, na mesma linha do que descrevi no bloco 3: a CI cuida de tudo que é qualidade e geração do artefato, e nunca toca o cluster diretamente. Isso reduz a superfície de acesso e centraliza no Git (e no ArgoCD) a fonte da verdade de tudo que está rodando em cada ambiente.

*4.2  Como você trataria, nessa esteira:*

**(a) A promoção entre ambientes (dev → staging → prod)**

Cada ambiente tem seu próprio overlay no repositório de manifests, com a tag da imagem que está de fato validada naquele ambiente. Promover um ambiente significa abrir um PR replicando a tag já validada no ambiente anterior para o overlay do próximo ambiente. Esse PR passa por revisão antes de ser mergeado, e o ArgoCD sincroniza o novo ambiente assim que o merge acontece. Isso deixa a promoção explícita, auditável pelo histórico do Git, e reversível.

**(b) O rollback de uma versão ruim**

Como o Git é a fonte da verdade, o rollback é simplesmente reverter o commit que trocou a tag da imagem no overlay do ambiente afetado. O ArgoCD detecta essa reversão como qualquer outra mudança no repositório e reaplica a versão anterior automaticamente, sem precisar de nenhuma intervenção manual no cluster.

O próprio ArgoCD também guarda o histórico de sincronizações de cada Application, então em uma emergência dá pra usar `argocd app rollback <app> <ID>` para voltar o cluster pra uma revisão anterior na hora, direto pela CLI ou pela UI. Mas isso é uma medida temporária: como o Git continua com a tag ruim, se o auto sync detectar essa divergência ele vai reaplicar a versão ruim de novo. Por isso, o rollback "de verdade" dentro do fluxo de GitOps sempre precisa terminar em um revert no Git, que é o que garante que o estado fique consistente no próximo sync.

**(c) A segurança e a qualidade dentro do fluxo**

Qualidade é garantida pelo quality gate do SonarQube e pelos testes automatizados na CI, que bloqueiam o merge se não passarem. Segurança envolve o scan de vulnerabilidades da imagem antes da publicação no registry, RBAC restringindo quem pode aprovar PRs nos overlays de staging e produção, e nenhuma credencial de cluster exposta fora do ArgoCD. O histórico de commits, tanto no repositório de código quanto no de manifests, funciona como trilha de auditoria de quem mudou o quê e quando.