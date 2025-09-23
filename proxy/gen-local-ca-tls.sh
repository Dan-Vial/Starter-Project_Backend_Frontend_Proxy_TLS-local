#!/bin/bash
set -e

# Répertoire où stocker les fichiers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERTS_DIR="$SCRIPT_DIR/certs"
mkdir -p "$CERTS_DIR"

echo "📂 Certificats stockés dans : $CERTS_DIR"

# === 1. Création de la CA locale ===
if [[ ! -f "$CERTS_DIR/myCA.key" ]]; then
  echo "🔑 Création de la clé privée de la CA..."
  openssl genrsa -out "$CERTS_DIR/myCA.key" 2048

  echo "📜 Création du certificat auto-signé de la CA..."
  openssl req -x509 -new -nodes \
    -key "$CERTS_DIR/myCA.key" \
    -sha256 -days 3650 \
    -out "$CERTS_DIR/myCA.crt" \
    -subj "/CN=MyLocalCA"
else
  echo "✅ CA déjà existante, on la réutilise."
fi

# === 2. Création d’une clé et d’une CSR pour le site ===
echo "🔑 Génération de la clé privée du site..."
openssl genrsa -out "$CERTS_DIR/server.key" 2048

echo "📜 Création de la CSR pour localhost + app.localhost + api.localhost..."
cat >"$CERTS_DIR/openssl.cnf" <<EOF
[req]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = v3_req
prompt             = no

[req_distinguished_name]
CN = app.localhost

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = app.localhost
DNS.3 = api.localhost
EOF

openssl req -new -key "$CERTS_DIR/server.key" \
  -out "$CERTS_DIR/server.csr" \
  -config "$CERTS_DIR/openssl.cnf"

# === 3. Signature avec la CA ===
echo "✍️ Signature du certificat serveur avec la CA..."
openssl x509 -req -in "$CERTS_DIR/server.csr" \
  -CA "$CERTS_DIR/myCA.crt" -CAkey "$CERTS_DIR/myCA.key" -CAcreateserial \
  -out "$CERTS_DIR/server.crt" -days 825 -sha256 \
  -extfile "$CERTS_DIR/openssl.cnf" -extensions v3_req

echo "✅ Certificat généré :"
echo " - CA       : $CERTS_DIR/myCA.crt"
echo " - Key      : $CERTS_DIR/server.key"
echo " - Cert     : $CERTS_DIR/server.crt"
