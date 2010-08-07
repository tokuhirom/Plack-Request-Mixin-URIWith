use inc::Module::Install;
name 'Plack-Request-Mixin-URIWith';
all_from 'lib/Plack/Request/Mixin/URIWith.pm';

# requires '';


readme_markdown_from 'lib/Plack/Request/Mixin/URIWith.pm';
tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
test_requires 'Test::More';
test_requires 'YAML';
author_tests('xt');
# use_test_base;
auto_include;
WriteAll;
