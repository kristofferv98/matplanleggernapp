

# SwiftOpenAI_StreamingResponse

## Description

SwiftOpenAI_StreamingResponse is a Swift library that provides a simple and efficient way to interact with the OpenAI API. It supports both synchronous and asynchronous requests, and it's designed to handle streaming responses from the OpenAI API.

## Installation

1. Clone the repository:

```bash
git clone https://github.com/kristofferv98/SwiftOpenAI_StreamingResponse.git
```

2. Open the `SwiftOpenAI_StreamingResponse.xcodeproj` file in Xcode.

3. Ensure that you have the necessary dependencies installed. This project uses the Swift Package Manager, with dependencies on Packages:

https://github.com/apple/swift-cmark.git
https://github.com/alfianlosari/GPTEncoder.git
https://github.com/alfianlosari/HighlighterSwift.git
https://github.com/adamrushy/OpenAISwift.git
https://github.com/apple/swift-markdown.git

4. Run the application in Xcode.

## Usage

The application provides a chat interface where users can send messages to the OpenAI GPT-3 API. The responses from the API are displayed in the chat interface in real-time.

## Contributing

Contributions are welcome. Here are some ways you can contribute:

- **Report bugs**: If you find a bug, please create an issue describing the problem and include steps to reproduce it.
- **Suggest enhancements**: If you have an idea for a new feature or an improvement to existing functionality, please create an issue describing your suggestion.
- **Submit pull requests**: If you've developed a bug fix or enhancement, you can submit a pull request. Please ensure that your code follows the existing style for the project and includes comments as necessary.

## Acknowledgments

Much of the code for this project comes from the [ChatGPTSwiftUI](https://github.com/alfianlosari/ChatGPTSwiftUI/tree/task-cancellation-starter) repository by Alfian Losari. 
ChatGPTSwiftUI by Alfian Losari. Alfian's project provided a robust starting point for the implementation of the OpenAI API interaction. His work on handling task cancellation and managing the lifecycle of API requests has been instrumental in shaping this project. 
A big thank you to Alfian for his valuable contribution to the open source community.

The project also uses source code from [Markdownosaur](https://github.com/christianselig/Markdownosaur/blob/main/Sources/Markdownosaur/Markdownosaur.swift) by Christian Selig.
The specific functionalities provided by Markdownosaur that are:

Parsing of Markdown text into NSAttributedString.
Handling of different Markdown elements such as emphasis, strong emphasis, links, inline code, block quotes, ordered and unordered lists, and more.
Applying different styles to the parsed text based on the Markdown element type.
This allows it to display rich text content that is formatted using Markdown syntax.
## License

Please see the [LICENSE](https://github.com/kristofferv98/SwiftOpenAI_StreamingResponse/blob/main/LICENSE) file for details.

## Contact Information

For any questions or concerns, please open an issue on GitHub.

