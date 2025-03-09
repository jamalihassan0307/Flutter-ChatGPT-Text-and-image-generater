<div align="center">
  <h1>
    <img src="assets/app_logo.png" width="80px"><br/>
    Flutter ChatGPT with Clean Architecture
  </h1>
  <h3>An Advanced AI Chat Application with Text and Image Generation</h3>
</div>

<p align="center">
    <a href="https://github.com/jamalihassan0307/" target="_blank">
        <img alt="" src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" />
    </a>
    <a href="https://www.linkedin.com/in/jamalihassan0307/" target="_blank">
        <img alt="" src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" />
    </a>
</p>

## 📌 Overview

A sophisticated Flutter application that integrates OpenAI's ChatGPT API for text conversations and image generation. Built with clean architecture principles, the app offers a seamless AI chat experience with advanced features and customizable themes.

## 🚀 Tech Stack

- **Flutter** (UI Framework)
- **Riverpod** (State Management)
- **OpenAI API** (AI Integration)
- **Clean Architecture**

## 🔑 Key Features

- ✅ **AI Chat Interface**: Smooth conversation experience with ChatGPT
- ✅ **Image Generation**: Create images using AI
- ✅ **Theme Customization**: Multiple theme options with custom colors
- ✅ **Code Highlighting**: Proper formatting for code blocks
- ✅ **Message Management**: Copy, share, and delete messages
- ✅ **Authentication**: Secure user login and signup
- ✅ **Responsive Design**: Works across different screen sizes

## 📸 Banner

<img src="screenshots/ai_banner.png" alt="AI Chat Banner" />

## 📸 Screenshots

### Authentication & Home

<table border="1">
  <tr>
    <td align="center">
      <img src="screenshots/splash.png" alt="Splash Screen" width="250"/>
      <p><b>Splash Screen</b></p>
    </td>
    <td align="center">
      <img src="screenshots/login.png" alt="Login" width="250"/>
      <p><b>Login Screen</b></p>
    </td>
    <td align="center">
      <img src="screenshots/signup.png" alt="Signup" width="250"/>
      <p><b>Signup Screen</b></p>
    </td>
  </tr>
</table>

### Chat Interface

<table border="1">
  <tr>
    <td align="center">
      <img src="screenshots/chat_page.png" alt="Chat Interface" width="250"/>
      <p><b>Chat Interface</b></p>
    </td>
    <td align="center">
      <img src="screenshots/chat_newtheme.png" alt="New Theme" width="250"/>
      <p><b>Themed Chat</b></p>
    </td>
    <td align="center">
      <img src="screenshots/chat_copy_toast.png" alt="Copy Feature" width="250"/>
      <p><b>Copy Message</b></p>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="screenshots/chat_shear.png" alt="Share Feature" width="250"/>
      <p><b>Share Message</b></p>
    </td>
    <td align="center">
      <img src="screenshots/chat_page_drawer.png" alt="Navigation Drawer" width="250"/>
      <p><b>Navigation Menu</b></p>
    </td>
    <td align="center">
      <img src="screenshots/clear_chat.png" alt="Clear Chat" width="250"/>
      <p><b>Clear Chat</b></p>
    </td>
  </tr>
</table>

### Theme Customization

<table border="1">
  <tr>
    <td align="center">
      <img src="screenshots/theme_selecter.png" alt="Theme Selector" width="250"/>
      <p><b>Theme Selection</b></p>
    </td>
    <td align="center">
      <img src="screenshots/theme_selecter_1.png" alt="Custom Theme" width="250"/>
      <p><b>Custom Colors</b></p>
    </td>
    <td align="center">
      <img src="screenshots/theme_selecter_2.png" alt="Theme Preview" width="250"/>
      <p><b>Theme Preview</b></p>
    </td>
  </tr>
</table>

## 📁 Project Structure

```
lib/
├── bloc/
│ ├── chat_bloc.dart
│ └── chat_event.dart
│ └── chat_state.dart
├── models/
│ └── chat_message.dart
├── repositories/
│ └── chat_repository.dart
├── screens/
│ ├── chat_screen.dart
│ └── home_screen.dart
├── services/
│ └── api_service.dart
├── utils/
│ └── constants.dart
└── main.dart
```

## 📦 Installation

1. Clone the repository:

bash
git clone https://github.com/jamalihassan0307/Flutter-ChatGPT-Text-and-image-generater.git
bash
flutter pub get

2. Run the app:

bash
flutter run

## 👨‍💻 Developer

Developed by [Jam Ali Hassan](https://github.com/jamalihassan0307)

---

<p align="center">
  Made with ❤️ using Flutter and OpenAI
</p>
