MANIFESTS=datanode.po defaults.po hadoop.po historyserver.po  hive.po jobtracker.po Makefile master.po namenode.po nodemanager.po pig.po resourcemanager.po sqoop.po tasktracker.po worker.po
TESTS_DIR=$(dir $(CURDIR))
MODULE_DIR=$(TESTS_DIR:/=)
MODULES_DIR=$(dir $(MODULE_DIR))

all:	test

test: $(MANIFESTS) 

%.po:	%.pp
	puppet apply --noop --modulepath $(MODULES_DIR) $<
