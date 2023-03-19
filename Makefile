SHELL := /bin/bash

BRANCH := $(shell git name-rev --name-only HEAD)
COMMIT := $(shell git rev-parse --short HEAD)
VERSION := pigodot ${BRANCH} [${COMMIT}]

F=scripts/pigodot.gd
START_REG=var version : String = \"
END_REG=\" \# %%VERSION%%
set-version:
	@printf "Setting version to \"${VERSION}\"\n"
	@perl -pi -e "s/(?<=${START_REG}).*(?=${END_REG})/${VERSION}/g" ${F}