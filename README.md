Personal AI Fitness Trainer & Health Agent 🏋️‍♂️🤖

An intelligent, privacy-focused, offline-first personal trainer app built with Flutter, Spring Boot 3, Spring AI, and Google Gemini 1.5 Flash.

This project provides automated workout design, macro tracking, and personal fitness coaching. It supports an offline-first local architecture using embedded SQLite and scales to a cloud-native microservice architecture with Docker and Kubernetes.

🏗️ System Architecture

┌─────────────────────────────────────────────────────────────┐
│                    MOBILE CLIENT (Flutter)                  │
│  - Presentation UI & State Management (Riverpod / Provider) │
│  - Fast local caching with SQLite (sqflite)                 │
└───────────────┬─────────────────────────────────────────────┘
                │
                │ HTTPS (REST API / JSON)
                ▼
┌─────────────────────────────────────────────────────────────┐
│                  BACKEND (Spring Boot 3.x)                  │
│                                                             │
│  ┌─────────────────────────┐   ┌─────────────────────────┐  │
│  │   REST Controllers      │   │   Spring Security / CORS│  │
│  └────────────┬────────────┘   └─────────────────────────┘  │
│               │                                             │
│  ┌────────────▼────────────┐   ┌─────────────────────────┐  │
│  │     Spring AI Module    │   │  Spring Data JPA        │  │
│  │  - Prompt Engineering   │   │  (PostgreSQL / H2)      │  │
│  │  - Structured Outputs   │   └────────────┬────────────┘  │
│  └────────────┬────────────┘                │               │
└───────────────┼─────────────────────────────┼───────────────┘
                │                             │
                │ HTTPS                       │ JDBC
                ▼                             ▼
┌───────────────────────────────┐ ┌───────────────────────────┐
│     Google Gemini AI API      │ │ Cloud PostgreSQL Database │
│   (Gemini 1.5 Flash Engine)   │ │  (Neon.tech Free Tier)    │
└───────────────────────────────┘ └───────────────────────────┘


🛠️ Tech Stack & Tools

Mobile App: Flutter (Dart), sqflite, flutter_local_notifications

Backend Framework: Java 21, Spring Boot 3.x, Spring AI (spring-ai-starter-model-google-genai)

AI Engine: Google Gemini 1.5 Flash API

Database: SQLite (Local Mobile), PostgreSQL / H2 (Backend)

DevOps & Infrastructure: Docker, Kubernetes (Minikube / Cloud Deployment), GitHub Actions

🗺️ Project Roadmap & Sprints

The project is structured into 8 weekly sprints:

[ ] Week 1: Flutter Foundation & SQLite Setup (DatabaseHelper.dart, Local Schemas)

[ ] Week 2: Mobile UI & Local Notifications (Dashboard, Chat View, Push Alarms)

[ ] Week 3: Spring Boot & Gemini AI Integration (Spring AI, Prompt Templates)

[ ] Week 4: Local Bridge & E2E Testing (Structured Outputs, Ngrok Integration)

[ ] Week 5: Containerization & Docker (Multi-stage Dockerfile, Container Testing)

[ ] Week 6: Kubernetes Manifests (Deployments, Services, ConfigMaps, Secrets)

[ ] Week 7: Cloud Deployment (Neon PostgreSQL, Render / GCP Cloud Hosting)

[ ] Week 8: Release APK & Interview Portfolio (APK Compile, Final E2E Tests)

📁 Repository Structure

fitness-ai-agent/
├── mobile/            # Flutter cross-platform mobile application
├── backend/           # Spring Boot 3 + Spring AI service
├── k8s/               # Kubernetes Deployment & Service manifests
├── docs/              # Architecture diagrams & setup notes
└── README.md          # Project documentation


🚀 Quick Start (Local Setup)

Prerequisites

JDK 21+

Flutter SDK (3.x)

Android Studio / VS Code

Google Gemini API Key

Running Locally

Clone the repository:

git clone https://github.com/nayuem-nb/fitness-ai-agent.git
cd fitness-ai-agent


Start Backend (Spring Boot):

cd backend
export GEMINI_API_KEY="your_api_key_here"
./mvnw spring-boot:run


Run Mobile Client (Flutter):

cd mobile
flutter pub get
flutter run


📄 License

This project is open-source under the MIT License.