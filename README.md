# caddycloudflare

This is a work in progress. Do not use in production as of yet!

 - Replace variables in [BRACKETS]
 - Create custom bridge network (ie. man-bridge) in order for [DNS resolution to work](https://docs.docker.com/network/bridge/#differences-between-user-defined-bridges-and-the-default-bridge)
 - Run the container


    docker run -d -p 80:80 -p 443:443 \
    --network="man-bridge" \
    -v /home/[USERNAME]/docker-data/caddy/caddy_data:/data \
    -v /var/www/:/var/www \
    -v /home/[USERNAME]/docker-data/caddy/caddy_config:/config \
    -v /home/[USERNAME]/docker-data/caddy/Caddyfile:/etc/caddy/Caddyfile \
    -e CLOUDFLARE_EMAIL=[YOURCLOUDFLAREMAIL] \
    -e CLOUDFLARE_API_TOKEN=[YOURAPITIOKEN] \
    -e ACME_AGREE=true \
    --name caddy zottelbeyer/caddycloudflare:latest

Sample Caddy File:

    {
            email [YOUREMAIL]
    }

    # default
    exampledomain.com www.exampledomain.com {
            root * /var/www/default.exampledomain.com/
            file_server

            tls [YOUREMAIL] {
                dns cloudflare {env.CLOUDFLARE_API_TOKEN}
            }

            log {
                    output file /data/exampledomain.com.log
            }
    }

    # portainer
    portainer.exampledomain.com {

            reverse_proxy http://portainer:9000

            tls [YOUREMAIL] {
                dns cloudflare {env.CLOUDFLARE_API_TOKEN}
            }

            log {
                    output file /data/portainer.exampledomain.com.log
            }

    }

    # nexcloud
    cloud.exampledomain.com {
            rewrite /.well-known/carddav /remote.php/dav
            rewrite /.well-known/caldav /remote.php/dav
            reverse_proxy http://nextcloud:80

            tls [YOUREMAIL] {
                dns cloudflare {env.CLOUDFLARE_API_TOKEN}
            }

            log {
                    output file /data/cloud.exampledomain.com.log
            }
    }
