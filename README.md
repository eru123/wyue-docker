# wyue-docker

Docker image for Wyue PHP applications. One container with everything a Wyue app needs to run: PHP, Apache, Node, and the JavaScript package managers.

Prebuilt image:

```
docker pull ghcr.io/eru123/wyue-docker:8.4-apache
```

## What's inside

| Component | Version | Notes |
|---|---|---|
| Alpine | 3.21 | base |
| PHP | 8.4.27 | compiled from source, ZTS, mod_php via apxs |
| Apache httpd | 2.4.69 | current stable, source build |
| Node | 24.22.1 | Krypton LTS |
| yarn | 1.22.22 | classic, latest of the 1.x line |
| pnpm | 12.15.0 | via corepack |
| Composer | latest | installed at build time |

PHP ships with the extensions Wyue apps use: mysqli, pdo_mysql, mbstring, intl, bcmath, gd (freetype/jpeg/webp), soap, zip, curl, openssl.

## Tags

- `8.4-apache` - the stable tag, tracks main
- `latest` - same image, convenience alias
- `main-<sha>` - per-commit builds, useful for pinning or bisecting

Builds happen in GitHub Actions on every push to main that touches `8.4-apache/`. The workflow file is `.github/workflows/build-wyue.yml`.

## Build it yourself

```
cd 8.4-apache
docker build -t wyue:8.4-apache .
```

Expect 10 to 15 minutes on a decent machine. PHP and httpd are compiled from source; the rest is downloads. Docker BuildKit layer caching helps a lot on rebuilds.

## Run it

```
docker run -d --name wyue -p 8080:80 -v $(pwd)/app:/var/www/html wyue:8.4-apache
```

The entrypoint starts httpd in the foreground. `php.ini-production` is the default configuration; mount your own over `/usr/local/etc/php/php.ini` if you need different settings.

## Layout

```
8.4-apache/
  Dockerfile          the whole build
  entrypoint.sh       container startup
  httpd-foreground    httpd launcher
  php.ini-production  default ini
  php.ini-development dev ini, not used by default
```

## Version bumps

Versions live in `ENV` lines near the top of the Dockerfile. httpd also carries a `SHA256` that must match the tarball published at `https://downloads.apache.org/httpd/`, and Node carries a checksum for the musl build it downloads. Update both when bumping those versions, then let CI build and push.

## License

Apache-2.0, same as the image contents.
