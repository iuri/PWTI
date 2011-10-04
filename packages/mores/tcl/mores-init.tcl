ad_schedule_proc -thread t  240  mores::util::sync_microblog
ad_schedule_proc -thread t  300 mores::util::sync_medias
ad_schedule_proc -thread t  300 mores::util::sync_medias_fb
ad_schedule_proc -thread t  3600 mores::util::sync_all
ad_schedule_proc -thread t  30 mores::util::sync_twitter_posts
#ad_schedule_proc -thread t  120 mores::util::daemon

