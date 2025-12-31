all:
	bundle update
	bundle exec catttl public/dataset public/item public/item-nier public/lessonPlan public/schema public/section public/test > public/all-`date +%Y%m%d`.ttl
