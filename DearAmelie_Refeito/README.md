# Dear Amelie — reconstrução independente

**Abra ESTA pasta como um projeto separado na Godot 4.6.** Não abra o `project.godot` antigo da raiz do repositório.

## Como jogar
1. Baixe a branch `desenvolvimento-v2` em ZIP e extraia.
2. Abra Godot > Importar > selecione `DearAmelie_Refeito/project.godot`.
3. Execute com **F6** (cena aberta) ou **F5** (projeto).
4. **WASD/setas**: andar. **E**: interagir. **Enter/espaço**: avançar diálogo. **1/2**: escolhas. **Shift**: correr na perseguição. **R**: reiniciar após o final.

## Conteúdo
- Menu e prólogo
- Entrada da casa, busca pela chave, corredor e quarto
- Lanterna, fotografia, recortes e diário
- Escolha de esconderijo, cena do carro
- Fuga na floresta, jardim de lírios e epílogo com psicóloga

Arte vetorial provisória desenhada pelo código. Nenhuma dependência externa. Esta é uma **vertical slice experimental**: não é o jogo final e ainda precisa de teste real no editor Godot. Não contém sprites ou áudio originais.

## Estrutura
- `project.godot`: projeto independente
- `scenes/main.tscn`: cena principal
- `scripts/game.gd`: movimentação, desenho, diálogos e estados

A história completa e os assets finais serão incorporados em etapas sem comprometer o jogo antigo.
