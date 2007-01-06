package Authen::GoogleAccount;

use warnings;
use strict;

=head1 NAME

Authen::GoogleAccount - Simple Authentication with Google Account

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    # step 1
    # redirect to goole to get token
    use CGI;
    use Authen::GoogleAccount;
    my $q = CGI->new;
    my $ga = Authen::GoogleAccount->new;
    
    # set callback url to verify token
    my $next = "http://www.example.com/googleauth.cgi";
    my $uri_to_login = $ga->uri_to_login($next);
    
    print $q->redirect($uri_to_login);
    
    
    
    
    # step 2
    # user will be redirected to http://www.example.com/googleauth.cgi?token=(token)
    # get token with CGI.pm and give it to verify()
    use CGI;
    use Authen::GoogleAccount;
    my $q = CGI->new;
    my $ga = Authen::GoogleAccount->new;
    
    my $token = $q->param('token');
    
    $ga->verify($token) or die $ga->errstr;
    print "login succeeded\n";



=head1 FUNCTIONS

=head2 new

Creates a new object.

=head2 uri_to_login($next)

Creates a URI to login Google Account.

User will be redirected to $next with token after a successful login.

=head2 verify($token)

Verifies given token and returns 1 when the token is successfully verified.

=head2 errstr

Returns error message.

=head1 LIMITATIONS

This module cannot get any information(email, name, etc.) of Google Account for now.
Please teach me the way of getting account information.

=head1 AUTHOR

Hogeist, C<< <mahito at cpan.org> >>, L<http://www.ornithopter.jp/>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-authen-googleaccount at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Authen-GoogleAccount>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Authen::GoogleAccount

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Authen-GoogleAccount>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Authen-GoogleAccount>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Authen-GoogleAccount>

=item * Search CPAN

L<http://search.cpan.org/dist/Authen-GoogleAccount>

=back


=head1 COPYRIGHT & LICENSE

Copyright 2007 Hogeist, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut


use URI::Escape;
use LWP::UserAgent;


sub new {
	my $class = shift;
	my $self = {};
	bless $self, $class;
}



sub uri_to_login {
	my $self = shift;
	my $next = shift;
	
	return 'https://www.google.com/accounts/AuthSubRequest?scope=http%3A%2F%2Fwww.google.com%2Fcalendar%2Ffeeds%2F&session=0&next=' 
		 . uri_escape($next);
}

sub verify {
	my $self = shift;
	my $token = shift;
	
	my $ua = LWP::UserAgent->new();
	my $res = $ua->get(
		'https://www.google.com/accounts/AuthSubTokenInfo',
		'Authorization' => 'AuthSub token="' . $token . '"',
	);
	if ($res->is_success){
		return 1;
	}
	else{
		$self->{_errstr} = $res->message;
		return 0;
	}
}

sub errstr {
	my $self = shift;
	return $self->{_errstr};
}










1; # End of Authen::GoogleAccount
