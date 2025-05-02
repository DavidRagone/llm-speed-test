# LLM Speed test

My local attempt at evaluating different LLMs by speed (but also subjectively by
quality of output).

Probably better off replacing this with [llm](https://github.com/simonw/llm).

```sh
cat prompt.md | pbcopy
ollama run model_name --verbose
```

| Service | Model | Total duration | Prompt eval count | Prompt eval duration | Prompt eval rate | eval count | eval duration | eval rate | file | passes? | error(s) |
| ------- | ----- | -------------- | ----------------- | -------------------- | ---------------- | ---------- | ------------- | --------- | ---- | ------- | -------- |
| ollama | deepseek-r1:7b | 40.019s | 31.3215ms | 157 token(s) | 325.31ms | 482.62 tokens/s | 3013 token(s) | 39.66s | 75.97 tokens/s | [thinking](results/deepseek-r1:7b.md) [html](results/deepseek-r1:7b.html) | FALSE | `Uncaught SyntaxError: Unexpected identifier 'hovered'` |
| ollama | qwen3:32b | 2m35.796s | 33.6295ms | 162 token(s) | 1.34s | 120.19 tokens/s | 3176 token(s) | 2m34.41s | 20.57 tokens/s | [thinking](results/qwen3:32b.md) [html](results/qwen3:32b.html) | TRUE | |


## ollama benchmark alternative
See [docs](https://github.com/ollama/ollama/blob/main/docs/benchmark.md)
