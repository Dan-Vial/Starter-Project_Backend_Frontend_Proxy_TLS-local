# 🚀 Starter Project – Backend + Frontend + Proxy + TLS local

Ce projet est un **modèle de démarrage fullstack** comprenant :

- **Backend** : Express.js (API)
- **Frontend** : Vite.js (Vanilla JS par défaut)
- **Proxy** : Nginx avec certificats TLS auto-signés
- **DB** : dossier réservé (vide par défaut)

Tout est orchestré par **Podman Compose** (compatible Docker Compose).

---

## Prérequis

- Podman ou Docker.
- Podman-Compose ou Docker-Compose.

Vous aurez besoin des dépendances suivant votre stack pour
votre IDE afin de faire fonctionner :

- L'autocomplétion.
- Débugger.
- Diagnostic.
- Linter.
- Formatage.
- Highlighting.
- ...

---

## 📂 Arborescence

```bash
.
├── backend         # Serveur Express (API)
│   ├── app.js
│   ├── routes/     # routes Express
│   └── nodemon.json
│
├── frontend        # Client Vite.js
│   ├── index.html
│   └── src/        # JS/CSS frontend
│
├── proxy           # Proxy (Nginx)
│   ├── certs/      # Certificats TLS locaux
│   ├── logs/       # Logs proxy
│   └── templates/  # Configuration nginx
│
├── db              # (optionnel) base de données
├── compose.yml     # Orchestration
└── README.md
```

---

## ⚙️ Lancement

- Tout est géré par compose.yml :

```bash
podman-compose up -d

# docker
docker-compose up -d
```

- ⚠️ Ajoutez la CA (myCA.crt) dans votre OS\/navigateur pour
  éviter les avertissements SSL. `voir dans : ./proxy/certs/`

- Puis accéder à :
  - Frontend : [`https://app.localhost:4443`](https://app.localhost:4443)

  - API backend : [https://api.localhost:4443](https://api.localhost:4443)

---

## 🔧 Certificats TLS

La génération automatique des certificats TLS est
gérée directement par compose.yml lors du premier démarrage.

Si vous souhaitez les régénérer manuellement,
utilisez le script fourni dans `proxy/` :

```bash
./gen-local-ca-tls.sh
```

### ⚠️ Pourquoi TLS même en local ?

Les navigateurs modernes deviennent de plus en plus stricts sur la sécurité.
Certaines fonctionnalités ne sont accessibles que via HTTPS :

- WebAuthn (authentification biométrique ou par clé de sécurité)
- Service Workers & PWA
- Web Push Notifications
- Accès aux périphériques sensibles (caméra, micro, USB, Bluetooth, etc.)
- APIs récentes (Clipboard, Geolocation haute précision, etc.)
- ...

Sans TLS, vous seriez limités lors du développement et risqueriez des
comportements différents entre votre environnement local et la production.

👉 En important la CA locale (myCA.crt) dans votre OS/navigateur, vous pouvez
travailler avec un environnement sécurisé et réaliste, proche de la prod.

---

## 🐛 Debug

Pour suivre les logs d’un service spécifique (ex: backend) :

```bash
# Podman
podman-compose logs -f backend

# Docker
docker-compose logs -f backend
```

Vous pouvez lancer des commandes directement dans un
service containerisé pour debug ou administration.

```bash
# Ouvrir un shell interactif dans le container "backend"
podman-compose exec backend sh

# Exécuter une commande spécifique sans ouvrir le shell
podman-compose exec backend node app.js
```

💡 Astuce : remplacez `backend` pour cibler un autre service.
