# session-testnet-dockerfile

## example usage
```
services:
  stagenet:
    image: javabudd/session-testnet:2.0.0
    ports:
      - "13025:13025"
      - "13022:13022"
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
      - QUORUMNET_PORT=13025
      - P2P_PORT=13022
  stagenet2:
    image: javabudd/session-testnet:2.0.0
    restart: unless-stopped
    privileged: true
    volumes:
      - ./oxen2:/var/lib/oxen
    tty: true
    stdin_open: true
    ports:
      - "12025:12025"
      - "12022:12022"
    ulimits:
      nproc: 65535
      nofile:
        soft: 65535
        hard: 65535
    environment:
      - SERVICE_NODE_IP_ADDRESS=x.x.x.x
      - QUORUMNET_PORT=12025
      - P2P_PORT=12022
```
