# Teste Técnico: DevOps / Engenharia de Plataforma

O teste está dividido em 5 blocos, indo do conceitual ao design de esteira CI/CD, com foco em **GitOps**. As respostas, diagramas e exemplos práticos foram organizados em pastas para facilitar a leitura e a avaliação.

## Estrutura do repositório

- [`respostas/`](respostas/): respostas discursivas dos 5 blocos, em Markdown. Comece por aqui: cada arquivo traz a pergunta do enunciado seguida da resposta.
- [`diagramas/`](diagramas/): diagrama da esteira CI/CD (fonte `.drawio` + PNG exportado), referenciado no bloco 4.
- [`exemplos/`](exemplos/): não é só trecho ilustrativo: é uma esteira GitOps rodando de verdade (Terraform criando infraestrutura real na AWS, Jenkins + SonarQube fazendo build/scan/push de verdade, ArgoCD sincronizando um cluster Kubernetes). Detalhes em [`exemplos/README.md`](exemplos/README.md).

## Sobre o histórico de commits

Os commits são incrementais e refletem o raciocínio ao longo do teste: primeiro cada bloco de resposta, depois ajustes de consistência entre eles conforme o desenho evoluiu, depois a implementação prática em `exemplos/`.
