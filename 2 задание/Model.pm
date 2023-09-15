package Model;

use strict;
use warnings;
use DBI;


sub new {
    my ($class) = @_;
    my $self = bless {}, $class;

    my $db_name = 'test';
    my $db_user = 'test';
    my $db_pass = '324Gasdg234yhg2';
    #соединение с БД
    $self->{dbh} = DBI->connect("DBI:mysql:database=$db_name", $db_user, $db_pass) or die "Unable to connect: $DBI::errstr\n";

    return $self;
}

sub search_logs {
    my ($self, $recipient) = @_;

    my $query = "SELECT message.created, message.str FROM log LEFT JOIN message ON log.int_id = message.int_id WHERE log.address LIKE ? ORDER BY message.created DESC";

    my $stmt = $self->{dbh}->prepare($query);
    $stmt->bind_param(1, "%$recipient%");
    $stmt->execute;

    my @results;
    #отфилтровать полученные результат
    while (my ($created, $str) = $stmt->fetchrow_array) {
        push @results, { created => $created, str => $str };
    }

    return \@results;
}

sub disconnect {
    my ($self) = @_;
    $self->{dbh}->disconnect;
}

1;