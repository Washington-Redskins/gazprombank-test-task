package View;

use strict;
use warnings;

sub new {
    my ($class) = @_;
    return bless {}, $class;
}

sub render_results {
    my ($self, $results) = @_;

    my $output = "<html><head><title>Log Search Results</title></head><body><h1>Log Search Results</h1>";

    if (@$results > 0) {
        $output .= "<ul>";
        my $count = 0;
        foreach my $result (@$results) {
            $output .= "<li>$result->{created} $result->{str}</li>";
            $count++;
            last if $count >= 100;  #получеть первые 100 значений
        }
        $output .= "</ul>";

        #если значений больше, чем 100
        if (@$results > 100) {
            $output .= "<p>Records more, than 100</p>";
        }
    } else {
        $output .= "There is no records";
    }


    $output .= "</body></html>";

    return $output;
}

1;