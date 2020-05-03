#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

echo "starting build"

version="12.2"
vhash="ad1dcc4c4fc500786b745635a9e1eba950195ce20b8913f50345bb7d5369b5de"
url="https://ftp.postgresql.org/pub/source/v${version}/postgresql-${version}.tar.bz2"
app_name=postgresql-${version}
file=${app_name}.tar.bz2

echo "downloading ${file}"

wget -q -O $file $url;
hash=$(sha256sum  $file | awk '{print $1}');
if [ $hash != $vhash ]; then \
    echo "incorrect hash: $hash"
    echo "expected: $vhash"
    exit 1
fi
tar xf $file
echo "ready to compile ${app_name}"

cd /build/${app_name}

./configure --with-openssl
make world -j $(nproc)
make install-world
rm -rf /usr/local/pgsql/share/doc
rm -rf /usr/local/pgsql/share/man
mkdir -p /postgres/data
useradd -r -U -d /postgres -s /bin/bash postgres
chown postgres:postgres /postgres/data
su postgres -c '/usr/local/pgsql/bin/initdb -D /postgres/data --locale=en_US.UTF-8 --pwfile=<(echo postgres)'
chown -R 5432:5432 /postgres