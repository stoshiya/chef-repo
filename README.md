# Chef Solo Recipes for AWS EC2

## prepare

```
$ sudo yum update -y
$ sudo yum install -y ruby-gem ruby-devel gcc git
$ sudo gem install knife-solo --no-ri --no-rdoc
$ knife configure
```

## run

```
$ git clone git@github.com:stoshiya/chef-repo.git
$ cd chef-repo
$ sudo /usr/local/bin/chef-solo -c solo.rb -j COOKBOOK.json
```

## create new cookbook

```
$ knife cookbook create NEW_COOKBOOK -o site-cookbooks
$ vim site-cookbooks/NEW_COOKBOOK/recipes/default.rb
$ vim NEW_COOKBOOK.json
$ sudo /usr/local/bin/chef-solo -c solo.rb -j NEW_COOKBOOK.json
```