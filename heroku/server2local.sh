cd "P:\Vyra\vyra-database\backups";
heroku pg:backups:capture --app=vyra;
heroku pg:backups:download ;
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d dbvyra latest.dump