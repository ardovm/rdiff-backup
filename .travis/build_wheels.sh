#!/bin/bash
set -e -x

# Install a system package required by our library
yum install -y librsync-devel

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    "${PYBIN}/pip" wheel /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair "$whl" --plat $PLAT -w /io/wheelhouse/
done

# Install packages
for PYBIN in /opt/python/*/bin/; do
    "${PYBIN}/pip" install rdiff-backup --no-index -f /io/wheelhouse
done
