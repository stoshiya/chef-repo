# chef-repo

Chef Solo Recipes for AWS EC2 Linux AMI. 


## recipes

 - elasticsearch
 - gobrew
 - mongodb
 - nginx
 - nodebrew
 - node.js
 - redis
 - td-agent
 - yum

## prepare

```
$ sudo yum update -y
$ sudo yum install -y git
```

## run

```
$ git clone https://github.com/stoshiya/chef-repo.git
$ cd chef-repo
$ sudo /usr/bin/chef-solo -c solo.rb -j COOKBOOK.json
```

## create new cookbook

```
$ sudo yum install -y ruby-devel gcc
$ sudo gem install knife-solo --no-ri --no-rdoc
$ knife configure

$ knife cookbook create NEW_COOKBOOK -o site-cookbooks
$ vim site-cookbooks/NEW_COOKBOOK/recipes/default.rb
$ vim NEW_COOKBOOK.json
$ sudo /usr/bin/chef-solo -c solo.rb -j NEW_COOKBOOK.json
```
