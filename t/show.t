# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..6\n"; }
END {print "not ok 1\n" unless $loaded;}
use Tk ;
use ExtUtils::testlib;
use Puppet::Show ;
use Tk::ErrorDialog; 
$loaded = 1;
my $idx = 1;
print "ok ",$idx++,"\n";

my $trace = shift ;

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

use strict ;

package MyTest ;

sub new
  {
    my $type = shift ;
    my $self = {};
    my %args = @_ ;

    $self->{name}=$args{name};
    $self->{topTk}= $args{topTk};
    $self->{body} = new Puppet::Show(cloth => $self, @_) ;

    bless $self,$type ;
  }

sub body { return shift->{body} ;}

sub addChildren
  {
    my $self = shift ;

    # create myself some children
    foreach my $n (qw/albert charlotte raymond spirou zorglub/)
      {
        my $obj = new MyTest (name => $n, 'topTk' => $self->{topTk});
        $self->{body}->acquire(body => $obj->body);
      }
  }

sub display
  {
    my $self = shift ;

    $self->{body}->printEvent("Display called for $self->{name}\n");

    my $top =  $self->{body}-> display(@_ );

    return unless defined $top ;

    $top->newSlave(type => 'MultiText', title => 'sample text')
      ->insert('end', "Sample text in $self->{name} text widget");
    

    $top->add
      (
       'command',
       '-label' => 'acquire toto', 
       -command => sub
       {        
         my $t =new MyTest (name => 'toto', 'topTk' => $self->{topTk});
         
         $self->{body}->acquire(body => $t->body,
                               raise => sub {print "toto displayed";$t->display;} ) ;
       }
      ) ;
    
    $top->add
      (
       'command',
       '-label' => 'rm toto', 
       -command => sub{$self->drop('toto')}
      ) ;

    $top->add
      (
       'command',
       '-label' => 'acquire common', 
       -command => sub{$self->{body}->acquire(body => $main::common->body);}
      ) ;

    $top->add
      (
       'command',
       '-label' => 'close raymond', 
       -command => sub{
         if (defined $self->{content}{'raymond'})
           {
             $self->{content}{'raymond'}->closeDisplay ;
           } 
         else {$self->{tk}{toplevel}->bell;}
       }
      ) ;

    $top->menuCommand
      (
       menu => 'More',
       name => 'Dummy',
       command => sub{print "Dummy button\n";} 
      );
  }

package main ;

my $mw = MainWindow-> new ;
$mw->withdraw ;

my @a = defined $trace ? qw/how print/ : ();

my $test = new MyTest(name => 'main test', 
                      'topTk' => $mw, @a) ;

print "ok ",$idx++,"\n";

$::common = new MyTest(name => 'common' , 'topTk' => $mw ) ;
print "ok ",$idx++,"\n";

$test->addChildren() ;
print "ok ",$idx++,"\n";

$test->display( master => 1);
print "ok ",$idx++,"\n";

#$test->showEvent;

MainLoop ; # Tk's

print "ok ",$idx++,"\n";
