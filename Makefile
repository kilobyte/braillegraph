PROGS=braillegraph
MANS=$(PROGS:%=%.1)
TITLE=braillegraph
#TODO: $(VERSION)

all: $(MANS)
clean:
	rm -f $(MANS)

# If we're in a git repository, most likely the timestamp will be useless
# -- but we can check the last commit date.  When not in git, it's probably
# a tarball with files with good timestamps (use "git restore-mtime" when
# releasing).  If some vandal used quilt, this will be wrong and
# non-reproducible -- but using quilt is wrong, period.
#
# Use perl instead of touch -d @foo because OpenBSD.
%.1: %.pod
	$(QUIET_POD)d=`git log -1 --pretty="format:%ct" $<|cut -f 1 -d ' '`;\
	if test -n "$$d";then perl -e "utime undef,$$d,'$<'";fi;\
	pod2man -c "$(TITLE)" -s 1 -n `basename "$@"|sed 's/\.[0-9]$$//'|tr a-z A-Z` -r "$(VERSION)" -u $< >$@
