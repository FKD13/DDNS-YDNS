# DDNS-YDNS

Based on: https://github.com/ydns/bash-updater/blob/master/updater.sh

Rewritten in vlang for fun!

## Compiling

run `make`

## Running

### Configuration

All configuration goes trough 3 env variables

| | |
|-|-|
| YDNS_USER | Your YDNS username |
| YDNS_PASS | Your YDNS password |
| YDNS_DOMAINS | A `;` separated list of domains you want to update |

### Running

When the variables have been set you can run using `ddns-ydns`

### Deployment

I have deployed this in a podman container. A plain service should also work :)