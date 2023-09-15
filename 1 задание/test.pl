use strict;
use warnings;
use DBI;


package LogModel {
    sub new {
        my ($class, $dbh) = @_;
        return bless { dbh => $dbh }, $class;
    }

    sub insert_message {
        my ($self, $created, $id, $int_id, $str) = @_;
        my $query = "INSERT INTO message (created, id, int_id, str) VALUES (?, ?, ?, ?)";
        $self->{dbh}->do($query, undef, $created, $id, $int_id, $str);
    }

    sub insert_log {
        my ($self, $created, $int_id, $str, $address) = @_;
        my $query = "INSERT INTO log (created, int_id, str, address) VALUES (?, ?, ?, ?)";
        $self->{dbh}->do($query, undef, $created, $int_id, $str, $address);
    }
}



package LogController {
    sub new {
        my ($class, $model) = @_;
        return bless { model => $model }, $class;
    }

    sub process_log_file {
        my ($self, $log_file) = @_;
        open(my $fh, '<', $log_file) or die "Could not open log file '$log_file': $!\n";

        while (<$fh>) {
# для удаления символа новой строки
            chomp;
	#разбить строку, где использовать в каестве разделителя пробел (максимуму частей - 6) 
            my ($date, $time, $int_id, $flag, $address, @rest) = split /\s+/, $_, 6;
            my $created = "$date $time";
            my $str = join(' ', @rest);

            if ($int_id && $created) {
                if ($flag eq "<=" && $str) {
                    my $id = get_id($str);
                    if ($id) {
                        $self->{model}->insert_message($created, $id, $int_id, $str);
                    }
                } else {
                    $self->{model}->insert_log($created, $int_id, $str, $address);
                }
            }
        }

        close($fh);
    }

    sub get_id {
        my ($str) = @_;
        my ($id) = $str =~ /id=(\S+)/;
        return $id;
    }
}

#Соединение с БД
my $db_name = 'test';
my $db_user = 'test';
my $db_pass = '324Gasdg234yhg2';
my $dbh = DBI->connect("DBI:mysql:database=$db_name", $db_user, $db_pass) or die "Unable to connect: $DBI::errstr\n";

#Создание объектов
my $model = LogModel->new($dbh);
my $controller = LogController->new($model);


my $log_file = 'out';
$controller->process_log_file($log_file);

#Завершить соединение с БД
$dbh->disconnect();