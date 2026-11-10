### Pokedex dinamica - Laboratorio 3 - PucMinas

## Api consulmidas

<h4> 
showdown api pokemon
</h4>
<h4> 
pokeapi
</h4>


>comando usados para a criação
>>Separar por traços, pois eles indicam qual comando será para baixar (npm) e qual serão para os arquivos do projeto (react ou Vue)

```python

npm create vite@latest my-react-app -- --template react
ou
npm create vite@latest my-vue-app -- --template vue

ultilizar o ESlint (o mais comum do mercado)
```


## Como testar o projeto

>Pré-requisito: **Node.js 20.19+** (ou 22.12+), exigido pelo Vite 8.

```bash
npm install
cp .env.example .env.local   # preencha com os dados do seu projeto Supabase (opcional)
npm run dev
```

Os favoritos precisam de `VITE_SUPABASE_URL` e `VITE_SUPABASE_PUBLISHABLE_KEY` (ou das
variáveis equivalentes `NEXT_PUBLIC_SUPABASE_URL` e `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`).
Depois de preencher o arquivo de ambiente, reinicie o servidor do Vite.

Depois, abra no navegador o endereço que o Vite mostrar no terminal (normalmente **http://localhost:5173**).

Para gerar a versão de produção: `npm run build` (e `npm run preview` para testá-la).

## Onde estão os dados

Todos os Pokémon, tipos e treinadores vêm do arquivo **`src/data/pokedex-data.json`**.
Não há banco de dados: o arquivo é importado em `src/services/pokedexService.js`.

As imagens dos Pokémon vêm da **PokéAPI** (repositório público de sprites) e as dos treinadores do **Pokémon Showdown**.
As URLs são montadas em `src/config/appConfig.js`.

## Funcionalidades

- Lista de Pokémon com número, nome, tipos e os 6 atributos (HP, Attack, Defense, Special Attack, Special Defense e Speed)
- Pesquisa por nome ou ID, atualizada enquanto se digita
- Filtro por tipo
- Ordenação (número, nome, atributos e total)
- Detalhes do Pokémon com barras de atributos
- Área de treinadores, com insígnias e Pokémon de cada um
- Mensagem quando nenhum Pokémon é encontrado
- Modo noturno e troca do tema do aparelho
- Layout responsivo

## Organização do projeto

```
src/
├── assets/        imagens locais (capas e fundos da Pokédex)
├── components/    um componente por pasta (JSX + CSS):
│                  PokemonCard, PokemonList, SearchBar, TypeFilter, SortControl,
│                  PokemonDetails, StatBar, TrainerList, EmptyState, DeviceShell...
├── config/        configurações gerais e URLs das imagens
├── data/          pokedex-data.json (fonte dos dados)
├── hooks/         useTheme, useSkin, usePokedexFilters, useFavoritos
├── model/         transformação dos dados em objetos (Pokemon, PokemonType, Trainer)
├── services/      busca, filtro e ordenação dos dados
├── utils/         funções auxiliares
├── App.jsx        tela principal, junta os componentes e os estados
├── main.jsx       ponto de entrada
└── index.css      variáveis de cor e tema escuro
```

## Favoritos (opcional)

Os favoritos são salvos no Supabase. Para ativá-los, configure as variáveis de ambiente
acima e execute [`supabase_favorites.sql`](./supabase_favorites.sql) no SQL Editor do
projeto Supabase. O script cria a tabela e as funções RPC usadas pelo aplicativo.
Sem essa configuração, a Pokédex continua funcionando, mas os botões de favoritos ficam
desativados.
