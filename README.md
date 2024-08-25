# Eventugo - Sistema de Gerenciamento de Créditos para Eventos

## Índice

1. [Cabeçalho](#cabeçalho)
2. [Descrição do Projeto](#descrição-do-projeto)
3. [Sprints](#sprints)
4. [User Stories](#user-stories)
5. [Requisitos](#requisitos)

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

## User Stories
                                                       
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
