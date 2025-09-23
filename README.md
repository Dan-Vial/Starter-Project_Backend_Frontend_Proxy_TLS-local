# 🚀 Starter Project – Backend + Frontend + Proxy + TLS local

Ce projet est un **modèle de démarrage fullstack** comprenant :

- **Backend** : Express.js (API)
- **Frontend** : Vite.js (Vanilla JS par défaut)
- **Proxy** : Nginx avec certificats TLS auto-signés
- **DB** : dossier réservé (vide par défaut)

Tout est orchestré par **Podman Compose** (compatible Docker Compose).

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

## ⚙️ Lancement

- Tout est géré par compose.yml :

```bash
podman-compose up -d

# docker
docker-compose up -d
```

- Puis accéder à :
  - Frontend : [`https://app.localhost:4443`](https://app.localhost:4443)

  - API backend : [https://api.localhost:4443](https://api.localhost:4443)

## 🔧 Certificats TLS

La génération automatique des certificats TLS est
gérée directement par compose.yml lors du premier démarrage.

Si vous souhaitez les régénérer manuellement,
utilisez le script fourni dans `proxy/` :

```bash
./gen-local-ca-tls.sh
```

⚠️ Ajoutez la CA (myCA.crt) dans votre OS\/navigateur pour
éviter les avertissements SSL.

## 🐛 Debug

Pour suivre les logs d’un service spécifique (ex: backend) :

```bash
# Podman
podman-compose logs -f backend

# Docker
docker-compose logs -f backend
```

Astuce : remplacez `backend` pour cibler un autre service.
