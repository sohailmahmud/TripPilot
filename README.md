# TripPilot 🌍✈️

**Your AI-Powered Travel Planning Companion**

TripPilot is a feature-rich Flutter mobile application that revolutionizes travel planning by combining intelligent search capabilities, AI-powered recommendations, budget optimization, and seamless trip management.

---

## 📋 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Configuration](#-configuration)
- [Core Features Documentation](#-core-features-documentation)
- [API Integration](#-api-integration)
- [Database](#-database)
- [State Management](#-state-management)
- [Theme & UI](#-theme--ui)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)

---

## ✨ Features

### 1. **Intelligent Travel Search**
- **Flights**: Real-time flight search across multiple airlines with pricing and amenities
- **Hotels**: Comprehensive hotel listings with ratings, prices, and facilities
- **Activities**: Curated activities and attractions filtered by destination and preferences
- **Infinite Scroll Pagination**: Automatic loading of more results as you scroll (5 items per load)
- **Dynamic Filters**: Sort and filter by price, rating, duration, and preferences

### 2. **AI-Powered Recommendations** 🤖
- **OpenAI GPT Integration**: Real-time recommendations powered by GPT-3.5-turbo
- **Smart Destination Suggestions**: Personalized destination recommendations based on preferences and budget
- **Itinerary Generation**: AI-created day-by-day itineraries with activities and meals
- **Local Tips & Insights**: Curated local tips for authentic travel experiences
- **Restaurant Recommendations**: Cuisine-specific restaurant suggestions
- **Activity Suggestions**: Tailored activities based on preferences and budget
- **Graceful Fallback**: High-quality fallback recommendations when API is unavailable

### 3. **Smart Budget Management**
- **Budget Optimization**: AI-powered breakdown of trip costs by category
- **Deal Detection**: Smart algorithms to identify the best travel deals
- **Cost Tracking**: Real-time tracking of estimated vs. planned expenses
- **Budget Visualization**: Charts and graphs showing expense distribution

### 4. **Trip Management**
- **Create & Manage Trips**: Full CRUD operations for trip planning
- **Offline-First Architecture**: Local database caching with ObjectBox
- **Cloud Sync**: Supabase integration for cloud backup and sync
- **Trip Details**: Store dates, budgets, destinations, and travelers

### 5. **User Authentication**
- **Supabase Auth**: Secure authentication with email/password
- **User Profile Management**: Manage personal information and preferences
- **Session Management**: Persistent login across app restarts

---

## 🏗️ Architecture

TripPilot follows **Clean Architecture** principles with a clear separation of concerns:

```
Domain Layer (Business Logic)
    ↓
Data Layer (Repositories & Data Sources)
    ↓
Presentation Layer (UI & State Management)
```

### Layer Breakdown:

**Domain Layer** (`lib/domain/`)
- Abstract repository interfaces
- Business entities (Trip, Budget, Recommendation)
- Use cases for business logic
- No dependencies on external frameworks

**Data Layer** (`lib/data/`)
- Repository implementations
- Remote data sources (APIs: OpenAI, Amadeus, Supabase, etc.)
- Local data sources (ObjectBox database)
- Data models and mappers

**Presentation Layer** (`lib/presentation/`)
- BLoC state management
- UI screens and widgets
- Theme and styling
- User interaction handling

---

## 🛠️ Tech Stack

### Framework & Language
- **Flutter 3.x** - UI framework
- **Dart 3.x** - Programming language

### State Management
- **flutter_bloc** - BLoC pattern for state management
- **equatable** - Value equality comparison

### API & Networking
- **Dio** - HTTP client with interceptors
- **OpenAI API** - GPT-3.5-turbo for AI recommendations
- **Amadeus API** - Flight, hotel, and activity data (sandbox/test)
- **RapidAPI** - Additional search capabilities

### Database & Persistence
- **ObjectBox** - Local NoSQL database (offline-first)
- **Supabase** - Backend-as-a-service for authentication and cloud storage

### Authentication
- **Supabase Auth** - Email/password authentication

### Utilities & Libraries
- **flutter_dotenv** - Environment variables management
- **logger** - Structured logging
- **get_it** - Service locator/dependency injection
- **go_router** - Declarative routing
- **flutter_secure_storage** - Secure credential storage

### UI & Animation
- **staggered_animations** - Smooth staggered list animations
- **shimmer** - Loading skeleton screens

---

## 📁 Project Structure

```
lib/
├── core/                          # Core app functionality
│   ├── config/                   # Configuration (Supabase, API)
│   ├── errors/                   # Error handling & failures
│   ├── theme/                    # App theming (colors, fonts, spacing)
│   ├── utils/                    # Utilities (injection, logging, routing)
│   └── router/                   # Navigation configuration
│
├── domain/                        # Business logic layer
│   ├── entities/                 # Data models (Trip, Budget, etc.)
│   ├── repositories/             # Abstract interfaces
│   └── usecases/                 # Business logic operations
│
├── data/                         # Data layer
│   ├── datasources/
│   │   ├── remote/              # API clients (Amadeus, OpenAI, Supabase)
│   │   └── local/               # ObjectBox database
│   ├── models/                  # Data models with JSON serialization
│   └── repositories/            # Repository implementations
│
├── presentation/                 # UI layer
│   ├── bloc/                    # BLoC state management
│   │   ├── search/              # Flight, hotel, activity search
│   │   ├── trip/                # Trip management
│   │   ├── budget/              # Budget operations
│   │   ├── auth/                # Authentication
│   │   ├── recommendations/     # AI recommendations
│   │   ├── navigation/          # App navigation
│   │   └── rating/              # Rating system
│   ├── screens/                 # App screens
│   │   ├── search_screen.dart
│   │   ├── recommendations_screen.dart
│   │   ├── budget_tracker_screen.dart
│   │   ├── trip_details_screen.dart
│   │   └── ...
│   └── widgets/                 # Reusable UI widgets
│
├── main.dart                    # App entry point
├── injection_container.dart     # OpenAI services setup
└── pubspec.yaml                 # Dependencies

test/                           # Unit & widget tests
├── widget_test.dart
└── ...
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter 3.x or higher
- Dart 3.x
- iOS: Xcode 14+
- Android: Android Studio with SDK 21+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/sohailmahmud/TripPilot.git
   cd TripPilot
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables** (see Configuration)
   ```bash
   cp .env.example .env
   # Edit .env with your API keys
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

5. **Build for production**
   ```bash
   flutter build apk      # Android
   flutter build ios      # iOS
   ```

---

## ⚙️ Configuration

### Environment Variables (.env)

Create a `.env` file in the project root with the following variables:

```env
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key

# OpenAI API
OPENAI_API_KEY=sk-proj-your-api-key

# Amadeus API (Flight/Hotel/Activity Search)
AMADEUS_URL=https://test.api.amadeus.com/v2
AMADEUS_AUTH_URL=https://test.api.amadeus.com/v1/security/oauth2/token
AMADEUS_CLIENT_ID=your-client-id
AMADEUS_CLIENT_SECRET=your-client-secret

# RapidAPI Key
RAPID_API_KEY=your-rapidapi-key
```

### API Keys Setup

#### 1. **OpenAI API Key**
- Visit https://platform.openai.com/api-keys
- Create a new API key
- Add it to `.env` as `OPENAI_API_KEY`

#### 2. **Supabase Configuration**
- Visit https://supabase.com
- Create a new project
- Get your URL and Anon Key from project settings
- Add to `.env`

#### 3. **Amadeus API Keys** (Sandbox)
- Visit https://developers.amadeus.com
- Register for free account
- Get Client ID and Secret
- Uses sandbox/test data (not real flights)

#### 4. **RapidAPI Key**
- Visit https://rapidapi.com
- Create account and get API key
- Used for additional search capabilities

---

## 📚 Core Features Documentation

### 1. Search Features

**Flight Search:**
- Real-time flight searches via Amadeus API
- Infinite scroll with 5 items per load
- Filters: price, duration, airline, amenities
- Details: departure/arrival times, stops, pricing

**Hotel Search:**
- Hotel listings with photos and ratings
- Location-based search
- Filters: price range, star rating, amenities
- Details: address, phone, website

**Activity Search:**
- Curated activities and attractions
- Category-based filtering
- User ratings and reviews
- Booking information

**Infinite Scroll Implementation:**
```dart
// Automatically loads more items at 80% scroll
_flightScrollController.addListener(() {
  if (_scrollPosition / _scrollExtent > 0.8) {
    _loadMoreFlights();
  }
});
```

### 2. AI Recommendations

**How It Works:**
1. User enters preferences (destination, duration, budget)
2. App sends request to OpenAI GPT-3.5-turbo
3. AI generates personalized recommendations
4. Results cached locally for offline access
5. Fallback to curated data if API unavailable

**Recommendation Types:**
- Destination recommendations
- Day-by-day itineraries
- Local tips and insights
- Restaurant suggestions
- Activity recommendations

### 3. Budget Management

**Optimization Algorithm:**
- Analyzes budget across categories (flights, hotels, activities, meals)
- Suggests adjustments based on market data
- Tracks actual vs. planned spending
- Identifies cost-saving opportunities

### 4. Trip Management

**Offline-First Approach:**
- All data stored locally with ObjectBox
- Changes sync to cloud when online
- Seamless offline functionality
- No data loss on network interruption

---

## 🔌 API Integration

### OpenAI Integration

**Endpoint:** `https://api.openai.com/v1/chat/completions`

**Model:** GPT-3.5-turbo

**Request Format:**
```dart
{
  "model": "gpt-3.5-turbo",
  "messages": [
    {
      "role": "system",
      "content": "You are a travel expert..."
    },
    {
      "role": "user",
      "content": "Recommend destinations for..."
    }
  ],
  "temperature": 0.7,
  "max_tokens": 1500
}
```

**Error Handling:**
- 401: Invalid/expired API key → Fallback data
- 429: Rate limit exceeded → Fallback data
- 500+: Server error → Fallback data

### Amadeus API Integration

**Endpoints:**
- Flights: `/v2/shopping/flight-offers`
- Hotels: `/v2/shopping/hotel-search`
- Activities: `/v2/shopping/activities`

**Authentication:** OAuth 2.0 (Client Credentials)

---

## 💾 Database

### ObjectBox (Local)

**Purpose:** Offline-first local storage

**Data Stored:**
- User profiles
- Trip information
- Search history
- Cached recommendations
- Budget data

**Initialization:**
```dart
await LocalDatabase.initialize();
```

### Supabase (Cloud)

**Purpose:** Authentication and cloud backup

**Features:**
- User authentication
- Cloud trip storage
- Data sync across devices
- Real-time updates

---

## 🎯 State Management

TripPilot uses **BLoC (Business Logic Component)** pattern for state management.

### BLoC Structure:

```dart
// Event
class GetRecommendationsRequested extends RecommendationEvent {
  final String destination;
  final int numberOfDays;
  // ...
}

// State
class RecommendationLoading extends RecommendationState {}
class RecommendationSuccess extends RecommendationState {
  final List<Map<String, dynamic>> recommendations;
}

// BLoC
class RecommendationBloc extends Bloc<RecommendationEvent, RecommendationState> {
  RecommendationBloc(this.aiService) : super(RecommendationInitial()) {
    on<GetRecommendationsRequested>(_onGetRecommendations);
  }
}
```

### Key BLoCs:

- **SearchBloc** - Flight, hotel, activity search
- **TripBloc** - Trip CRUD operations
- **BudgetBloc** - Budget optimization
- **AuthBloc** - User authentication
- **RecommendationBloc** - AI recommendations
- **NavigationBloc** - App navigation state

---

## 🎨 Theme & UI

### Color System

**Primary Colors:**
- Light: `#1A237E` (Navy)
- Dark: `#3D5AFE` (Blue)

**Secondary Colors:**
- Light: `#455A64` (Slate Blue)
- Dark: `#90CAF9` (Light Blue)

**Accent Colors:**
- Tertiary: `#006064` (Cyan)
- Success: `#1B5E20` (Green)
- Warning: `#F57F17` (Amber)
- Error: `#D32F2F` (Red)

### Typography

**Font Family:** Poppins (primary), Roboto (fallback)

**Font Sizes:**
- Display Large: 57sp
- Headline Large: 32sp
- Title Large: 22sp
- Body Large: 16sp
- Label Large: 14sp

### Spacing System

- **xs**: 4dp
- **sm**: 8dp
- **md**: 16dp
- **lg**: 24dp
- **xl**: 32dp

---

## 🐛 Troubleshooting

### Common Issues

**1. "OPENAI_API_KEY not found"**
- **Cause:** `.env` file missing or API key not set
- **Solution:** Create `.env` file with valid `OPENAI_API_KEY`

**2. App using fallback recommendations**
- **Cause:** API key expired, rate limit exceeded, or invalid
- **Solution:** Update API key in `.env` or wait for rate limit reset

**3. Flights/Hotels not loading**
- **Cause:** Amadeus API credentials invalid
- **Solution:** Verify `AMADEUS_CLIENT_ID` and `AMADEUS_CLIENT_SECRET` in `.env`

**4. Authentication failing**
- **Cause:** Supabase not initialized or credentials wrong
- **Solution:** Check `SUPABASE_URL` and `SUPABASE_ANON_KEY` in `.env`

**5. Offline data not syncing**
- **Cause:** Network issues or database not initialized
- **Solution:** Check internet connection and restart app

### Debug Logging

Enable detailed logging:
```dart
// In AppLogger or main.dart
logger.level = Level.debug;
```

View logs in console:
```bash
flutter logs
```

---

## 📦 Dependencies

### Core Dependencies
- `flutter_bloc: ^8.1.0` - State management
- `dio: ^5.3.0` - HTTP client
- `objectbox: ^3.x.x` - Local database
- `supabase_flutter: ^1.x.x` - Backend services
- `logger: ^2.x.x` - Logging
- `flutter_dotenv: ^5.x.x` - Environment variables
- `go_router: ^10.x.x` - Routing

See `pubspec.yaml` for complete dependency list.

---

## 🔒 Security

### Best Practices

1. **API Keys:** Never commit `.env` file (it's in `.gitignore`)
2. **Secure Storage:** Use `flutter_secure_storage` for sensitive data
3. **HTTPS Only:** All API calls use secure connections
4. **Authentication:** Supabase handles secure auth
5. **Data Encryption:** Local database supports encryption

---

## 📈 Performance Optimization

1. **Infinite Scroll:** Load 5 items at a time to reduce memory usage
2. **Image Caching:** Automatic caching of hotel/activity images
3. **Database Indexing:** ObjectBox creates indexes for fast queries
4. **Lazy Loading:** Screens loaded on-demand
5. **State Caching:** BLoC prevents redundant API calls

---

## 🚢 Deployment

### Android

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### iOS

```bash
flutter build ios --release
# Follow Xcode instructions for App Store submission
```

---

## 📝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

---

## 📞 Support & Contact

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check existing documentation
- Review troubleshooting section

---

## 🙏 Acknowledgments

- OpenAI for GPT-3.5-turbo API
- Amadeus for travel data APIs
- Supabase for backend services
- Flutter community for amazing libraries
- Contributors and testers

---

**Built with ❤️ for travel enthusiasts | Happy travels! 🌍✈️**
