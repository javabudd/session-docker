# session-multinode-docker

## Requirements

* Docker
* Copy `docker-compose.override.yml.dist` to `docker-compose.override.yml`
* Replace `SERVICE_NODE_IP_ADDRESS` with your external IP address in `docker-compose.override.yml`
* Replace `L2_PROVIDER` with your desired l2 provider in `docker-compose.override.yml`
* Optionally add more nodes (following the paradigm of incrementing ports + folder names)

## Example usage

* `docker compose up` - start in foreground
* `docker compose up -d` - start in background

## Example of adding more nodes (docker-compose.override.yml)

```
services:
  session:
    environment:
      - SERVICE_NODE_IP_ADDRESS=x.x.x.x
      - L2_PROVIDER=https://foo.bar.rpc
  session2:
    build:
      dockerfile: Dockerfile
      context: .
    restart: unless-stopped
    privileged: true
    volumes:
      - ./oxen2:/var/lib/oxen
    tty: true
    stdin_open: true
    ports:
      - "10005:22020/tcp"
      - "10005:22020/udp"
      - "10006:22021/tcp"
      - "10007:22022/tcp"
      - "10008:22025/tcp"
      - "10009:1090/udp"
    ulimits:
      nproc: 65535
      nofile:
        soft: 65535
        hard: 65535
    environment:
      - SERVICE_NODE_IP_ADDRESS=x.x.x.x
      - L2_PROVIDER=https://foo.bar.rpc
```
