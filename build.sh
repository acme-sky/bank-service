read -p "POSTGRES_USER [acme]: " pg_user
pg_user=${pg_user:-'acme'}

read -p "POSTGRES_PASSWORD [pass]: " pg_pass
pg_pass=${pg_pass:-'pass'}

read -p "POSTGRES_DB [db]: " pg_db
pg_db=${pg_db:-'db'}

read -p "API_TOKEN [un1b0!!Tok3n]: " api_token
api_token=${api_token:-'un1b0!!Tok3n'}

read -p "VITE_BACKEND_URL [http://localhost:8080]: " bank_api
bank_api=${bank_api:-'http://localhost:8080'}

export POSTGRES_USER="$pg_user"
export POSTGRES_PASSWORD="$pg_pass"
export POSTGRES_DB="$pg_db"
export DATABASE_URL="postgres://$pg_user:$pg_pass@bankservice-postgres:5432/$pg_db"
export API_TOKEN="$api_token"

docker build -t acmesky-bankservice-api api
docker build -t acmesky-bankservice-ui --build-arg VITE_BACKEND_URL="$bank_api" ui

docker compose up
