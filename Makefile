all:
	bundle update
	bundle exec catttl public/dataset public/item public/item-nier public/lessonPlan public/schema public/section public/shapes public/test > public/all-`date +%Y%m%d`.ttl
	pyshacl -f turtle -s `ls -1 public/shapes-*.ttl|tail -1` public/all-`date +%Y%m%d`.ttl | ./shacl_result_filter.rb
	./check.rb

clean:
	-rm -rf public/小* public/中* public/index.html public/about.html public/*.html public/*[^0-9].ttl
