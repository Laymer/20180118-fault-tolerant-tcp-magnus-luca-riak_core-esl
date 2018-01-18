BASEDIR = $(shell pwd)
REBAR = rebar3
RELPATH = _build/default/rel/sdb
PRODRELPATH = _build/prod/rel/sdb
DEV1RELPATH = _build/dev1/rel/sdb
DEV2RELPATH = _build/dev2/rel/sdb
DEV3RELPATH = _build/dev3/rel/sdb
APPNAME = sdb
SHELL = /bin/bash

release:
	$(REBAR) release
	mkdir -p $(RELPATH)/../sdb_config
	[ -f $(RELPATH)/../sdb_config/sdb.conf ] || cp $(RELPATH)/etc/sdb.conf  $(RELPATH)/../sdb_config/sdb.conf
	[ -f $(RELPATH)/../sdb_config/advanced.config ] || cp $(RELPATH)/etc/advanced.config  $(RELPATH)/../sdb_config/advanced.config

console:
	cd $(RELPATH) && ./bin/sdb console

prod-release:
	$(REBAR) as prod release
	mkdir -p $(PRODRELPATH)/../sdb_config
	[ -f $(PRODRELPATH)/../sdb_config/sdb.conf ] || cp $(PRODRELPATH)/etc/sdb.conf  $(PRODRELPATH)/../sdb_config/sdb.conf
	[ -f $(PRODRELPATH)/../sdb_config/advanced.config ] || cp $(PRODRELPATH)/etc/advanced.config  $(PRODRELPATH)/../sdb_config/advanced.config

prod-console:
	cd $(PRODRELPATH) && ./bin/sdb console

compile:
	$(REBAR) compile

clean:
	$(REBAR) clean

test:
	$(REBAR) ct

devrel1:
	$(REBAR) as dev1 release
	mkdir -p $(DEV1RELPATH)/../sdb_config
	[ -f $(DEV1RELPATH)/../sdb_config/sdb.conf ] || cp $(DEV1RELPATH)/etc/sdb.conf  $(DEV1RELPATH)/../sdb_config/sdb.conf
	[ -f $(DEV1RELPATH)/../sdb_config/advanced.config ] || cp $(DEV1RELPATH)/etc/advanced.config  $(DEV1RELPATH)/../sdb_config/advanced.config

devrel2:
	$(REBAR) as dev2 release
	mkdir -p $(DEV2RELPATH)/../sdb_config
	[ -f $(DEV2RELPATH)/../sdb_config/sdb.conf ] || cp $(DEV2RELPATH)/etc/sdb.conf  $(DEV2RELPATH)/../sdb_config/sdb.conf
	[ -f $(DEV2RELPATH)/../sdb_config/advanced.config ] || cp $(DEV2RELPATH)/etc/advanced.config  $(DEV2RELPATH)/../sdb_config/advanced.config

devrel3:
	$(REBAR) as dev3 release
	mkdir -p $(DEV3RELPATH)/../sdb_config
	[ -f $(DEV3RELPATH)/../sdb_config/sdb.conf ] || cp $(DEV3RELPATH)/etc/sdb.conf  $(DEV3RELPATH)/../sdb_config/sdb.conf
	[ -f $(DEV3RELPATH)/../sdb_config/advanced.config ] || cp $(DEV3RELPATH)/etc/advanced.config  $(DEV3RELPATH)/../sdb_config/advanced.config

devrel: devrel1 devrel2 devrel3

dev1-console:
	$(BASEDIR)/_build/dev1/rel/sdb/bin/$(APPNAME) console

dev2-console:
	$(BASEDIR)/_build/dev2/rel/sdb/bin/$(APPNAME) console

dev3-console:
	$(BASEDIR)/_build/dev3/rel/sdb/bin/$(APPNAME) console

devrel-start:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/sdb/bin/$(APPNAME) start; done

devrel-join:
	for d in $(BASEDIR)/_build/dev{2,3}; do $$d/rel/sdb/bin/$(APPNAME)-admin cluster join sdb1@127.0.0.1; done

devrel-cluster-plan:
	$(BASEDIR)/_build/dev1/rel/sdb/bin/$(APPNAME)-admin cluster plan

devrel-cluster-commit:
	$(BASEDIR)/_build/dev1/rel/sdb/bin/$(APPNAME)-admin cluster commit

devrel-status:
	$(BASEDIR)/_build/dev1/rel/sdb/bin/$(APPNAME)-admin member-status

devrel-ping:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/sdb/bin/$(APPNAME) ping; done

devrel-stop:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/sdb/bin/$(APPNAME) stop; done

start:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) start

stop:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) stop

attach:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) attach

