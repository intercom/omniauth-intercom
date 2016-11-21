To release a new version of the omniauth-intercom gem :
1. Checkout from master branch
  $ git checkout master
2. Pull from origin master branch
  $ git pull origin master
3. Update the version number in `omniauth-intercom/lib/intercom-ruby-app.rb`
4. Update the version number in `Readme.rb`
5. Add a CHANGELOG entry
6. Commit to master with an explicit message : "Bump to vX.Y.Z"
7. Tag the new release :
  $ git tag -a vx.y.z -m 'Tag message'
8. Push the new release :
  $ git push origin master
9. Push the new tag :
  $ git push --tags
10. Build the new gem :
  $ gem build omniauth-intercom.gemspec
11. Push the new gem :
  $ gem push omniauth-intercom-X.Y.Z.gem
