import Foundation

// This struct represents a single message in a conversation.
struct Message: Codable {
    let role: String  // Indicates who sent the message (e.g., "user" or "assistant").
    let content: String  // Contains the actual text of the message.

}


// This extension allows us to perform operations specifically on arrays of Message objects.
// Extension on Array to add a computed property called contentCount.
// contentCount calculates the total character count of the content property for all messages in the array.
extension Array where Element == Message {
    var contentCount: Int {
        reduce(0, { $0 + $1.content.count })  // Adds up the number of characters in the content of all messages.
    }
}


// This struct represents a request for text generation, including the model, temperature, conversation messages, and streaming preference.
struct Request: Codable {
    let model: String  // Specifies the model to use for text generation (e.g., "gpt-3.5-turbo").
    let temperature: Double  // Controls the randomness in the generated text (higher values result in more randomness).
    let messages: [Message]  // Contains an array of messages representing the conversation.
    let stream: Bool  // Indicates whether to use streaming for the response (true for streaming, false for regular response).
}


// This struct represents a root-level error response, including details about the error that occurred.
struct ErrorRootResponse: Decodable {
    let error: ErrorResponse  // Provides information about the error.
}



// This struct represents an error response, including the error message and, if applicable, the error type.
struct ErrorResponse: Decodable {
    let message: String  // Describes the error that occurred.
    let type: String?  // Optionally specifies the type of error (if available).
}



// This struct represents a response for stream completion, including multiple stream choices.
struct StreamCompletionResponse: Decodable {
    let choices: [StreamChoice]  // Contains an array of stream choices.
}



// This struct represents a completion response, including multiple completion choices and, optionally, usage statistics.
struct CompletionResponse: Decodable {
    let choices: [Choice]  // Contains an array of completion choices.
    let usage: Usage?  // Optionally provides usage statistics for the completion response.
}



// This struct represents usage statistics for a completion response, including the counts of prompt tokens, completion tokens, and total tokens used.
struct Usage: Decodable {
    let promptTokens: Int?  // Indicates the number of tokens in the input prompt.
    let completionTokens: Int?  // Indicates the number of tokens generated in the completion.
    let totalTokens: Int?  // Indicates the total number of tokens used in the API call.
}



// This struct represents a choice in a completion response, including the generated message and, if available, the reason for completion.
struct Choice: Decodable {
    let message: Message  // Contains the generated message.
    let finishReason: String?  // Optionally provides the reason for completion (if available).
}



// This struct represents a choice in a stream completion response, including the reason for completion and the generated message.
struct StreamChoice: Decodable {
    let finishReason: String?  // Optionally provides the reason for completion (if available).
    let delta: StreamMessage  // Contains the generated message in a stream choice.
}


// This struct represents a message in a stream choice, including the role of the sender and the content of the message.
struct StreamMessage: Decodable {
    let role: String?  // Optionally specifies the role of the message sender (if available).
let content: String?  // Optionally contains the content of the message (if available).
}
