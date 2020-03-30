#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

echo "starting build"

version="11.6"
vhash="49924f7ff92965fdb20c86e0696f2dc9f8553e1563124ead7beedf8910c13170"
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

./configure --with-uuid=ossp --with-openssl
make world -j $(nproc)
make install-world
mkdir -p /postgres/data
useradd -r -U -d /postgres -s /bin/bash postgres
chown postgres:postgres /postgres/data
su postgres -c '/usr/local/pgsql/bin/initdb -D /postgres/data --locale=en_US.UTF-8 --pwfile=<(echo postgres)'
chown -R 5432:5432 /postgres