# Installation of packages
```bash
go get Colibris
```
# Run the project
```bash
docker compose up -d 
```
# Check the logs
```bash
docker logs -f golang
```
# if you need to reload the container
```bash
docker compose restart golang
```

# generate the swagger documentation
```bash
swag init
```
# swagger url
```bash
http://localhost:8080/api/v1/swagger/index.html
```