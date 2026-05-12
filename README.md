# AWS Glue ETL Pipeline com Terraform

## Visão Geral

Este projeto cria uma pipeline ETL utilizando:

* AWS S3
* AWS Glue
* AWS Glue Crawler
* AWS Glue Catalog Database
* AWS IAM
* Terraform
* PySpark

O objetivo do projeto é:

1. Armazenar arquivos CSV no S3
2. Catalogar automaticamente os dados usando Glue Crawler
3. Executar um Glue Job em PySpark
4. Processar os dados
5. Salvar o resultado em outro bucket S3
6. Utilizando a terraform com IaC

---

# Arquitetura

## Buckets S3

| Bucket                  | Finalidade              |
| ----------------------- | ----------------------- |
| `ph-source-data-bucket` | Arquivos CSV de entrada |
| `ph-code-bucket`        | Scripts Glue e logs     |
| `ph-target-data-bucket` | Dados processados       |

---

# Estrutura do Projeto

```text
s3_read_write_etl_glue_pipeline/
│
├── data_file/
│   ├── script.py
│   └── organizations.csv
│
├── buckets.tf
├── catalog_crawler.tf
├── glue_job.tf
├── glue_service_role.tf
├── provider.tf
├── versions.tf
├── vars.tf
└── README.md
```

# Pré-requisitos

## Instalar Terraform

Download:

[https://developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads)

Validar instalação:

```powershell
terraform -version
```

---

## Configurar AWS CLI

Instalar:

[https://aws.amazon.com/cli/](https://aws.amazon.com/cli/)

Configurar credenciais:

```powershell
aws configure
```

Informar:

* AWS Access Key
* AWS Secret Key
* Região
* Output format

---

# Arquivos Terraform

## buckets.tf

Responsável por:

* Criar buckets S3
* Fazer upload do CSV
* Fazer upload do script Glue

Exemplo:

```hcl
resource "aws_s3_bucket" "xxxx-data-bucket" {
  bucket        = "xxxx-data-bucket"
  force_destroy = true
}
```

---

## catalog_crawler.tf

Responsável por:

* Criar Glue Catalog Database
* Criar Glue Crawler
* Criar Trigger do Crawler

Exemplo:

```hcl
resource "aws_glue_catalog_database" "org_report_database" {
  name         = "org-report"
  location_uri = "s3://${aws_s3_bucket.xxxx-data-bucket.id}/"
}
```

---

## glue_service_role.tf

Responsável por:

* Criar IAM Role
* Criar permissões necessárias para Glue

---

## glue_job.tf

Responsável por:

* Criar AWS Glue Job
* Definir worker
* Definir parâmetros
* Apontar script PySpark

Exemplo:

```hcl
resource "aws_glue_job" "xxxx_test_job1" {

  name     = "xxxx_job1"
  role_arn = "xxxxxx"

  glue_version = "5.0"

  worker_type       = "G.1X"
  number_of_workers = 10

  command {
    name            = "glueetl"
    script_location = "xxxx/script.py"
    python_version  = "3"
  }
}
```

---

# Script PySpark

Arquivo:

```text
script.py
```

Responsável por:

* Ler dados do Glue Catalog
* Aplicar transformação
* Salvar dados processados no S3

---

# Parâmetros do Glue Job

## Parâmetros utilizados

| Key             | Value                                 |
| --------------- | ------------------------------------- |
| `--INPUT_PATH`  | `s3://xxxx-source-data-bucket/`         |
| `--OUTPUT_PATH` | `s3://xxxxx-target-data-bucket/`         |
| `--conf`        | `spark.eventLog.rolling.enabled=true` |

---

# Passo a Passo de Execução

## 1. Inicializar Terraform

```powershell
terraform init
```

---

## 2. Formatar arquivos Terraform

```powershell
terraform fmt
```

---

## 3. Validar sintaxe

```powershell
terraform validate
```

---

## 4. Visualizar plano de execução

```powershell
terraform plan
```

---

## 5. Criar infraestrutura

```powershell
terraform apply
```

Confirmar:

```text
yes
```

---

# Atualizar Apenas o script.py

Quando alterar somente o script Glue:

```powershell
terraform apply -target="aws_s3_bucket_object.code-data-object"
```

---

# Atualizar Apenas o Glue Job

```powershell
terraform apply -target="aws_glue_job.ph_terraform_test_job1"
```

---

# Executar o Glue Crawler

1. Abrir AWS Glue
2. Crawlers
3. Selecionar:

```text
xxxx-report-crawler
```

4. Run crawler

---

# Executar o Glue Job

1. Abrir AWS Glue
2. Jobs
3. Selecionar:

```text
xxx_terraform_test_job1
```

4. Run job

---

# Verificar Resultado

## Dados de saída

Bucket:

```text
s3://xxxx-target-data-bucket/
```

---

## Logs

CloudWatch:

```text
/aws-glue/jobs/output
```

---

# Comandos Terraform Importantes

## Ver recursos do state

```powershell
terraform state list
```

---

## Ver detalhes de um recurso

```powershell
terraform state show aws_glue_job.xxx_terraform_test_job1
```

---

## Destruir infraestrutura

```powershell
terraform destroy
```

---

# Problemas Comuns


## Terraform não detecta mudança no script.py

Adicionar:

```hcl
etag = filemd5("caminho/script.py")
```

---

## Glue Crawler com path incorreto

Errado:

```hcl
path = "xxxx-source-data-bucket/"
```

Correto:

```hcl
path = "s3://xxxxx-source-data-bucket/"
```

---

# Melhorias Futuras

* Particionamento de dados
* Parquet ao invés de CSV
* Athena
* Lake Formation
* CI/CD com GitHub Actions
* Terraform Modules
* Versionamento S3
* Glue Workflows

---

# Tecnologias Utilizadas

* Terraform
* AWS Glue
* AWS S3
* AWS IAM
* PySpark
* AWS Glue Catalog
* AWS Glue Crawler
* CloudWatch

---

# Autor

Projeto desenvolvido para estudo e automação de pipelines ETL utilizando AWS Glue e Terraform.
