#!/bin/bash
set -eo pipefail

# Get into the spring-cloud-gcp repo directory
dir=$(dirname "$0")
pushd $dir/../

# Compute the project version.
PROJECT_VERSION=$(./mvnw help:evaluate -Dexpression=project.version -q -DforceStdout)

# install docuploader package
python3.6 -m pip install --user gcp-docuploader

# Build the javadocs
./mvnw clean javadoc:aggregate

# Move into generated docs directory
pushd target/site/apidocs/

python3 -m docuploader create-metadata \
    --name spring-cloud-gcp \
    --version ${PROJECT_VERSION} \
    --language java

popd
popd
