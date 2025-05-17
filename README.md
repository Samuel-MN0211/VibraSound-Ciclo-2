# VibraSound

VibraSound é um aplicativo Flutter com foco em acessibilidade para pessoas surdas, é um metronomo com funcionalidades de vibração, som e controle visual. O projeto é voltado para músicos, professores e entusiastas que desejam praticar com diferentes ritmos e configurações de metrônomo.

## Funcionalidades
- Controle de BPM (batidas por minuto) para cada metrônomo
- Feedback visual, sonoro e por vibração
- Interface intuitiva e responsiva
- Suporte a diferentes gêneros musicais

## Estrutura do Projeto
- `lib/Pages/`: Telas principais do app (ex: múltiplos metrônomos, home, etc)
- `lib/Widgets/`: Componentes reutilizáveis (ex: instância do metrônomo, controladores de BPM)
- `lib/controllers/`: Lógica de controle (ex: som, vibração, torch)
- `lib/Models/`: Modelos de dados (ex: metronome_model, genre_selected_model)
- `assets/`: Arquivos de áudio e dados
- `fonts/`: Fontes customizadas

## Como rodar o projeto
1. Certifique-se de ter o [Flutter](https://flutter.dev/docs/get-started/install) instalado.
2. Clone este repositório:
   ```sh
   git clone https://github.com/Samuel-MN0211/VibraSound-Ciclo-2.git
   ```
3. Instale as dependências:
   ```sh
   flutter pub get
   ```
4. Execute o app:
   ```sh
   flutter run
   ```

## Personalização
- Para novos gêneros musicais, edite `assets/music_genres.json`.


## Licença
[MIT](LICENSE)
