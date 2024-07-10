read -p "POSTGRES_USER [acme]: " pg_user
pg_user=${pg_user:-'acme'}

read -p "POSTGRES_PASSWORD [pass]: " pg_pass
pg_pass=${pg_pass:-'pass'}

read -p "POSTGRES_DB [db]: " pg_db
pg_db=${pg_db:-'db'}

read -p "API_TOKEN [un1b0]: " api_token
jwt_token=${api_token:-'un1b0'}


export POSTGRES_USER="$pg_user"
export POSTGRES_PASSWORD="$pg_pass"
export POSTGRES_DB="$pg_db"
export DATABASE_DSN="host=bankservice-postgres user=$pg_user password=$pg_pass dbname=$pg_db port=5432"
export API_TOKEN="$api_token"

docker build -t acmesky-bankservice-api .
