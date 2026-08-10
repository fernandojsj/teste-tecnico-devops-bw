# Exemplos

Isso aqui não é só trecho ilustrativo: é uma esteira GitOps rodando de verdade (parte na AWS, parte local), pra provar na prática o que está descrito nos blocos 3 e 4.

- [`iac/`](iac/): Terraform (módulos `network` e `ecr`, sem valor hardcoded, tudo parametrizado por `dev.tfvars`/`prd.tfvars`, state remoto em S3). Cria de verdade a VPC e os repositórios ECR (`teste-tecnico-bw-dev`, `teste-tecnico-bw-prd`) usados pelo resto dos exemplos.
- [`app/`](app/): aplicação de exemplo mínima (nginx + `envsubst`) que mostra em qual ambiente está rodando (pod, tag da imagem), usada pra validar a esteira de ponta a ponta.
- [`ci/Jenkinsfile`](ci/Jenkinsfile): o pipeline real, rodando como Multibranch Pipeline. Numa branch de feature/PR, dispara só lint do Dockerfile (hadolint), análise estática (SonarQube) e quality gate. Só depois do merge na `main` é que libera build da imagem, scan de vulnerabilidades (Trivy) e push pro ECR com tag imutável (SHA do commit), do jeito que está descrito no bloco 4.
- [`k8s/`](k8s/): manifests (Deployment + Service) que o ArgoCD sincroniza num cluster Kubernetes, puxando a imagem publicada pelo Jenkins.

**Notas honestas sobre o escopo dessa demo:**
- O Jenkins e o SonarQube rodam numa instância EC2 criada à parte (via AWS CLI, direto, não via Terraform) só pra essa demo ficar visível; não faz parte do módulo de IaC em `iac/`. Num cenário real, essa infraestrutura de CI também seria provisionada como código.
- `k8s/` cobre só o ambiente `dev`, numa branch só. O bloco 4 descreve promoção via branch por ambiente no repositório de manifests (`dev`/`stg`/`prd`); aqui o mecanismo de PR gate e build/scan/push está provado de ponta a ponta, mas a promoção entre ambientes em si não foi replicada na prática, por escopo.
