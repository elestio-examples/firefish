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

docker-compose up db --detach && sleep 5 && docker-compose exec db sh -c 'psql --user="${POSTGRES_USER}" --dbname="${POSTGRES_DB}" --command="CREATE EXTENSION pgroonga;"'