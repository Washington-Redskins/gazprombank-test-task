#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use lib '.';
use Model;
use View;

# Создать объект CGI-обработчика
my $cgi = CGI->new;

#Получить значение get-параметра recipient
my $recipient = $cgi->param('recipient');

#Создать объекты классов Модели и Представления
my $model = Model->new;
my $view = View->new;

# Найти все записи
my $results = $model->search_logs($recipient);

#Создать представление
my $output = $view->render_results($results);

#Вывести заголовки Content-Type header
print $cgi->header;

#выести Представление
print $output;

#Закрыть соединение с БД
$model->disconnect;


