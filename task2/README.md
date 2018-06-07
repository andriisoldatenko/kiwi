## Crew database


1. We need docker
```bash
docker pull sameersbn/postgresql:9.6
```

2. Run
```bash
docker run --name postgresql -itd --restart always \
  --publish 5432:5432 \
  --volume /Users/andrii/docker/postgresql:/var/lib/postgresql sameersbn/postgresql:9.6
```

3. Connect
```bash
docker exec -it postgresql sudo -u postgres psql
```