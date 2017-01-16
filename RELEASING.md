To release a new version of the omniauth-intercom gem :

+ Checkout from master branch

```shell
git checkout master`
```

+ Pull from origin master branch

```shell
git pull origin master
```
+ Create a new branch

+ Update the version number in `omniauth-intercom/lib/intercom-ruby-app.rb`

+ Update the version number in `Readme.rb`

+ Add a CHANGELOG entry

+ Commit to new branch with an explicit message : "Bump to vX.Y.Z"

+ Merge the new branch to master and switch to master locally

+ Tag the new release :

```shell
git tag -a vx.y.z -m 'Tag message'
```

+ Push the new release :

```shell
git push origin master
```

+ Push the new tag :

```shell
git push --tags
```

+ Build the new gem :

```shell
gem build omniauth-intercom.gemspec
```

+ Push the new gem :

```shell
gem push omniauth-intercom-X.Y.Z.gem
```
