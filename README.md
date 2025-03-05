# Flutter ChatGpt with Clean Architecture

### Show some  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2764.png" width="30" height="30" />   and star the repo to support the project


<img src="https://github.com/jamalihassan0307/Flutter-ChatGPT-Text-and-image-generater/blob/master/Copy%20of%20Flutter%20App%20UI.png"/>
<img src="https://github.com/jamalihassan0307/Flutter-ChatGPT-Text-and-image-generater/blob/master/chatgpt1.jpg"  width="1200" height="300" />


### Screenshots

<p float="left">
  <img src="https://github.com/jamalihassan0307/Flutter-ChatGPT-Text-and-image-generater/blob/master/1-removebg-preview.png" height="500" /> 
    <img src="https://github.com/jamalihassan0307/Flutter-ChatGPT-Text-and-image-generater/blob/master/2-removebg-preview.png" height="500" /> 
        <img src="https://github.com/jamalihassan0307/Flutter-ChatGPT-Text-and-image-generater/blob/master/3-removebg-preview.png" height="500" /> 
                <img src="https://github.com/jamalihassan0307/Flutter-ChatGPT-Text-and-image-generater/blob/master/4-removebg-preview.png" height="500" /> 
 
  
  <br />
</p>


### Introduction
This project integrates OpenAI's ChatGPT API using Flutter with a clean architecture approach. The app allows users to generate text and images through the ChatGPT model.

### Packages Used
 `flutter_bloc:` State management
 
 `equatable:` Simplifies equality comparisons
 
 `http:` HTTP requests
 
 `get_it:` Dependency injection
 
 `flutter_staggered_grid_view`: Grid view layout
 
 `cached_network_image:` For caching network images
 
 `share_plus:` Sharing content
 
 `shimmer:` Shimmer effect
 
 `Getting Started
 
`API Key`

`Add your OpenAI API key in the constants file:`


### Clone the repository:

git clone `https://github.com/jamalihassan0307/Flutter-ChatGPT-Text-and-image-generater.git`
cd Flutter-ChatGPT-Text-and-image-generater
Install dependencies:

flutter pub get
### Project Structure
lib/

├── bloc/

│   ├── chat_bloc.dart

│   └── chat_event.dart

│   └── chat_state.dart

├── models/

│   └── chat_message.dart

├── repositories/

│   └── chat_repository.dart

├── screens/

│   ├── chat_screen.dart

│   └── home_screen.dart

├── services/

│   └── api_service.dart

├── utils/

│   └── constants.dart

└── main.dart
