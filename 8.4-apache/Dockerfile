FROM alpine:3.21

LABEL maintainer="wyue"
LABEL description="Wyue Applications Specialized Docker Container"
LABEL org.opencontainers.image.source="https://github.com/wyue/wyue-docker"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.authors="Jericho Aquino <jericho@skiddph.com>"
LABEL org.opencontainers.image.description="Wyue Applications Specialized Docker Container"

# versions
ENV PHP_VERSION=8.4.6
ENV NODE_VERSION=22.15.0
ENV YARN_VERSION=1.22.22
ENV HTTPD_VERSION=2.4.63
ENV HTTPD_SHA256=88fc236ab99b2864b248de7d49a008ec2afd7551e64dce8b95f58f32f94c46ab
ENV HTTPD_PATCHES=""

RUN apk update && apk upgrade

# Install Apache from the ground
RUN set -x \
	&& adduser -u 82 -D -S -G www-data www-data
ENV HTTPD_PREFIX=/usr/local/apache2
ENV PATH=$HTTPD_PREFIX/bin:$PATH
RUN mkdir -p "$HTTPD_PREFIX" \
  && chown www-data:www-data "$HTTPD_PREFIX"
WORKDIR $HTTPD_PREFIX
RUN set -eux; \
	apk add --no-cache \
		apr \
		apr-util \
		apr-util-ldap \
		ca-certificates \
		perl \
	;

RUN set -eux; \
	\
	apk add --no-cache --virtual .build-deps \
		apr-dev \
		apr-util-dev \
		coreutils \
		dpkg-dev dpkg \
		gcc \
		gnupg \
		libc-dev \
		patch \
		# mod_md
		curl-dev \
		jansson-dev \
		# mod_proxy_html mod_xml2enc
		libxml2-dev \
		# mod_lua
		lua-dev \
		make \
		# mod_http2
		nghttp2-dev \
		# mod_session_crypto
		openssl \
		openssl-dev \
		pcre-dev \
		tar \
		# mod_deflate
		zlib-dev \
		# mod_brotli
		brotli-dev \
	; \
	\
	ddist() { \
		local f="$1"; shift; \
		local distFile="$1"; shift; \
		local success=; \
		local distUrl=; \
		for distUrl in \
			'https://www.apache.org/dyn/closer.cgi?action=download&filename=' \
			https://downloads.apache.org/ \
			https://www-us.apache.org/dist/ \
			https://www.apache.org/dist/ \
			https://archive.apache.org/dist/ \
		; do \
			if wget -O "$f" "$distUrl$distFile" && [ -s "$f" ]; then \
				success=1; \
				break; \
			fi; \
		done; \
		[ -n "$success" ]; \
	}; \
	\
	ddist 'httpd.tar.bz2' "httpd/httpd-$HTTPD_VERSION.tar.bz2"; \
	echo "$HTTPD_SHA256 *httpd.tar.bz2" | sha256sum -c -; \
	\
	ddist 'httpd.tar.bz2.asc' "httpd/httpd-$HTTPD_VERSION.tar.bz2.asc"; \
	export GNUPGHOME="$(mktemp -d)"; \
	for key in \
		DE29FB3971E71543FD2DC049508EAEC5302DA568 \
		13155B0E9E634F42BF6C163FDDBA64BA2C312D2F \
		8B39757B1D8A994DF2433ED58B3A601F08C975E5 \
		31EE1A81B8D066548156D37B7D6DBFD1F08E012A \
		A10208FEC3152DD7C0C9B59B361522D782AB7BD1 \
		3DE024AFDA7A4B15CB6C14410F81AA8AB0D5F771 \
		EB138C6AF0FC691001B16D93344A844D751D7F27 \
		CBA5A7C21EC143314C41393E5B968010E04F9A89 \
		3C016F2B764621BB549C66B516A96495E2226795 \
		937FB3994A242BA9BF49E93021454AF0CC8B0F7E \
		EAD1359A4C0F2D37472AAF28F55DF0293A4E7AC9 \
		4C1EADADB4EF5007579C919C6635B6C0DE885DD3 \
		01E475360FCCF1D0F24B9D145D414AE1E005C9CB \
		92CCEF0AA7DD46AC3A0F498BCA6939748103A37E \
		D395C7573A68B9796D38C258153FA0CD75A67692 \
		FA39B617B61493FD283503E7EED1EA392261D073 \
		984FB3350C1D5C7A3282255BB31B213D208F5064 \
		FE7A49DAA875E890B4167F76CCB2EB46E76CF6D0 \
		39F6691A0ECF0C50E8BB849CF78875F642721F00 \
		29A2BA848177B73878277FA475CAA2A3F39B3750 \
		120A8667241AEDD4A78B46104C042818311A3DE5 \
		453510BDA6C5855624E009236D0BC73A40581837 \
		0DE5C55C6BF3B2352DABB89E13249B4FEC88A0BF \
		7CDBED100806552182F98844E8E7E00B4DAA1988 \
		A8BA9617EF3BCCAC3B29B869EDB105896F9522D8 \
		3E6AC004854F3A7F03566B592FF06894E55B0D0E \
		5B5181C2C0AB13E59DA3F7A3EC582EB639FF092C \
		A93D62ECC3C8EA12DB220EC934EA76E6791485A8 \
		65B2D44FE74BD5E3DE3AC3F082781DE46D5954FA \
		8935926745E1CE7E3ED748F6EC99EE267EB5F61A \
		E3480043595621FE56105F112AB12A7ADC55C003 \
		93525CFCF6FDFFB3FD9700DD5A4B10AE43B56A27 \
		C55AB7B9139EB2263CD1AABC19B033D1760C227B \
		26F51EF9A82F4ACB43F1903ED377C9E7D1944C66 \
	; do \
		gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
	done; \
	gpg --batch --verify httpd.tar.bz2.asc httpd.tar.bz2; \
	command -v gpgconf && gpgconf --kill all || :; \
	rm -rf "$GNUPGHOME" httpd.tar.bz2.asc; \
	\
	mkdir -p src; \
	tar -xf httpd.tar.bz2 -C src --strip-components=1; \
	rm httpd.tar.bz2; \
	cd src; \
	\
	patches() { \
		while [ "$#" -gt 0 ]; do \
			local patchFile="$1"; shift; \
			local patchSha256="$1"; shift; \
			ddist "$patchFile" "httpd/patches/apply_to_$HTTPD_VERSION/$patchFile"; \
			echo "$patchSha256 *$patchFile" | sha256sum -c -; \
			patch -p0 < "$patchFile"; \
			rm -f "$patchFile"; \
		done; \
	}; \
	patches $HTTPD_PATCHES; \
	\
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	./configure \
		--build="$gnuArch" \
		--prefix="$HTTPD_PREFIX" \
		--enable-mods-shared=reallyall \
		--enable-mpms-shared=all \
	; \
	make -j "$(nproc)"; \
	make install; \
	\
	cd ..; \
	rm -r src man manual; \
	\
	sed -ri \
		-e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
		-e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
		-e 's!^(\s*TransferLog)\s+\S+!\1 /proc/self/fd/1!g' \
		-e 's!^(\s*User)\s+daemon\s*$!\1 www-data!g' \
		-e 's!^(\s*Group)\s+daemon\s*$!\1 www-data!g' \
		"$HTTPD_PREFIX/conf/httpd.conf" \
		"$HTTPD_PREFIX/conf/extra/httpd-ssl.conf" \
	; \
	grep -E '^\s*User www-data$' "$HTTPD_PREFIX/conf/httpd.conf"; \
	grep -E '^\s*Group www-data$' "$HTTPD_PREFIX/conf/httpd.conf"; \
	\
	deps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-network --virtual .httpd-so-deps $deps; \
	apk del --no-network .build-deps; \
	\
	httpd -v

STOPSIGNAL SIGWINCH

COPY httpd-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/httpd-foreground

WORKDIR /var/www/html

# Install necessary build dependencies and other utilities
# Re-evaluate this line to ensure all GD dependencies are explicitly listed
# You already have libjpeg-turbo-dev, libwebp-dev, libpng-dev, freetype-dev, zlib-dev (from httpd build-deps)
# Also ensuring runtime libs are present just in case the dev versions don't pull them in directly for linking
RUN apk add --no-cache \
    autoconf \
    build-base \
    pkgconf \
    libxml2-dev \
    openssl-dev \
    curl-dev \
    libzip-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    sqlite-dev \
    apache2-dev \
    icu-dev \
    oniguruma-dev \
    apr-dev \
    curl \
    bash \
    perl \
    apr-util-dev \
    libpng-dev \
    libzip-dev \
    # Ensure runtime dependencies for GD are also explicitly added if not covered by -dev packages
    libjpeg-turbo \
    libwebp \
    libpng \
    freetype \
    zlib



# Download and extract PHP source code
RUN wget -O /tmp/php.tar.gz "https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz" \
    && tar -xzf /tmp/php.tar.gz -C $HOME \
    && rm /tmp/php.tar.gz

# Configure and compile PHP
RUN cd $HOME/php-${PHP_VERSION} \
    && ./configure \
    --with-config-file-path=/usr/local/etc/php \
    --with-config-file-scan-dir=/usr/local/etc/php/conf.d \
    --disable-rpath \
    --enable-inline-optimization \
    --disable-debug \
    --disable-maintainer-zts \
    --with-curl \
    --with-openssl \
    --with-zlib \
    --with-mysqli \
    --with-pdo-mysql \
    --with-zip \
    --with-freetype \
    --with-jpeg \
    --with-webp \
    --enable-mbstring \
    --enable-intl \
    --enable-bcmath \
    --enable-module=shared \
    --with-apxs2=/usr/local/apache2/bin/apxs \ 
    --with-libxml2 \
    --with-png \
    --enable-gd \ 
    --enable-soap \
    && make -j$(nproc) \
    && make install \
    && rm -rf $HOME/php-${PHP_VERSION}/ 

# Copy PHP configuration
COPY php.ini-development /usr/local/etc/php/php.ini-development
COPY php.ini-production /usr/local/etc/php/php.ini-production
COPY php.ini-production /usr/local/etc/php/php.ini

# Composer installation
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --version \
    && composer clear-cache

# Node installation from source
RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    && apk add --no-cache \
        libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        curl \
    && ARCH= OPENSSL_ARCH='linux*' && alpineArch="$(apk --print-arch)" \
      && case "${alpineArch##*-}" in \
        x86_64) ARCH='x64' CHECKSUM="60198941802e88659bb3b30b9a45b694b1c695cf33c1ef58863f854996d11d5d" OPENSSL_ARCH=linux-x86_64;; \
        x86) OPENSSL_ARCH=linux-elf;; \
        aarch64) OPENSSL_ARCH=linux-aarch64;; \
        arm*) OPENSSL_ARCH=linux-armv4;; \
        ppc64le) OPENSSL_ARCH=linux-ppc64le;; \
        s390x) OPENSSL_ARCH=linux-s390x;; \
        *) ;; \
      esac \
  && if [ -n "${CHECKSUM}" ]; then \
    set -eu; \
    curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz"; \
    echo "$CHECKSUM  node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" | sha256sum -c - \
      && tar -xJf "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
      && ln -s /usr/local/bin/node /usr/local/bin/nodejs; \
  else \
    echo "Building from source" \
    && apk add --no-cache --virtual .build-deps-full \
        binutils-gold \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python3 \
        py-setuptools \
    && export GNUPGHOME="$(mktemp -d)" \
    && for key in \
      C0D6248439F1D5604AAFFB4021D900FFDB233756 \
      DD792F5973C6DE52C432CBDAC77ABFA00DDBF2B7 \
      CC68F5A3106FF448322E48ED27F5E38D5B0A215F \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      890C08DB8579162FEE0DF9DB8BEAB4DFCF555EF4 \
      C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
      108F52B48DB57BB0CC439B2997B01419BD92F80A \
      A363A499291CBBC940DD62E41F10027AF002F8B0 \
    ; do \
      gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
      gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
    done \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && gpgconf --kill all \
    && rm -rf "$GNUPGHOME" \
    && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) V= \
    && make install \
    && apk del .build-deps-full \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt; \
  fi \
  && rm -f "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" \
  && find /usr/local/include/node/openssl/archs -mindepth 1 -maxdepth 1 ! -name "$OPENSSL_ARCH" -exec rm -rf {} \; \
  && apk del .build-deps \
  && node --version \
  && npm --version \
  && rm -rf /tmp/*

# Install Yarn
RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \
  && export GNUPGHOME="$(mktemp -d)" \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && gpgconf --kill all \
  && rm -rf "$GNUPGHOME" \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && apk del .build-deps-yarn \
  && yarn --version \
  && rm -rf /tmp/*

# Install pnpm
RUN apk add --no-cache --virtual .build-deps-pnpm curl \
  && curl -fsSL https://unpkg.com/@pnpm/self-installer | node \
  && apk del .build-deps-pnpm \
  && pnpm --version \
  && rm -rf /tmp/*

# Create document root
RUN mkdir -p /var/www/html
RUN mkdir -p /var/www/cgi-bin
RUN mkdir -p /var/www/logs && chown -R www-data:www-data /var/www/logs

# Apache configuration
RUN sed -i 's|ServerRoot "/usr/local/apache2"|ServerRoot "/var/www"|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's|DocumentRoot "/usr/local/apache2/htdocs"|DocumentRoot "/var/www/html"|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's|<Directory "/usr/local/apache2/htdocs">|<Directory "/var/www/html">|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's|ScriptAlias /cgi-bin/ "/usr/local/apache2/cgi-bin/"|ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's|<Directory "/usr/local/apache2/cgi-bin">|<Directory "/var/www/cgi-bin">|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's|/usr/local/apache2/htdocs|/var/www/html|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's|#ServerName www.example.com:80|ServerName localhost:80|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's|#LoadModule mime_module modules/mod_mime.so|LoadModule mime_module /usr/local/apache2/modules/mod_mime.so|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's|#LoadModule dir_module modules/mod_dir.so|LoadModule dir_module /usr/local/apache2/modules/mod_dir.so|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's|#LoadModule rewrite_module modules/mod_rewrite.so|LoadModule rewrite_module /usr/local/apache2/modules/mod_rewrite.so|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's|#LoadModule proxy_module modules/mod_proxy.so|LoadModule proxy_module /usr/local/apache2/modules/mod_proxy.so|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's|#LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so|LoadModule proxy_fcgi_module /usr/local/apache2/modules/mod_proxy_fcgi.so|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's|_module modules/mod_|_module /usr/local/apache2/modules/mod_|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's| modules/libphp.so| /usr/local/apache2/modules/libphp.so|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's|Include conf/extra/proxy-html.conf|Include /usr/local/apache2/conf/extra/proxy-html.conf|g' /usr/local/apache2/conf/httpd.conf
RUN sed -i 's|TypesConfig conf/mime.types|TypesConfig /usr/local/apache2/conf/mime.types|g' /usr/local/apache2/conf/httpd.conf

# Process and handle PHP
RUN sed -i 's|AddType application/x-gzip .gz .tgz|AddType application/x-gzip .gz .tgz\nAddType application/x-httpd-php .php|g' /usr/local/apache2/conf/httpd.conf
RUN echo "<VirtualHost *:80>" >> /usr/local/apache2/conf/httpd.conf
RUN echo "    DocumentRoot /var/www/html" >> /usr/local/apache2/conf/httpd.conf
RUN echo "    <FilesMatch \.php$>" >> /usr/local/apache2/conf/httpd.conf
RUN echo "        SetHandler application/x-httpd-php" >> /usr/local/apache2/conf/httpd.conf
RUN echo "    </FilesMatch>" >> /usr/local/apache2/conf/httpd.conf
RUN echo "    <Directory /var/www/html>" >> /usr/local/apache2/conf/httpd.conf
RUN echo "        Options Indexes FollowSymLinks" >> /usr/local/apache2/conf/httpd.conf
RUN echo "        AllowOverride All" >> /usr/local/apache2/conf/httpd.conf
RUN echo "        Require all granted" >> /usr/local/apache2/conf/httpd.conf
RUN echo "    </Directory>" >> /usr/local/apache2/conf/httpd.conf
RUN echo "    ErrorLog /proc/self/fd/2" >> /usr/local/apache2/conf/httpd.conf
RUN echo "    CustomLog /proc/self/fd/1 common" >> /usr/local/apache2/conf/httpd.conf
RUN echo "</VirtualHost>" >> /usr/local/apache2/conf/httpd.conf

# RUN sed -i 's|;extension=gd|extension=gd|g' /usr/local/etc/php/php.ini

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 80
EXPOSE 80

# Start Apache
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
