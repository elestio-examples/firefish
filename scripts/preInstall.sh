#set env vars
set -o allexport; source .env; set +o allexport;

sed -i "s~DOMAIN~${DOMAIN}~g" ./.config/default.yml
sed -i "s~PASSWORD~${POSTGRES_PASSWORD}~g" ./.config/default.yml

cat <<EOT > ./servers.json
{
    "Servers": {
        "1": {
            "Name": "local",
            "Group": "Servers",
            "Host": "172.17.0.1",
            "Port": 43282,
            "MaintenanceDB": "postgres",
            "SSLMode": "prefer",
            "Username": "postgres",
            "PassFile": "/pgpass"
        }
    }
}
EOT