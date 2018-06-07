## Redis lua


1. We need docker
```bash
docker run -d --name redis -p 6379:6379 redis
```

2. How to run or debug
```bash
$ redis-cli --eval picky_airlines.lua 12
"12"

$ redis-cli --eval picky_airlines.lua 122
"Please select aircarft_id between 1..80"
```