# 🚀 Jenkins Demo — Pipeline CI/CD

Application Spring Boot déployée automatiquement via un pipeline Jenkins complet : **Maven → Docker → Kubernetes (K3S)**.

![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-red?logo=jenkins)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.5-green?logo=springboot)
![Docker](https://img.shields.io/badge/Docker-29.9.0-blue?logo=docker)
![K3S](https://img.shields.io/badge/K3S-v1.35.4-orange?logo=kubernetes)

---

## 📖 Description

Ce projet démontre un **pipeline CI/CD complet** :

1. **CI** — Jenkins compile le code Maven à chaque push GitHub
2. **CD** — Jenkins construit l'image Docker et la déploie automatiquement sur K3S

Endpoints :
- `/` → Hello DevOps from Jenkins CI/CD Lab!
- `/health` → OK

---

## 🏗️ Architecture

GitHub → Jenkins → Maven → Docker → K3S → Pods (x2) → NodePort 30090

---

## 🛠️ Stack technique

| Composant | Version |
|-----------|---------|
| Ubuntu Server | 22.04.5 |
| Java | 17 + 21 |
| Maven | 3.6.3 |
| Spring Boot | 3.2.5 |
| Docker | 29.9.0 |
| K3S | v1.35.4 |
| Jenkins | 2.580.1 |

---

## ✅ Prérequis

- Ubuntu 22.04+
- Docker installé
- K3S actif
- Jenkins démarré
- Java 17 et Java 21
- Maven
- Compte GitHub

---

## 📦 Installation

### 1. Cloner le projet

git clone https://github.com/Narjess805/jenkins-demo.git
cd jenkins-demo

### 2. Build manuel

mvn clean package -DskipTests
docker build -t jenkins-demo:1.0.0 .

### 3. Déployer sur K3S

kubectl create namespace jenkins-lab
docker save jenkins-demo:1.0.0 -o /tmp/jenkins-demo.tar
sudo k3s ctr images import /tmp/jenkins-demo.tar
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

![Docker Build](screenshots/01-docker-build.png)

---

## 🔄 Pipeline Jenkins

Job : jenkins-demo-pipeline

| # | Étape | Commande |
|---|-------|----------|
| 1 | Build Maven | mvn clean package -DskipTests |
| 2 | Build Docker | docker build -t jenkins-demo:1.0.0 . |
| 3 | Import K3S | k3s ctr images import |
| 4 | Déploiement | kubectl apply -f deployment.yaml -f service.yaml |
| 5 | Vérification | kubectl rollout status |

![Pipeline SUCCESS](screenshots/08-pipeline-success.png)

![Dashboard Jenkins](screenshots/04-jenkins-dashboard.png)

---

## 🧪 Vérifications

### Pods et service

kubectl get pods -n jenkins-lab
kubectl get svc -n jenkins-lab

![Pods Running](screenshots/02-kubectl-pods.png)

### Test de l'application

curl http://192.168.56.101:30090/
curl http://192.168.56.101:30090/health

Résultat attendu :

Hello DevOps from Jenkins CI/CD Lab!
OK

![Test curl](screenshots/03-curl-test.png)

### Interface web

Ouvrir : http://192.168.56.101:30090/

![Application web](screenshots/12-app-browser.png)

---

## 📁 Structure

jenkins-demo/
├── src/main/java/com/example/demo/
│   ├── DemoApplication.java
│   └── HelloController.java
├── src/main/resources/application.properties
├── Dockerfile
├── deployment.yaml
├── service.yaml
├── pom.xml
└── README.md

---

## 🐛 Problèmes résolus

- Repo original 404 → création d'un projet Spring Boot
- Docker Hub lent → import local via k3s ctr images import
- RAM insuffisante → ajout de 2 Go de swap
- Timeouts Maven → cache copié dans /var/lib/jenkins/.m2/
- Permissions Jenkins → groupe docker + sudoers

---

## 👩💻 Auteur

Narjess Dabbech
📧 narjessdabbech3@gmail.com
🔗 github.com/Narjess805

Lab DevOps / CI-CD.

---

## 📄 Licence

Projet pédagogique — libre d'utilisation.
