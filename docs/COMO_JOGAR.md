# Miau no Galho

## Como abrir

Abra esta pasta no Godot 4 e execute o projeto com `F6` ou `F5`. A tela inicial será aberta automaticamente.

## Controles

- `A`: olhar para a esquerda.
- `D`: olhar para a direita.
- `Espaço`: segurar para carregar o salto e soltar para lançar Mimi.

Durante o salto não há controle no ar. O objetivo é alcançar o ninho no 15º galho.

## HUD

- `PULOS`: quantidade de saltos lançados.
- Relógio: tempo da tentativa.
- Barra lateral: progresso até o ninho.
- Barra inferior: força acumulada enquanto o Espaço está pressionado.

## ESP32

O jogo também escuta comandos UDP na porta `4242`. O ESP32 deve enviar mensagens para o computador na mesma rede:

```text
LEFT=1
LEFT=0
RIGHT=1
RIGHT=0
JUMP=1
JUMP=0
```

O teclado e o ESP32 podem ser usados como entradas alternativas.
Por enquanto, o projeto contém apenas o receptor no Godot. Não há firmware do ESP32 nem pareamento automático nesta pasta: é preciso configurar o ESP32 para enviar os comandos ao IP do computador.

Para o controle físico, a proposta é um ESP32 com três botões (esquerda, direita e salto) ligados a GPIOs com pull-up interno. O firmware deve enviar o estado de cada botão por Wi-Fi/UDP ao IP do computador na porta `4242`, incluindo o evento de soltar. Enquanto algum botão estiver pressionado, deve reenviar os estados periodicamente; o receptor zera todas as entradas após 2 segundos sem pacotes.

## Estrutura do projeto

- `scenes/menu_inicial.tscn`: tela inicial.
- `scenes/fase_miau.tscn`: fase vertical com 15 galhos.
- `scenes/vitoria.tscn`: tela de vitória.
- `scenes/derrota.tscn`: tela de derrota.
- `scripts/gameplay/`: lógica da fase, cenário, Mimi e galhos.
- `scripts/gameplay/mimi.gd`: carga e lançamento dos saltos.
- `scripts/gameplay/galho.gd`: galhos fixos, móveis e ninho final.
- `scripts/ui/`: menu, HUD e telas finais.
- `scripts/ui/hud_miau.gd`: pulos, tempo, carga do salto e progresso.
- `scripts/systems/`: áudio e comunicação com o ESP32.
- `assets/provisorios/`: arte temporária. Sprites do Mario representam Mimi nos menus e na fase, tijolos formam as plataformas, uma moeda marca o objetivo, e nuvens, morros e arbustos compõem os fundos. A interface usa a fonte Pixelify Sans da mesma pasta.
- `docs/`: documentação do projeto.
