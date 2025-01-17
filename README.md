# session-testnet-multinode-docker

## Requirements

* Docker
* Replace `x.x.x.x` with your external IP address in `docker-compose.yml`
* Optionally add more nodes (following the paradigm of incrementing ports + folder names)

## Example usage

`docker compose up` - start in foreground
`docker compose up -d` - start in background

## Example of adding more nodes

```
services:
  stagenet:
    build:
      dockerfile: Dockerfile
      context: .
    ports:
      - "10000:10000"
      - "10001:10001"
    restart: unless-stopped
    tty: true
    stdin_open: true
    volumes:
      - ./oxen:/var/lib/oxen
    ulimits:
      nproc: 65535
      nofile:
        soft: 65535
        hard: 65535
    environment:
      - SERVICE_NODE_IP_ADDRESS=x.x.x.x
      - QUORUMNET_PORT=10000
      - P2P_PORT=10001
  stagenet2:
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
      - "10002:10002"
      - "10003:10003"
    ulimits:
      nproc: 65535
      nofile:
        soft: 65535
        hard: 65535
    environment:
      - SERVICE_NODE_IP_ADDRESS=x.x.x.x
      - QUORUMNET_PORT=10002
      - P2P_PORT=10003
```
