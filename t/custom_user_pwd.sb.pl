my $dir_name = 'msb_XXXX';
my $ver = '5.0.86';
my $TEST_VERSION = $ENV{TEST_VERSION} || $ver;

my @users = (
    'newuser',
    'newuser@127.0.0.1',
);

for my $user (@users) {
my $custom_user_name= $user;
my $custom_password= 'newpassword';
ok_exec( {
    command   => "make_sandbox $TEST_VERSION "
                 ." --no_confirm "
                 ." --sandbox_directory=$dir_name " 
                 ." --db_user=$custom_user_name "
                 ." --db_password=$custom_password ",
    expected  => 'sandbox server started',
    msg       => "custom server started"
    });
$ENV{MYCLIENT_OPTIONS} = '-h 127.0.0.1';
ok_sql({
    path      => "$sandbox_home/$dir_name",
    query     => "SELECT VERSION()",
    expected  => $TEST_VERSION,
    msg       => 'server is accessible',
});
$ENV{MYCLIENT_OPTIONS} = '';
ok_exec( {
    command   => "sbtool -o delete -s $sandbox_home/$dir_name ", 
    expected  => 'has been removed',
    msg       => "$dir_name removed"
    });
}
