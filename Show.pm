############################################################
#
# $Header: /mnt/barrayar/d06/home/domi/Tools/perlDev/Puppet_Show/RCS/Show.pm,v 1.3 1999/02/05 12:02:41 domi Exp $
#
# $Source: /mnt/barrayar/d06/home/domi/Tools/perlDev/Puppet_Show/RCS/Show.pm,v $
# $Revision: 1.3 $
# $Locker:  $
# 
############################################################

package Puppet::Show ;

use Carp ;
use Tk::Multi::Manager ;
use Tk::Multi::Text ;
use Tk::Multi::Toplevel ;
use Puppet::Body;
use Puppet::Log ;
use AutoLoader 'AUTOLOAD' ;

use strict ;
use vars qw($VERSION @ISA) ;
$VERSION = sprintf "%d.%03d", q$Revision: 1.3 $ =~ /(\d+)\.(\d+)/; 
@ISA=qw/Puppet::Body/;

sub new 
  {
    my $type = shift ;
    my %args = @_ ;

    my $topTk = delete $args{topTk} ; # could be a global variable
    my $self= Puppet::Body::new($type,@_);

    $self->{topTk} = $topTk;
    $self->{podName} = $args{podName} || 'Puppet::Show';
    $self->{podSection} = $args{podSection} || 'DESCRIPTION';
   
    die "No parameter topTk passed to Puppet::Show $self->{name}\n"
      unless defined $topTk ;
    return $self;
  }

sub _createLogs
  {
    my $self = shift ;
    my $how = shift ;

    # config debug window
    foreach (qw/debug event/)
      {
        my $what = $_ ;
        $self->{'log'}{$_} = new Puppet::Log
          (
           title => $_,
           how => $how
          );
      }
  }

1;

__END__

=head1 NAME

Puppet::Show - Optional Tk Gui for Puppet::Body

=head1 SYNOPSIS

 use Puppet::Show ;

 package myClass ;

 sub new
  {
    my $type = shift ;
    my $self = {};
    
    # no inheritance, your class contains the Puppet::Show class
    $self->{body} = new Puppet::Show(cloth => $self, @_) ;

    bless $self,$type ;
  }

 package main;

 my $mw = MainWindow-> new ;

 # these 2 parameters are passed to Puppet::Show constructor
 my $test = new MyTest( name => 'foo', 'topTk' => $mw) ;

 $test->display;

 MainLoop ; # Tk's

=head1 DESCRIPTION

Puppet::Show is a utility class that is used (and not inherited like
the deprecated Puppet::Any) to manage a L<Puppet::Body> class through
an optional GUI.

So when you construct a Puppet::Show object, you have all the
functionnality of this object without the GUI. Then, when the need
arises, you may (or the user class may decide to) open the GUI of
Puppet::Show so the user may perform any interactive action.

On the other hand, if the need does not arise, you may instanciate a lot of 
objects (which uses Puppet::Show) without cluttering your display.

The user class may use the Puppet::Show Tk widget (actually a
Tk::Multi::Toplevel widget) and add its own widget to customize the
GUI to its needs.

This class features :

=over 4

=item *

A L<Tk::Multi::Toplevel> to show or hide the different display of the
Show class (or of the user class)

=item *

A menu bar (part of L<Tk::Multi::Toplevel>)

=item *

An online help (part of L<Tk::Multi::Toplevel>)

=item *

An event log display so user object may log their activity (See L<Puppet::Log>)

=item *

A Debug log display so user objects may log their "accidental"
activities (See L<Puppet::Log>)

=item *

An Object Scanner (See L<Tk::ObjScanner>) to display the attributes of
the user object

=item *

A set of functions to manage "has-a" relationship between Puppet
objects.  (See L<Puppet::Body>).  The menu bar feature a "content" bar
which enabled the user to open the display of all "contained" objects.

=item *

A facility to store data on a database file tied to a hash. (part of
L<Puppet::Body>)

=back

=head1 DEFAULT WINDOWS

=head2 debug log window

This log window (see L<Puppet::Log>) will get all debug information for 
this instance of the object. More or less reserved for developers of 
classes using Puppet::Show.

Note that log sent to the 'event' window will also be displayed in the debug
window for better clarity.

=head2 event log window

This log window (see L<Puppet::Log>) will get all event information for 
this instance of the object. 

=head1 Constructor

=head2 new( ... )

Creates new Puppet::Show object.  The constructor uses all
L<Puppet::Body/"Constructor"> parameters plus:

=over 4

=item topTk

The ref of the main Tk window

=item podName

The name of the pod file that will be used for the online help.
(See L<Tk::Pod>)

=item podSection

The name of the pod section that will be used for the online help

=back

=head1 Methods

=head2 acquire(...)

Acquire the object ref as a child. Parameters are:

=over 4

=item *

body: Reference of the Puppet::Body object that is to be acquired.

=item *

raise: Sub reference or method to call on the user object when the
object is raised (generally through the 'content' menu).  (Default to
call display on the user object)

=item *

myRaise: Sub reference or method to call when this object is raised
(generally through the 'container' menu).  (Default to call
$self->display())

=back

For instance if object foo acquires object bar, bar becomes part of
foo's content and foo is one of the container of bar.

=cut

#'


=head2 display(...)

Creates a top level display for the user object.

Parameters are:

=over 4

=item *

master: Optional. You can set it to 1 if this object will be the master
object of your application. In this case, destroying its display
(with the File->close menu for instance) will make the application exit.

=back

Return the L<Tk::Multi::Toplevel> object if a display is actually created,
undef otherwise (i.e is the display already exists).

=head2 closeDisplay()

Close the display. Note that the display can be re-created later.

=head1 About Puppet body classes

Puppet classes are a set of utility classes which can be used by any object.
If you use directly the Puppet::*Body class, you get the plain functionnality.
And if you use the Puppet::* class, you can get the same functionnality and
a Tk Gui to manage it. 

=head1 AUTHOR

Dominique Dumont, Dominique_Dumont@grenoble.hp.com

Copyright (c) 1998-1999 Dominique Dumont. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

Tk(3), Puppet::Log(3), Puppet::LogBody(3), Puppet::Body(3),
Tk::Multi::Toplevel(3), Tk::Multi::Manager(3)

=cut

sub acquire
  {
    my $self = shift ;
    my %args = @_;

    my $raise = $args{raise} ;
    my $ref = $args{body};
    my $myRaise = $args{myRaise};
   
    $self->SUPER::acquire(raise => $raise, body => $ref);

    return unless defined $self->{multitop};
    $ref->whenAcquired(raise => $myRaise, body => $self);
   
    $self->updateMenu(raise => $raise,
                      body => $ref, 
                      menu => 'content');
  }

#internal
sub whenAcquired
  {
    my $self = shift;
    return unless defined $self->{multitop};
    $self->updateMenu(@_,menu => 'container');
  }

#internal
sub updateMenu
  {
    my $self = shift;
    my %args = @_;

    my $raise = $args{raise} ;
    my $ref = $args{body};
    my $menu = $args{menu};

    # method or sub ref to invoke when raising the object
    my $sub = ref($raise) eq 'CODE' ? $raise :
      defined $raise ? sub{$ref->cloth->$raise(); } :
        sub{$ref->cloth->display(); } ;
    
    my $name = $args{name} || $ref->getName();

    $self->{multitop}->menuCommand
      (
       name => $name,
       menu =>$menu,
       command => $sub
      );

  }


sub drop
  {
    my $self = shift ;

    $self->SUPER::drop(@_);

    foreach my $name (@_)
      {
        $self->{multitop}->menuRemove(name => $name,menu => 'content');
      }
  }

sub droppedBy
  {
    my $self = shift ;
    my $ref = shift;

    $self->closeDisplay unless $self->SUPER::droppedBy(@_);
  }

# defines a top level display for each object, contains a MultiText ,amager
# and a objScanner.

# can be called with no parameter -> show itself
sub display
  {
    my $self =shift ;
    my %args = @_;

    my $master = $args{master}; # master destroyed -> exit ;

    if (defined $self->{multitop})
      {
        $self->{multitop}->deiconify() 
          if ($self->{multitop}->state() eq 'iconic') ;
	$self->{multitop}->raise();
	return undef ;
      }
    
    my $type = ref($self) ;
    $type =~ s/^.*::// ;
    my $labelName = ref($self->cloth).': '.$self->{'name'} ;
    
    $self->printDebug("Creating Multitop display for ".ref($self)."\n") ;

    my $poof ;
    $self->{multitop} = $self->{topTk} -> MultiTop
      (
       podName => $self->{podName},
       podSection => $self->{podSection},
       manager => $self->cloth
      );

    my $dsub ;
    if (defined $master and $master) { $dsub = sub{$self->{topTk}->destroy;};}
    else {$dsub = sub{delete $self->{multitop};};}

    $self->{multitop} -> OnDestroy($dsub); 

    $self->{multitop} -> title($labelName) ;

    # config debug window
    foreach (qw(debug event))
      {
        $self->{'log'}{$_} -> display ($self->{multitop},1);
      }
   
    foreach my $what (qw/container content/)
      {
        next unless defined $self->{$what} ;

        foreach my $name (sort keys %{$self->{$what}})
          {
            my $ref = $self->{$what}{$name};
            my $sub = ref($self->{raise}) eq 'CODE' ? $self->{raise} :
              sub{$ref->cloth->display(); } ;
            $self->{multitop}->menuCommand
              ( 
               name => $name,
               menu => $what,
               command => $sub
              ) ;
          }
      }

    return $self->{multitop} ;
  }

sub closeDisplay
  {
    my $self = shift ;

    # must delete all values stored during display creation
    unless (defined $self->{multitop})
      {
        $self->printDebug
          ("$self->{name} closeDisplay called while not displaying\n") ;
        return ;
      }

    # this element will be deleted by the OnDestroy hook set in display()
    $self->{multitop}->destroy;
  }


sub showEvent
  {
    my $self= shift ;
    $self->{'log'}{'event'} -> show ();
  }

1;

