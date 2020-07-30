RPM_BASE:=$(shell rpmspec --query bfscripts.spec)
SRPM_NAME:=$(subst .noarch,,$(RPM_BASE)).src.rpm
GIT_FILES:=$(shell git ls-files -co --exclude-standard)

.PHONY: all clean
all: $(SRPM_NAME)

clean:
	rm -r RPMBUILD
	rm -r git_dir_pack
	rm -f mlxbf-bfscripts*.src.rpm

RPMBUILD/SOURCES/mlxbf-bfscripts.tar.gz: $(GIT_FILES)
	mkdir -p RPMBUILD/SOURCES
	rm -rf git_dir_pack
	mkdir -p git_dir_pack/bfscripts
	rsync --relative $(GIT_FILES) git_dir_pack/bfscripts
	(cd git_dir_pack; tar -zcvf ../$@ bfscripts)

$(SRPM_NAME): RPMBUILD/SOURCES/mlxbf-bfscripts.tar.gz \
  bfscripts.spec
	rpmbuild -bs --define "_topdir $(shell pwd)/RPMBUILD" bfscripts.spec
	cp RPMBUILD/SRPMS/$(SRPM_NAME) ./
