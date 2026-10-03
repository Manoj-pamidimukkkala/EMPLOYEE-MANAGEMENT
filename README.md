# Enterprise Employee & Task Management System

A multi-service platform designed to streamline employee record management, department hierarchy tracking, and task analytics across organizations. 

Built with a modern web frontend, a robust **Java Spring Boot** backend, an asynchronous **Python FastAPI** microservice for analytics, and a relational **SQL** database schema.

---

## System Architecture & Tech Stack

This repository follows a modular, multi-service architecture:

* **Frontend:** HTML5, CSS3, JavaScript (DOM Manipulation & Async Fetch)
* **Core Backend API:** Java (Spring Boot, Maven via `pom.xml`)
* **Analytics Microservice:** Python (FastAPI / `main.py`)
* **Database:** SQL (Relational Schema defined in `schema.sql`)
* **License:** BSD-2-Clause

---

## Project Structure

```text
EMPLOYEE-MANAGEMENT/
│
├── frontend/             # Web user interface (HTML, CSS, JS app scripts)
├── src/main/             # Java Spring Boot backend (Controllers, Entities, Repositories)
│   └── java/             # REST API logic (e.g., TaskController.java)
├── main.py               # Python FastAPI microservice for task analytics
├── pom.xml               # Maven configuration & Java dependencies
├── schema.sql            # Database initialization and relational tables
├── LICENSE               # BSD 2-Clause License
└── README.md             # Project documentation
