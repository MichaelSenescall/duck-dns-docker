# duck-dns-docker
An image to automatically update a [duckdns.org](https://www.duckdns.org/) DDNS.

## Environment Variables
 * **DOMAINS** - Hostname(s) to update (e.g., "example1.duckdns.org,example2.duckdns.org")
 * **TOKEN** - Duck DNS authentication token (e.g., "ix0wp0jk-3jwr-qtks-7gk4eg1rifm0")
 * **INTERVAL** - (Optional) Time between updates, default = "30m" (e.g., "30m" where excepted suffixes are "s", "m", "h", and "d" for second, minutes, hours, and days respectively)
 * **USE_IPV4** - (Optional) Use IPv4, default = "yes"
 * **USE_IPV6** - (Optional) Use IPv4, default = "no"