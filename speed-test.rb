# Check to see if the model has already been measured on this computer, skip if true
# else run command, store full response text in one file, pull out html for another file, and then store timing data
# tbd on how/whether to update README / git commit

require 'httparty'
require 'json'
require 'fileutils'
require 'highline'
require 'redcarpet'

# Given text input, find and return the code block within it as demarcated by three backticks at the start and end, with an optional language identifier
def extract_code_block(text)
  # Thank you, Simon https://github.com/simonw/llm/blob/9a39af82cdbd064edff99e753e506e03bb0b0796/llm/utils.py#L193C5-L201C90
  # Regex pattern to match fenced code blocks
    # - ^ or \n ensures that the fence is at the start of a line
    # - (`{3,}) captures the opening backticks (at least three)
    # - (\w+)? optionally captures the language tag
    # - \n matches the newline after the opening fence
    # - (.*?) non-greedy match for the code block content
    # - (?P=fence) ensures that the closing fence has the same number of backticks
    # - [ ]* allows for optional spaces between the closing fence and newline
    # - (?=\n|$) ensures that the closing fence is followed by a newline or end of string
  pattern = /(^|\n)(`{3,})(\w+)?\n(.*?)\n(?=\2[ ]*\n|$)/m
  match = text.match(pattern)
  if match
    # Extract the code block content
    code_block = match[4]
    # Remove leading and trailing whitespace
    code_block.strip!
    # Return the code block
    return code_block
  else
    # If no match is found, return nil or an empty string
    return nil
  end
end

def log_run(response)
  total_duration = (response['total_duration'].to_f / 10**9).round(3)
  load_duration = (response['load_duration'].to_f / 10**9).round(3)
  prompt_eval_count = response['prompt_eval_count']
  prompt_eval_duration = (response['prompt_eval_duration'].to_f / 10**9).round(3)
  eval_count = response['eval_count']
  eval_duration = (response['eval_duration'].to_f / 10**10).round(3)

  prompt_eval_rate = prompt_eval_count / prompt_eval_duration if prompt_eval_duration > 0
  eval_rate = eval_count / eval_duration if eval_duration > 0

  # append to File
  File.open('results.md', 'a') do |file|
    file.puts "| #{device} | #{service} | #{model} | #{total_duration} | #{load_duration} | #{prompt_eval_count} | #{prompt_eval_duration} | #{prompt_eval_rate} | #{eval_count} | #{eval_duration} | #{eval_rate} | [thinking](results/#{results_filename}.md) [html](results/#{results_filename}.html) | tbd | tbd |\n"
  end
end

def test_model(system, service, model, stream = false)
  # system = "Windows", "Mac"
  # service = "ollama"
  # model = "llama2"
  # prompt = "What is the capital of France?"
  # stream = false

  puts "-----\nTesting model: #{model} on system: #{system} with service: #{service} and stream: #{stream}\n-----"

  prompt = File.read('./prompt.md')

  if service == "ollama"
    # curl -X POST -H "Content-Type: application/json" -d '{ "model": "llama2", "prompt": "What is the capital of France?", "stream": false }' http://localhost:11434/api/generate
    url = "http://localhost:11434/api/generate"
    data = { model: model, prompt: prompt, stream: stream }
    headers = { 'Content-Type' => 'application/json' }

    response = HTTParty.post(url, body: data.to_json, headers: headers, timeout: 1200)
  else
    raise "Service not supported"
  end

  full_results = response['response']

  code = extract_code_block(full_results)

  File.write("#{results_filename}.md", full_results)
  File.write("#{results_filename}.html", code) if code

  log_run(response, results_filename)
end


# CLI setup
cli = HighLine.new
system = cli.ask("What system are you on (e.g,. Mac M3 Ultra 512GB)? ") { |q| q.default = "Mac M3 Ultra 512GB" }
service = ""
model = ""

cli.choose do |menu|
  menu.prompt = "What service will run the model?"
  menu.choice(:ollama) { service = "ollama" }
  menu.default = :ollama
end

if service == "ollama"
  url = "http://localhost:11434/api/tags"
  model_list = HTTParty.get(url)['models'].map { |model| "#{system} #{service} #{model['name']}" }
  tested_models = File.read('./results.md')
  # tested_models is a markdown table, need to convert it to a list of models. Currently, device, service, and model are the 
  #   first, second, and thir columns, and we need to ignore the first two rows (header and separator)
  tested_models = tested_models.split("\n").map { |line| "#{line.split("|")[1].strip} #{line.split("|")[2].strip} #{line.split("|")[3].strip}" }[2..-1]
  available_models = (model_list - tested_models).map do |string|
    # Need to remove the system and service from the string. Full string looks like "Mac M3 Ultra 512GB ollama deepseek-r1:32b"
    string.split(" ")[-1]
  end

  cli.choose do |menu|
    menu.prompt = "What model are you testing?" 
    available_models.each do |m|
      menu.choice(m) { model = m }
    end
  end
else
  raise "Service not supported"
  # TODO if not ollama
end

results_filename = "results/#{model}"
if system.include?("Windows")
  results_filename << "_windows"
end

# Run the program
test_model(system, service, model)