# Eventugo - Sistema de Gerenciamento de Créditos para Eventos

Author: [Eliezer](https://github.com/Liezy) 25/08/2024

## Índice

- [Eventugo - Sistema de Gerenciamento de Créditos para Eventos](#eventugo---sistema-de-gerenciamento-de-créditos-para-eventos)
  - [Índice](#índice)
  - [Cabeçalho](#cabeçalho)
  - [Descrição do Projeto](#descrição-do-projeto)
  - [Sprints](#sprints)
  - [Modelo Arquitetural](#modelo-arquitetural)
  - [MVP - Minimun Viable Product](#mvp---minimun-viable-product)
  - [User Stories](#user-stories)
  - [Protótipo](#protótipo)
  - [Requisitos](#requisitos)
- [Rodando o Projeto](#rodando-o-projeto)
  - [Django/Backend](#djangobackend)
  - [Flutter/Frontend](#flutterfrontend)

## Cabeçalho

**Curso:** Bacharelado em Ciência da Computação  
**Disciplina:** Projeto de Sistemas  
**Professor:** Edeilson Milhomem da Silva  
**Integrantes:**  
- Daniel Reis Aruda Sales  
- Douglas Ribeiro Santos de Sá  
- Eliézer Alencar Moreira  
- Ícaro Mesquita Ponce  
- Murilo Rodrigues Pereira

## Descrição do Projeto

O Eventugo é uma solução desenvolvida para facilitar a gestão de créditos em eventos, substituindo as tradicionais comandas físicas por um sistema digital. O projeto visa criar uma experiência mais conveniente e segura para os participantes, que poderão recarregar e utilizar seus créditos por meio de um aplicativo móvel. O sistema permite a realização de transações utilizando QR codes, com visualização de saldo em tempo real e acompanhamento do histórico de transações.

## Links Importantes

- **Download do App (APK):** [Clique aqui para baixar o aplicativo](https://github.com/Liezy/EventuGO/releases/download/V4.0.0/app-release.apk)
- **Acesse o Painel Administrativo:** [Clique aqui para acessar](https://1a19-200-129-179-189.ngrok-free.app/auth/login/)

## Sprints
Acesse o planejamento das sprints [aqui.](https://alluring-sail-8e9.notion.site/Sprints-fffca21a82e280b89075d5bef259910e?pvs=4)

## Modelo Arquitetural
Acesse o modelo arquitetural do projeto [aqui.](https://github.com/user-attachments/files/16748555/Modelo.Arquitetural.pdf)

## MVP - Minimun Viable Product
Acesse o MVP [aqui.](https://alluring-sail-8e9.notion.site/Defini-o-do-MVP-a0464e5c8f5444a0993eddd301fc9ce1?pvs=4)

## User Stories
Acesse o detalhamento das User Stories [aqui.](https://alluring-sail-8e9.notion.site/Detalhamento-das-User-Stories-60e8092f3edc454ea815fc32a8bf64ba?pvs=4)

## Protótipo
Acesse a prototipação do projeto [aqui.](https://www.figma.com/design/oF9N9hW6o6fzogKO31sm7A/EventuGo?node-id=0-1&t=fYKQsmzHXQXbOXxm-0)
                                                       
## Requisitos
Acesse a documentacao de requisitos [aqui.](https://www.notion.so/Requisitos-19410764685341c2ae18efe3d066648a?pvs=4)


# Rodando o Projeto 

Author: [Ícaro](https://github.com/icarompo) 16/09/2024

## Django/Backend

1. Primeiramente, clone o repositório do projeto:
```bash
git clone https://github.com/Liezy/EventuGO.git
```

2. Acesse a pasta do projeto:
```bash
cd EventuGO/EventuGo
```

3. Crie um ambiente virtual:
```bash
python -m venv venv
```

4. Ative o ambiente virtual(Se estiver no windows faça pelo cmd ou powershell):
```bash
venv/scripts/activate
ou
source venv/bin/activate
```

Obs: pode ser necessário dar permissão de execução para o arquivo de ativação do ambiente virtual. Para isso, execute o comando:
```bash
Set-ExecutonPolicy RemoteSigned 
ou
chmod +x venv/bin/activate
```

5. Instale as dependências do projeto (caso haja algum):
```bash
pip install -r requirements.txt
```

6. Execute as migrações do banco de dados:
```bash
python manage.py migrate
```

7. Crie um superusuário para acessar o painel administrativo:
```bash
python manage.py createsuperuser
```

8. Execute o servidor:
```bash
python manage.py runserver
```

+ Caso tenha adicionado novas dependências ao projeto, atualize o arquivo `requirements.txt`:
```bash
pip freeze > requirements.txt
```

## Flutter/Frontend

Primeiramente certifique-se de ter o Flutter instalado em sua máquina. Para isso, siga as instruções disponíveis na [documentação oficial](https://flutter.dev/docs/get-started/install).

1. Acesse a pasta do projeto:
```bash
cd /app
```

2. Rode o projeto:
```bash
flutter run
```

3. Caso necessário, instale as dependências do projeto:
```bash
flutter pub get
```
