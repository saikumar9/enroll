#!/ bin/bash

exit_code=0

echo "*** Running aca_shop_market gem specs"

#bundle install | grep Installing
bundle exec rspec spec
exit_code+=$?

exit $exit_code