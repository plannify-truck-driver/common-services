#!/bin/sh
set -e

ENV_FILE="/workspace/garage.env"
BUCKET="plannify"
KEY_NAME="plannify-key"

# ── 1. Wait for Garage ────────────────────────────────────────────────────────
echo "[garage-init] Waiting for Garage to start..."
until docker exec garage /garage -c /etc/garage.toml status > /dev/null 2>&1; do
  sleep 2
done

# ── 2. Layout ─────────────────────────────────────────────────────────────────
echo "[garage-init] Checking layout..."
LAYOUT_VERSION=$(docker exec garage /garage -c /etc/garage.toml layout show 2>&1 \
  | grep "Current cluster layout version:" | grep -o "[0-9]*$")

if [ -z "$LAYOUT_VERSION" ] || [ "$LAYOUT_VERSION" -eq 0 ] 2>/dev/null; then
  NODE_ID=$(docker exec garage /garage -c /etc/garage.toml node id 2>&1 \
    | head -1 | cut -d'@' -f1)
  echo "[garage-init] Configuring node ${NODE_ID} with 500MB capacity in zone 'default'..."
  docker exec garage /garage -c /etc/garage.toml layout assign -z default -c 500M "${NODE_ID}" > /dev/null 2>&1
  docker exec garage /garage -c /etc/garage.toml layout apply --version 1 > /dev/null 2>&1
  echo "[garage-init] Layout applied."
else
  echo "[garage-init] Layout already at version ${LAYOUT_VERSION}, skipping."
fi

# ── 3. Bucket ─────────────────────────────────────────────────────────────────
echo "[garage-init] Creating bucket '${BUCKET}'..."
docker exec garage /garage -c /etc/garage.toml bucket create "${BUCKET}" > /dev/null 2>&1 || true

# ── 4. Access key ─────────────────────────────────────────────────────────────
KEY_ID=""
SECRET=""

if [ -f "${ENV_FILE}" ] \
  && grep -q "^S3_ACCESS_KEY=" "${ENV_FILE}" 2>/dev/null \
  && grep -q "^S3_SECRET_KEY=" "${ENV_FILE}" 2>/dev/null; then
  KEY_ID=$(grep "^S3_ACCESS_KEY=" "${ENV_FILE}" | head -1 | cut -d'=' -f2)
  SECRET=$(grep "^S3_SECRET_KEY=" "${ENV_FILE}" | head -1 | cut -d'=' -f2)

  if docker exec garage /garage -c /etc/garage.toml key info "${KEY_ID}" > /dev/null 2>&1; then
    echo "[garage-init] Key ${KEY_ID} already exists in Garage."
  else
    echo "[garage-init] Key ${KEY_ID} missing in Garage, creating a new one..."
    KEY_ID=""
  fi
fi

if [ -z "${KEY_ID}" ]; then
  echo "[garage-init] Creating access key '${KEY_NAME}'..."
  KEY_INFO=$(docker exec garage /garage -c /etc/garage.toml key create "${KEY_NAME}" 2>&1)
  KEY_ID=$(echo "$KEY_INFO" | grep "Key ID:"     | awk '{print $NF}')
  SECRET=$(echo "$KEY_INFO" | grep "Secret key:" | awk '{print $NF}')

  cat > "${ENV_FILE}" <<EOF
S3_ENDPOINT=http://localhost:3900
S3_REGION=garage
S3_BUCKET_NAME=${BUCKET}
S3_ACCESS_KEY=${KEY_ID}
S3_SECRET_KEY=${SECRET}
EOF
  echo "[garage-init] Credentials saved to garage.env"
fi

# ── 5. Permissions ────────────────────────────────────────────────────────────
echo "[garage-init] Granting read/write/owner on '${BUCKET}' to key ${KEY_ID}..."
docker exec garage /garage -c /etc/garage.toml bucket allow \
  --read --write --owner "${BUCKET}" --key "${KEY_ID}" > /dev/null 2>&1

echo "[garage-init] Done!"
