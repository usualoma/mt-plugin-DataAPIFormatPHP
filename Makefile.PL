use ExtUtils::MakeMaker;
use YAML;

my $config = YAML::LoadFile((glob('./plugins/*/config.yaml'))[0]);

WriteMakefile(
    NAME     => $config->{name},
    VERSION  => $config->{version},
    SKIP     => [qw(distdir)],
    DISTNAME => $config->{name},
);

sub MY::top_targets {
    << 'Makefile';
perlmodules : extlib=plugins/$(NAME)/extlib
perlmodules :
	carton install || :
	rm -fr $(extlib)
	mkdir $(extlib)
	mv local/lib/perl5/PHP $(extlib)
	mv local/lib/perl5/UNIVERSAL $(extlib)
	rm -fr local

create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir perlmodules
	$(NOECHO) $(NOOP)

Makefile
}
