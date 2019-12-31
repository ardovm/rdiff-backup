#!/bin/sh
set -e -x

ls /opt/python
pybindirs="/opt/python/cp35* /opt/python/cp36* /opt/python/cp37* /opt/python/cp38*"

# Install a system package required by our library
yum install -y librsync-devel

# Compile wheels
for PYBIN in $pybindirs; do
    "${PYBIN}/pip" wheel /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair "$whl" --plat $PLAT -w /io/wheelhouse/
done

# Install packages
for PYBIN in $pybindirs; do
    "${PYBIN}/pip" install rdiff-backup --no-index -f /io/wheelhouse
done
