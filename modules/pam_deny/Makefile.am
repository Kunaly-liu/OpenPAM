if CUSTOM_MODULES_DIR
moduledir = $(OPENPAM_MODULES_DIR)
else
moduledir = $(libdir)
endif
AM_CPPFLAGS = -I$(top_srcdir)/include

module_LTLIBRARIES = pam_deny.la

pam_deny_la_SOURCES = pam_deny.c
pam_deny_la_LDFLAGS = -no-undefined -module -version-info $(LIB_MAJ) \
	-export-symbols-regex '^pam_sm_'
if WITH_SYSTEM_LIBPAM
pam_deny_la_LIBADD = $(SYSTEM_LIBPAM)
else
pam_deny_la_LIBADD = $(top_builddir)/lib/libpam/libpam.la
endif
