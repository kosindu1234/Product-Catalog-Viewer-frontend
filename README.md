PRODUCT CATALOG VIEWER

This project includes a Spring Boot backend and a Flutter mobile app. The backend provides product data through REST APIs, and the Flutter app displays the product list and details.

TECH USED

Backend: Java, Spring Boot, Spring Data JPA
Frontend: Flutter, Dart, HTTP package

API ENDPOINTS

GET /products → Get all products
GET /products/{id} → Get product by ID

BACKEND CORS CONFIG

Allows Flutter to access the API from any origin.

FLUTTER CONNECTION

Use this base URL:

Android Emulator:
http://10.0.2.2:8080

Physical phone (same WiFi):
http://192.168.1.4:8080

RUN PROJECT

Backend: mvn spring-boot:run
Flutter: flutter pub get → flutter run

FILES INCLUDED

Spring Boot API

Flutter API Service

Flutter Product Model