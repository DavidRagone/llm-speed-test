# LLM Speed test

My local attempt at evaluating different LLMs by speed (but also subjectively by
quality of output).


```sh
cat prompt.md | pbcopy
ollama run model_name --verbose
```


## ollama benchmark alternative
See [docs](https://github.com/ollama/ollama/blob/main/docs/benchmark.md)

## TODOs

- [ ] Set up GitHub pages for viewing the html output
- [ ] Try replacing ollama call with [llm](https://github.com/simonw/llm).
