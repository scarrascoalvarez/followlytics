<p align="center">
  <img src="assets/icon/icon.png" alt="Followlytics Logo" width="120" height="120">
</p>

<h1 align="center">Followlytics</h1>

<p align="center">
  <strong>Your Instagram analytics, completely private.</strong>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#privacy">Privacy</a> •
  <a href="#installation">Installation</a> •
  <a href="#how-it-works">How It Works</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#contact">Contact</a>
</p>

---

## 📱 About

**Followlytics** is a privacy-first Instagram analytics app that helps you understand your Instagram connections and interactions. Unlike other analytics tools, Followlytics processes all your data **locally on your device** — no servers, no cloud storage, no data sharing.

Export your Instagram data, import it into Followlytics, and get instant insights about who follows you, who doesn't follow you back, and who you interact with the most.

## ✨ Features

### 👥 Follow Analytics
- **Non-Followers**: See who you follow that doesn't follow you back
- **Fans**: Discover who follows you that you don't follow back
- **Mutuals**: View all your mutual connections
- **Pending Requests**: Track follow requests that haven't been accepted (with duration indicators)

### 💬 Interaction Analytics
- **Combined Score**: See who you interact with the most overall
- **Likes Given**: Track whose posts you like the most
- **Comments Made**: See who you comment on the most
- **Story Reactions**: Discover whose stories you engage with the most
- **Time Filtering**: Filter interactions by time period (7 days, 30 days, 3 months, etc.)

### 🔐 Privacy First
- **100% Local Processing**: Your data never leaves your device
- **No Servers**: We don't store or transmit any of your information
- **No Login Required**: We never ask for your Instagram password
- **Full Control**: Delete all imported data anytime from settings

## 🛡️ Privacy

Followlytics was built with privacy as the core principle:

| Feature | Description |
|---------|-------------|
| 📱 Local Processing | All data analysis happens on your device |
| ☁️ No Cloud | Zero server communication or cloud storage |
| 🔑 No Credentials | Never requires your Instagram login |
| 🗑️ Easy Deletion | One-tap to delete all your data |

Your Instagram data is sensitive. That's why Followlytics is designed to give you insights without compromising your privacy.

## 📲 Installation

### Requirements
- iOS 12.0+ or Android 5.0+
- Flutter 3.0+ (for development)

### From Source

```bash
# Clone the repository
git clone https://github.com/yourusername/followlytics.git

# Navigate to project directory
cd followlytics

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 🔄 How It Works

### Step 1: Export Your Instagram Data
1. Go to [Instagram's Download Your Information](https://accountscenter.instagram.com/info_and_permissions/dyi/) page
2. Select your Instagram account
3. Choose **JSON** format (important!)
4. Request your data and wait for Instagram to prepare it
5. Download the ZIP file when ready

### Step 2: Import into Followlytics
1. Open Followlytics
2. Tap "Import Data"
3. Select the ZIP file you downloaded from Instagram
4. Wait for the analysis to complete

### Step 3: Explore Your Insights
- View who doesn't follow you back
- Discover your biggest fans
- See your interaction patterns
- Track pending follow requests

## 🏗️ Architecture

Followlytics follows **Clean Architecture** principles with a clear separation of concerns:

```
lib/
├── core/                    # Shared utilities and constants
│   ├── constants/           # App-wide constants
│   ├── di/                  # Dependency injection setup
│   ├── theme/               # App theming (dark mode)
│   └── utils/               # Utility functions
├── data/                    # Data layer
│   ├── datasources/         # Local data sources
│   ├── models/              # Data models and JSON parsing
│   └── repositories/        # Repository implementations
├── domain/                  # Business logic layer
│   ├── entities/            # Core business entities
│   ├── repositories/        # Repository interfaces
│   └── usecases/            # Application use cases
└── presentation/            # UI layer
    ├── blocs/               # BLoC state management
    ├── pages/               # App screens
    ├── router/              # Navigation (go_router)
    └── widgets/             # Reusable UI components
```

### Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter |
| State Management | flutter_bloc |
| Navigation | go_router |
| Dependency Injection | get_it |
| Local Storage | shared_preferences |
| File Handling | file_picker, archive |
| UI | google_fonts, flutter_animate |

## 🎨 Design

Followlytics features a modern dark theme inspired by Instagram's design language:

- **Dark Mode**: Easy on the eyes with true black backgrounds
- **Instagram Gradient**: Familiar accent colors
- **Smooth Animations**: Delightful micro-interactions
- **Intuitive UX**: Clear navigation and information hierarchy

## 📊 Supported Data

Followlytics analyzes the following Instagram export files:

- `followers_1.json` - Your followers list
- `following.json` - People you follow
- `pending_follow_requests.json` - Unanswered follow requests
- `close_friends.json` - Your close friends list
- `liked_posts.json` - Posts you've liked
- `liked_comments.json` - Comments you've liked
- `story_likes.json` - Stories you've liked
- `post_comments_1.json` - Comments you've made
- And more...

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📬 Contact

**Sergio Carrasco** - Developer

- 📧 Email: [contacto@sergio-carrasco.com](mailto:contacto@sergio-carrasco.com)
- 💼 LinkedIn: [Sergio Carrasco](https://www.linkedin.com/in/scarrascoalvarez/)

---

<p align="center">
  <strong>Followlytics</strong> — Your privacy, your control.
</p>

<p align="center">
  Made with ❤️ by Sergio Carrasco
</p>
