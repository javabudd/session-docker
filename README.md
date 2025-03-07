# session-docker

## Requirements

* Docker

## Setup

* Copy `.env.dist` to `.env`
* Replace `SERVICE_NODE_IP_ADDRESS` with your external IP address in `.env`
* Replace `L2_PROVIDER` with your desired l2 provider in `.env`
* Update ports in `.env` if desired and make sure to forward them appropriately

## Example usage

* `docker compose up` - start in foreground
* `docker compose up -d` - start in background

## Stake a node

* `docker compose exec session bash`
* `oxend prepare_registration...`
