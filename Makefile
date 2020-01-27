build-image:
	docker build -t yyarmoshyk/jekyll-image:ruby-2.5 .

init:
	docker run --name jekyll-init --rm -v "${PWD}/myblog:/myblog" -it yyarmoshyk/jekyll-image:ruby-2.5 /bin/bash -c "bundle exec jekyll new myblog"

verify:
	docker run --name jekyll-verify --rm -v "${PWD}/test:/myblog/test" -v "${PWD}/myblog:/myblog" -it yyarmoshyk/jekyll-image:ruby-2.5 /bin/bash -c "cd /myblog; bundle install; bundle exec jekyll build -d test"

build:
	docker run --name jekyll-build --rm -v "${PWD}/public:/myblog/public" -v "${PWD}/myblog:/myblog" -it yyarmoshyk/jekyll-image:ruby-2.5 /bin/bash -c "cd /myblog; bundle; bundle exec jekyll build -d public"

run:
	docker run --name jekyll-kube-crib --rm -v "${PWD}/public:/myblog/public" -v "${PWD}/myblog:/myblog" -p 4000:4000 -it yyarmoshyk/jekyll-image:ruby-2.5 /bin/bash -c "cd /myblog; bundle install; bundle exec jekyll serve"

run-nginx:
	docker run --name jekyll-nginx --rm -v "${PWD}/public:/usr/share/nginx/html" -p 80:80 nginx

deploy:
	bash deploy_s3.sh
