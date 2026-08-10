*5.1  Explique idempotência e por que ela importa em Infraestrutura como Código.*

Pensar em idempotência é simples, você pode rodar a mesma ação uma, dez ou cem vezes, e o resultado final vai ser sempre o mesmo. Não duplica nada, não quebra nada por já existir e deixa o ambiente exatamente no estado esperado.

Isso é o coração de IaC e GitOps. Ferramentas como Terraform, kubectl apply ou ArgoCD vivem rodando retries, recuperando falhas ou fazendo reconciliações periódicas. Se a operação não fosse idempotente, cada nova execução arriscaria criar recursos duplicados, estourar erros de "já existe" ou bagunçar a infraestrutura.

No fim do dia, é isso que faz o modelo declarativo funcionar na prática, você define o estado desejado e tem a certeza de que aplicar aquilo de novo, a qualquer momento, não vai causar nenhum estrago. Sem idempotência, automatizar a reconciliação contínua seria um risco que ninguém ia querer correr.

Um exemplo prático da diferença: `kubectl apply -f deployment.yaml` é idempotente, roda uma vez ou dez vezes seguidas e o resultado é o mesmo Deployment convergido pro estado do arquivo. Já `kubectl create -f deployment.yaml` não é, a primeira vez cria o recurso, a segunda vez quebra com erro de "already exists". É exatamente por isso que ferramentas de reconciliação contínua, como o ArgoCD, usam `apply` por baixo dos panos, e não `create`.

*5.2  Qual a diferença entre GitOps e Infraestrutura como Código (IaC)? Eles competem ou se complementam?*

IaC é o conceito mais amplo, descrever a infraestrutura como código (Terraform e CloudFormation) em vez de configurar as coisas na mão. Não define como esse código é aplicado, só que ele existe versionado.

GitOps é mais específico, é um jeito de operacionalizar IaC onde o Git é a única fonte de verdade e um agente (ex: ArgoCD) fica dentro do próprio ambiente aplicando e reconciliando continuamente, no modelo pull que descrevi no bloco 1.

Eles se complementam, não competem. Na prática, uso os dois em camadas diferentes: Terraform (IaC, modelo push, geralmente rodando via pipeline) pra provisionar a infraestrutura que ainda não existe, tipo VPC, o cluster Kubernetes, banco de dados, IAM. E GitOps (ArgoCD) pra tudo que roda dentro desse cluster depois que ele já existe, porque aí sim tem um agente rodando lá dentro pra reconciliar. Um não substitui o outro, um resolve o "antes de existir o cluster" e o outro resolve o "depois que o cluster existe".

*5.3  Um dev fez kubectl edit direto em produção para "resolver rápido". Quais os riscos, e como o GitOps trata isso?*

Os riscos são os mesmos que já falei no bloco 1 sobre o modelo push: a mudança fica sem histórico, sem revisão de ninguém, e o cluster passa a divergir do que está declarado no Git. Se outra pessoa (ou o próprio ArgoCD) mexer de novo naquele recurso, ninguém vai saber que aquele ajuste manual existia. E se for algo que precisa se repetir em outro ambiente, esse conhecimento fica só na cabeça de quem fez o `kubectl edit`, não em lugar nenhum versionado.

O GitOps trata isso do jeito que descrevi na parte de rollback do bloco 4: como o ArgoCD reconcilia continuamente, ele vai detectar essa mudança manual como uma divergência entre o Git e o cluster, e se o auto sync estiver ligado, ele reverte sozinho, sem nem avisar que "corrigiu" o que o dev tinha feito. Ou seja, o `kubectl edit` na melhor das hipóteses dura até o próximo ciclo de sync. Se for uma emergência real, o certo é ou pausar o auto sync daquele Application no ArgoCD enquanto o ajuste manual estiver valendo, ou (melhor ainda) já resolver direto via commit no Git, porque assim o ArgoCD aplica a correção do jeito certo e ela fica documentada.

*5.4  Você usaria GitOps para tudo? Cite um caso em que ele não é a melhor escolha.*

Não. GitOps funciona bem quando existe um agente rodando dentro do ambiente que ele está gerenciando, tipo o ArgoCD dentro do cluster Kubernetes. O caso claro em que ele não serve é pra provisionar a infraestrutura que esse cluster precisa pra existir: VPC, subnets, o próprio cluster EKS, IAM, banco de dados gerenciado. Não tem como um agente GitOps reconciliar um cluster que ainda não foi criado, então essa camada continua sendo IaC no modelo push (Terraform rodando via pipeline), como comentei na 5.2.

Outro caso onde não vale a pena forçar GitOps é em ação pontual e manual por natureza, tipo uma migration de banco que precisa de julgamento humano no momento de rodar, ou um debug emergencial. Forçar isso a passar por commit, PR e reconciliação só adiciona atraso numa situação que já é, por definição, única e não repetível.