all:
	bundle update
	bundle exec catttl public/dataset public/item public/item-nier public/lessonPlan public/schema public/section public/shapes public/test > public/all-`date +%Y%m%d`.ttl

check:
	pyshacl -f turtle -s `ls -1 public/shapes-*.ttl|tail -1` `ls -1 public/all-*.ttl|tail -1` | ./shacl_result_filter.rb
	./check.rb

clean:
	-rm -rf public/小* public/中* public/index.html public/about.html public/*.html public/*[^0-9].ttl

release:
	@for f in test section item item-nier lessonPlan dataset schema shapes; do \
	  file=$$(ls -1 public/$${f}-????????.ttl 2>/dev/null | tail -1 || true); \
	  if [ -z "$$file" ]; then \
	    echo "WARN: no match for public/$${f}-????????.ttl" >&2; \
	    continue; \
	  fi; \
	  base=$$(basename "$$file" .ttl); \
	  printf "_:%s a void:Dataset;\n  void:dataDump naaa:%s.ttl .\n" "$$base" "$$base"; \
	done
