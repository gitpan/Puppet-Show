use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
              'NAME'	   => 'Puppet::Show',
              'VERSION_FROM' => 'Show.pm', # finds $VERSION
              'dist' => {COMPRESS=>'gzip -9f', SUFFIX => 'gz'},
              ($] >= 5.005 ?
               (ABSTRACT   => 'Optional Tk GUI above Puppet::Body',
                AUTHOR     => 'Dominique Dumont (domi@barrayar.grenoble.hp.com)') : ()),
              'PREREQ_PM' =>
              {
               'Tk' => 0,
               'Tk::ObjScanner' => '0.5',
               'Tk::Multi::Text' => '2.001',
               'Tk::Multi::Toplevel' => '1.002',
               'Puppet::Log'=> '1.010',
               'Puppet::Body'=> '1.012',
               'Tk::Pod' => 0,
               'MLDBM' => 0,
               'DB_File' => 0
              }
             );
