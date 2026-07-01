# 🛍️ Shopaholic - Premium Full-Stack E-Commerce Ecosystem

**Shopaholic** is a state-of-the-art, cross-platform e-commerce solution that seamlessly integrates a high-performance **Flutter** mobile application with a robust **Django** backend. Designed with a premium aesthetic, it offers a lavish user experience across Web, Mobile (Android/iOS), and Admin surfaces.

---

## 🌟 Key Pillars of the Project

### 📱 1. Premium Flutter Mobile App
A high-end mobile experience featuring:
- **Modern UI/UX:** Gradient-heavy designs, glassmorphism effects, and smooth micro-animations.
- **Dynamic Theme Management:** Seamless Light and Dark mode switching with persistent state.
- **PascalCase Architecture:** A clean, professional codebase using PascalCase (UpperCamelCase) for all Dart files and components.
- **State Management:** Powered by `Provider` for real-time cart updates and user session management.
- **API Integration:** Optimized network layer using `Dio` for secure and fast data fetching.

### 🌐 2. Interactive Django Web App
A responsive web portal that mirrors the premium branding of the mobile app:
- **Consistent Design:** Shared gradient color palettes and typography (`Outfit` font).
- **Theme Sync:** Integrated theme toggle for web users.
- **Dynamic Content:** Real-time product listing and category filtering.

### 🛠️ 3. Custom Admin Dashboard
A specialized management interface built for store owners:
- **Order Lifecycle Management:** Update order statuses (Pending, Processing, Shipped, Delivered) directly.
- **Product & Category Control:** Easy management of inventory and catalog.
- **Detailed Analytics:** Track sales and customer activities.

---

## 🖼️ Screenshots

<p align="center">
  <img src="e_commerce_app/assets/images/1.png" width="30%" alt="Screenshot 1"/>
  <img src="e_commerce_app/assets/images/2.png" width="30%" alt="Screenshot 2"/>
  <img src="e_commerce_app/assets/images/3.png" width="30%" alt="Screenshot 3"/>
  <img src="e_commerce_app/assets/images/4.png" width="30%" alt="Screenshot 4"/>
  <img src="e_commerce_app/assets/images/5.png" width="30%" alt="Screenshot 5"/>
  <img src="e_commerce_app/assets/images/6.png" width="30%" alt="Screenshot 6"/>
  <img src="e_commerce_app/assets/images/7.png" width="30%" alt="Screenshot 7"/>
  <img src="e_commerce_app/assets/images/8.png" width="30%" alt="Screenshot 8"/>
  <img src="e_commerce_app/assets/images/9.png" width="30%" alt="Screenshot 9"/>
  <img src="e_commerce_app/assets/images/10.png" width="30%" alt="Screenshot 10"/>
  <img src="e_commerce_app/assets/images/11.png" width="30%" alt="Screenshot 11"/>
  <img src="e_commerce_app/assets/images/12.png" width="30%" alt="Screenshot 12"/>
  <img src="e_commerce_app/assets/images/13.png" width="30%" alt="Screenshot 13"/>
  <img src="e_commerce_app/assets/images/14.png" width="30%" alt="Screenshot 14"/>
  <img src="e_commerce_app/assets/images/15.png" width="30%" alt="Screenshot 15"/>
  <img src="e_commerce_app/assets/images/16.png" width="30%" alt="Screenshot 16"/>
  <img src="e_commerce_app/assets/images/17.png" width="30%" alt="Screenshot 17"/>
  <img src="e_commerce_app/assets/images/18.png" width="30%" alt="Screenshot 18"/>
  <img src="e_commerce_app/assets/images/19.png" width="30%" alt="Screenshot 19"/>
  <img src="e_commerce_app/assets/images/20.png" width="30%" alt="Screenshot 20"/>
  <img src="e_commerce_app/assets/images/21.png" width="30%" alt="Screenshot 21"/>
  <img src="e_commerce_app/assets/images/22.png" width="30%" alt="Screenshot 22"/>
  <img src="e_commerce_app/assets/images/23.png" width="30%" alt="Screenshot 23"/>
  <img src="e_commerce_app/assets/images/24.png" width="30%" alt="Screenshot 24"/>
  <img src="e_commerce_app/assets/images/25.png" width="30%" alt="Screenshot 25"/>
  <img src="e_commerce_app/assets/images/26.png" width="30%" alt="Screenshot 26"/>
  <img src="e_commerce_app/assets/images/27.png" width="30%" alt="Screenshot 27"/>
  <img src="e_commerce_app/assets/images/28.png" width="30%" alt="Screenshot 28"/>
  <img src="e_commerce_app/assets/images/29.png" width="30%" alt="Screenshot 29"/>
  <img src="e_commerce_app/assets/images/30.png" width="30%" alt="Screenshot 30"/>
  <img src="e_commerce_app/assets/images/31.png" width="30%" alt="Screenshot 31"/>
  <img src="e_commerce_app/assets/images/32.png" width="30%" alt="Screenshot 32"/>
</p>

---

## 🚀 Tech Stack

- **Frontend (Mobile):** Flutter (Dart)
- **Frontend (Web):** HTML5, CSS3 (Vanilla), JavaScript (ES6+)
- **Backend:** Django (Python), Django REST Framework (DRF)
- **Database:** SQLite (Default) / PostgreSQL (Optional)
- **Authentication:** JWT (JSON Web Tokens)
- **State Management:** Provider (Flutter)

---

## 📂 Project Structure (PascalCase Convention)

The Flutter codebase follows a strict **PascalCase** naming convention for all files in the `lib` directory to ensure professional standards:

```text
e_commerce_app/lib/
├── models/         # Category.dart, Order.dart, Product.dart, User.dart
├── providers/      # AuthProvider.dart, ShopProvider.dart, ThemeProvider.dart
├── screens/        # HomeScreen.dart, LoginScreen.dart, SplashScreen.dart...
├── services/       # ApiService.dart
└── utils/          # Config.dart
```

---

## 🛠️ Installation & Setup

### 1. Backend Configuration (Django)
1. Navigate to `e_commerce_app_django/myproject`.
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Run migrations and start server:
   ```bash
   python manage.py migrate
   ```bash
   ```bash
   python manage.py runserver 0.0.0.0:8000
   ```

### 2. Mobile App Configuration (Flutter)
1. Find your computer's local IP (e.g., `192.168.x.x`).
2. Update `lib/utils/Config.dart` with your IP:
   ```dart
   static const String baseUrl = 'http://YOUR_IP_HERE:8000';
   ```
3. Run the app:
   ```bash
   flutter pub get
    ```bash
     ```bash
   flutter run
   ```

---

## 🎨 Theme & Design System

The project uses a curated design system based on:
- **Primary Colors:** Royal Blue (`#667EEA`) and Deep Purple (`#764BA2`).
- **Typography:** `Outfit` (Google Fonts) for a modern, sleek look.
- **Modes:** 
  - **Light Mode:** Crisp, white backgrounds with soft shadows.
  - **Dark Mode:** Deep Navy (`#050A14`) backgrounds with high-contrast text.

---

## ⚠️ Troubleshooting
- **Network Issues:** Ensure both your mobile device and computer are on the same Wi-Fi network.
- **Broken Images:** Verify `baseUrl` in `Config.dart` matches your server's current IP address.
- **CORS Errors:** Already handled via `django-cors-headers` in the backend settings.

---

# 👋🏻 Hi, I'm Noor Mustafa

A passionate and results-driven *Flutter Developer* from *Bahawalpur, Pakistan, specializing in building elegant, scalable, and high-performance cross-platform mobile applications using **Flutter* and *Dart*.

With a strong understanding of *UI/UX principles, **state management, and **API integration*, I aim to deliver apps that are not only functional but also user-centric and visually compelling. My development approach emphasizes clean code, reusability, and performance.

---

## 🚀 What I Do

- 🧑🏻💻 *Flutter App Development* – I build cross-platform apps for Android, iOS, and the web using Flutter.
- 🔗 *API Integration* – I connect apps to powerful RESTful APIs and third-party services.
- 🎨 *UI/UX Design* – I craft responsive and animated interfaces that elevate the user experience.
- 🔐 *Authentication & Firebase* – I implement secure login systems and integrate Firebase services.
- ⚙ *State Management* – I use Provider, setState, and Riverpod (in-progress) for scalable app architecture.
- 🧠 *Clean Architecture* – I follow MVVM and MVC patterns for maintainable code.

---


## 🌟 Projects I'm Proud Of

- 🌤 **[Live Weather Check App](https://github.com/NoorMustafa4556/Live-Weather-Check-App)** – Real-time weather forecast using OpenWeatherMap API  
- 🤖 **[AI Chatbot (Gemini)](https://github.com/NoorMustafa4556/Ai-ChatBot)** – Conversational AI chatbot powered by Google’s Gemini  

- 🍔 **[Recipe App](https://github.com/NoorMustafa4556/Recipe-App)** – Discover recipes with images, categories, and step-by-step instructions  

- 📚 **[Palindrome Checker](https://github.com/NoorMustafa4556/Palindrome-Checker-App)** – A Theory of Automata-based project to identify palindromic strings  

> 🎯 Check out all my repositories on [github.com/NoorMustafa4556](https://github.com/NoorMustafa4556?tab=repositories)

---

## 🛠 Tech Stack & Tools

| Area                | Tools/Technologies |
|---------------------|--------------------|
| *Languages*       | Dart, JavaScript, Python (basic) |
| *Mobile Framework*| Flutter            |
| *Backend/Cloud*   | Firebase (Auth, Realtime DB, Storage), Django, Flask |
| *Frontend (Web)*  | React.js (basic), HTML, CSS, Bootstrap |
| *State Management*| Provider, setState, Riverpod (learning) |
| *API & Storage*   | REST APIs, HTTP, Shared Preferences, SQLite |
| *Design*          | Material, Cupertino, Lottie Animations, Gradient UI |
| *Version Control* | Git, GitHub        |
| *Tools*           | Android Studio, VS Code, Postman, Figma (basic) |

---

## 🧰 Tech Toolbox

<p align="left">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black"/>
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white"/>
  <img src="https://img.shields.io/badge/Django-092E20?style=for-the-badge&logo=django&logoColor=white"/>
  <img src="https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB"/>
  <img src="https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white"/>
  <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white"/>
</p>

---

## 📈 Current Focus

- 💡 Enhancing Flutter animations and transitions
- 🤖 Implementing AI-based logic with Google Gemini API
- 📲 Building portfolio-level applications using full-stack Django & Flutter

---

## 📫 Let's Connect!

<table align="left">
  <tr>
    <td><a href="https://x.com/NoorMustafa4556" target="blank"><img src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/twitter.svg" alt="X / Twitter" height="30" width="40" /></a></td>
    <td><a href="https://www.linkedin.com/in/noormustafa4556/" target="blank"><img src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/linked-in-alt.svg" alt="LinkedIn" height="30" width="40" /></a></td>
    <td><a href="https://www.facebook.com/NoorMustafa4556" target="blank"><img src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/facebook.svg" alt="Facebook" height="30" width="40" /></a></td>
    <td><a href="https://instagram.com/noormustafa4556" target="blank"><img src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/instagram.svg" alt="Instagram" height="30" width="40" /></a></td>
    <td><a href="https://wa.me/923087655076" target="blank"><img src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/whatsapp.svg" alt="WhatsApp" height="30" width="40" /></a></td>
    <td><a href="https://www.tiktok.com/@noormustafa4556" target="blank"><img src="https://cdn-icons-png.flaticon.com/512/3046/3046122.png" alt="TikTok" height="30" width="30" /></a></td>
  </tr>
</table>
<br><br><br><br>

- 📍 *Location:* Bahawalpur, Punjab, Pakistan

---

> “Learning never stops. Every app I build makes me a better developer — one widget at a time.”

---
