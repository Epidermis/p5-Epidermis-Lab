package Epidermis::Lab::Connection::Role::Handles;
# ABSTRACT: Role for I/O handles

use Moo::Role;

requires qw( read_handle write_handle );

1;
