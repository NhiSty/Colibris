# Run the project in development mode

```bash
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d 
```

# Run the project in production mode

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

# Check the logs

```bash
docker logs -f golang
```

# if you need to reload the container

```bash
docker compose restart golang
```

# swagger url

```bash
http://localhost:8080/api/v1/swagger/index.html
```
