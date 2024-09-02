# Eventugo - Sistema de Gerenciamento de Créditos para Eventos

## Índice

1. [Cabeçalho](#cabeçalho)
2. [Descrição do Projeto](#descrição-do-projeto)
3. [Sprints](#sprints)
4. [Modelo Arquitetural](#modelo-arquitetural)
5. [MVP - Minimun Viable Product](#mvp---minimun-viable-product)
6. [User Stories](#user-stories)
7. [Protótipo](#protótipo)
8. [Requisitos](#requisitos)

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

## Sprints

## Planejamento
Acesse o planejamento do projeto [aqui.](https://alluring-sail-8e9.notion.site/Planejamento-das-Sprints-fffca21a82e280b89075d5bef259910e?pvs=4)

## Modelo Arquitetural
Acesse o modelo arquitetural do projeto [aqui.](https://github.com/user-attachments/files/16748555/Modelo.Arquitetural.pdf)

## MVP - Minimun Viable Product
Acesse o MVP [aqui.](https://alluring-sail-8e9.notion.site/Defini-o-do-MVP-a0464e5c8f5444a0993eddd301fc9ce1?pvs=4)

## User Stories

Acesse o detalhamento das User Stories [aqui.](https://alluring-sail-8e9.notion.site/Detalhamento-das-User-Stories-60e8092f3edc454ea815fc32a8bf64ba?pvs=4)

## Protótipo
Acesse a prototipação do projeto [aqui.](https://www.figma.com/design/oF9N9hW6o6fzogKO31sm7A/EventuGo?node-id=0-1&t=fYKQsmzHXQXbOXxm-0)
                                                       
## Requisitos

### Requisitos Funcionais (RF)

1. **RF01 - Cadastro de Usuário:**  
   O sistema deve permitir o cadastro de usuários com informações básicas (nome, e-mail, senha, etc.).

2. **RF02 - Autenticação de Usuário:**  
   O sistema deve permitir que o usuário faça login utilizando e-mail e senha.

3. **RF03 - Gerenciamento de Eventos:**  
   O sistema deve permitir a criação, edição e exclusão de eventos.

4. **RF04 - Visualização de Saldo:**  
   O usuário deve poder visualizar o saldo disponível em sua conta.

5. **RF05 - Recarga de Saldo:**  
   O sistema deve permitir a recarga de saldo por meio de diferentes formas de pagamento.

6. **RF06 - Realização de Transações:**  
   O usuário deve poder realizar transações utilizando QR codes para pagamento em eventos.

7. **RF07 - Histórico de Transações:**  
   O sistema deve exibir um histórico das transações realizadas pelo usuário.

### Requisitos Não Funcionais (RNF)

1. **RNF01 - Segurança:**  
   O sistema deve implementar autenticação JWT para proteger as rotas da API.

2. **RNF02 - Escalabilidade:**  
   O sistema deve ser escalável para suportar múltiplos eventos e usuários simultaneamente.

3. **RNF03 - Desempenho:**  
   O tempo de resposta para as operações críticas (login, transações) deve ser inferior a 2 segundos.

4. **RNF04 - Usabilidade:**  
   A interface deve ser intuitiva e fácil de usar, com foco na experiência do usuário.
