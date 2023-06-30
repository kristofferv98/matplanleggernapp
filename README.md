# SwiftOpenAI_StreamingResponse

SwiftOpenAI_StreamingResponse is a Swift library designed to interact with the OpenAI API. It supports both synchronous and asynchronous requests and is capable of handling streaming responses from the OpenAI API.

## Installation

1. Clone the repository:

```bash
git clone https://github.com/kristofferv98/SwiftOpenAI_StreamingResponse.git
```

2. Open the `SwiftOpenAI_StreamingResponse.xcodeproj` file in Xcode.

3. The project uses the Swift Package Manager for dependencies. Ensure that the following packages are available:

- [swift-cmark](https://github.com/apple/swift-cmark.git)
- [GPTEncoder](https://github.com/alfianlosari/GPTEncoder.git)
- [HighlighterSwift](https://github.com/alfianlosari/HighlighterSwift.git)
- [OpenAISwift](https://github.com/adamrushy/OpenAISwift.git)
- [swift-markdown](https://github.com/apple/swift-markdown.git)

4. Run the application in Xcode.

## Usage

The application provides a chat interface for interaction with the OpenAI GPT-3 API. Users can send messages to the API, and the responses are displayed in the chat interface in real-time.

## Contributing

Contributions are welcome. You can contribute by:

- **Reporting bugs**: Create an issue describing the problem and include steps to reproduce it.
- **Suggesting enhancements**: If you have an idea for a new feature or an improvement to existing functionality, please create an issue describing your suggestion.
- **Submitting pull requests**: If you've developed a bug fix or enhancement, you can submit a pull request. Please ensure that your code follows the existing style for the project and includes comments as necessary.

## Acknowledgments

This project is inspired by and uses code from the following sources:

- [ChatGPTSwiftUI](https://github.com/alfianlosari/ChatGPTSwiftUI/tree/task-cancellation-starter) by Alfian Losari. Alfian's project provided a robust starting point for the implementation of the OpenAI API interaction. His work on handling task cancellation and managing the lifecycle of API requests has been instrumental in shaping this project. A big thank you to Alfian for his valuable contribution to the open source community.

- [Markdownosaur](https://github.com/christianselig/Markdownosaur/blob/main/Sources/Markdownosaur/Markdownosaur.swift) by Christian Selig. Markdownosaur is a Swift-based Markdown parser that outputs NSAttributedString. It handles different Markdown elements and applies different styles to the parsed text based on the Markdown element type. This allows the project to display rich text content that is formatted using Markdown syntax.

## License

This project is licensed under the MIT License. Please see the [LICENSE](https://github.com/kristofferv98/SwiftOpenAI_StreamingResponse/blob/main/LICENSE) file for details.

## Contact Information

For any questions or concerns, please open an issue on GitHub.

