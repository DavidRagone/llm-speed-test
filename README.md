# LLM Speed test

My local attempt at evaluating different LLMs by speed (but also subjectively by
quality of output).


```sh
cat prompt.md | pbcopy
ollama run model_name --verbose
```

| Device | Service | Model | Total duration | Load duration | Prompt eval count | Prompt eval duration | Prompt eval rate | eval count | eval duration | eval rate | file | passes? | error(s) |
| ------ | ------- | ----- | -------------- | ------------- | ----------------- | -------------------- | ---------------- | ---------- | ------------- | --------- | ---- | ------- | -------- |
| Mac M3 Ultra 512GB | ollama | deepseek-r1:7b | 40.019s | 31.3215ms | 157 token(s) | 325.31ms | 482.62 tokens/s | 3013 token(s) | 39.66s | 75.97 tokens/s | [thinking](results/deepseek-r1:7b.md) [html](results/deepseek-r1:7b.html) | FALSE | `Uncaught SyntaxError: Unexpected identifier 'hovered'` |
| Mac M3 Ultra 512GB |  ollama | qwen3:32b | 2m35.796s | 33.6295ms | 162 token(s) | 1.34s | 120.19 tokens/s | 3176 token(s) | 2m34.41s | 20.57 tokens/s | [thinking](results/qwen3:32b.md) [html](results/qwen3:32b.html) | TRUE | |
| Mac M3 Ultra 512GB | ollama | gemma3:27b | 1m41.972s | 57.408ms | 168 token(s) | 949.41ms | 176.95 tokens/s | 2576 token(s) | 1m40.96s | 25.51 tokens/s | [thinking](results/gemma3:27b.md) [html](results/gemma3:27b.html) | TRUE | planets spin nearly off page |
| Windows i5-12600K 32GB RAM, AMD 6950 XT | ollama | deepseek-r1:7b | 53.447s | 18.7579ms | 150 token(s) | 192.6693ms | 778.54 tokens/s | 3945 token(s) | 53.233s | 74.11 tokens/s | [thinking](results/deepseek-r1:7b_windows.md) [html](results/deepseek-r1:7b_windows.html) | FALSE | `Uncaught SyntaxError: Unexpected identifier 'day'` |


## ollama benchmark alternative
See [docs](https://github.com/ollama/ollama/blob/main/docs/benchmark.md)

## TODOs

- [ ] Set up GitHub pages for viewing the html output
- [ ] Try replacing ollama call with [llm](https://github.com/simonw/llm).
