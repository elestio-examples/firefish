#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 60s;

target=$(docker-compose port web 3000)

curl http://${target}/api/admin/accounts/create \
  -H 'accept: */*' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6' \
  -H 'cache-control: no-cache' \
  -H 'content-type: text/plain;charset=UTF-8' \
  -H 'pragma: no-cache' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36' \
  --data-raw '{"username":"admin","password":"'${ADMIN_PASSWORD}'"}' \
  --compressed


cat /opt/elestio/startPostfix.sh > post.txt
filename="./post.txt"

SMTP_LOGIN=""
SMTP_PASSWORD=""

# Read the file line by line
while IFS= read -r line; do
  # Extract the values after the flags (-e)
  values=$(echo "$line" | grep -o '\-e [^ ]*' | sed 's/-e //')

  # Loop through each value and store in respective variables
  while IFS= read -r value; do
    if [[ $value == RELAYHOST_USERNAME=* ]]; then
      SMTP_LOGIN=${value#*=}
    elif [[ $value == RELAYHOST_PASSWORD=* ]]; then
      SMTP_PASSWORD=${value#*=}
    fi
  done <<< "$values"

done < "$filename"

rm post.txt


docker-compose exec -T db bash -c "psql -U postgres postgres <<EOF
    \c firefish
    UPDATE public.meta SET \"enableEmail\"=true, \"email\"='${SMTP_LOGIN}', \"smtpSecure\"=false, \"smtpHost\"='tuesday.mxrouting.net', \"smtpPort\"=25, \"smtpUser\"='${SMTP_LOGIN}', \"smtpPass\"='${SMTP_PASSWORD}' WHERE \"id\"='x';
    UPDATE public.user_profile SET \"email\"='${ADMIN_EMAIL}', \"emailVerified\"=true WHERE \"userId\"=(SELECT id FROM public.user WHERE username='admin')
EOF";