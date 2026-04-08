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
if [ -f "${ENV_FILE}" ] && grep -q "S3_ACCESS_KEY_ID=GK" "${ENV_FILE}" 2>/dev/null; then
  echo "[garage-init] Credentials already present in garage.env, skipping key creation."
  KEY_ID=$(grep "S3_ACCESS_KEY_ID" "${ENV_FILE}" | cut -d'=' -f2)
else
  echo "[garage-init] Creating access key '${KEY_NAME}'..."
  KEY_INFO=$(docker exec garage /garage -c /etc/garage.toml key create "${KEY_NAME}" 2>&1)
  KEY_ID=$(echo "$KEY_INFO"   | grep "Key ID:"     | awk '{print $NF}')
  SECRET=$(echo "$KEY_INFO"   | grep "Secret key:" | awk '{print $NF}')

  cat > "${ENV_FILE}" <<EOF
S3_ENDPOINT=http://localhost:3900
S3_REGION=garage
S3_BUCKET=${BUCKET}
S3_ACCESS_KEY_ID=${KEY_ID}
S3_SECRET_ACCESS_KEY=${SECRET}
EOF
  echo "[garage-init] Credentials saved to garage.env"
fi

# ── 5. Permissions ────────────────────────────────────────────────────────────
echo "[garage-init] Granting read/write/owner on '${BUCKET}' to key ${KEY_ID}..."
docker exec garage /garage -c /etc/garage.toml bucket allow \
  --read --write --owner "${BUCKET}" --key "${KEY_ID}" > /dev/null 2>&1

echo "[garage-init] Done!"
