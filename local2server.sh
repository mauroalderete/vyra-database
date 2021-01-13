pg_dump -Fc --no-acl --no-owner -h localhost -U postgres dbvyra > dbvyra.local.dump
copiar a un server con acceso http
heroku pg:backups:restore "http://rayquen.com/lab/heroku/dbvyra.local.dump" DATABASE_URL --app=vyra
