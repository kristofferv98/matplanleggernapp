import Foundation
import OpenAISwift

# Set your API key
openai.api_key = "your-api-key-here"

# Define your prompt
prompt = "Your prompt goes here"

# Make a request to the OpenAI API
response = openai.Completion.create(
    engine="gpt-3.5-turbo",
    prompt=prompt,
    max_tokens=100,
    n=1,
    temperature=0.3,
)

# Extract the result from the response
result = response.choices[0].text.strip()
print(result)
