# Logfile created on 2015-05-26 21:32:45 -0700 by logger.rb/36483


Started GET "/events/my" for 127.0.0.1 at 2015-05-26 21:32:54 -0700
  Processing by EventsController#my as HTML
Creating scope :all. Overwriting existing method Event.all.
  [1m[36mUser Load (0.2ms)[0m  [1mSELECT "users".* FROM "users" WHERE "users"."andrew_id" = 'admin' LIMIT 1[0m
  [1m[35mEvent Load (0.2ms)[0m  SELECT "events".* FROM "events" WHERE "events"."user_id" = 1 LIMIT 1
In events#my
Rendered events/my.html.erb within layouts/application (1.6ms)
Rendered shared/_header.html.erb (2.1ms)
Rendered shared/_footer.html.erb (0.8ms)
Completed 200 OK in 134ms (Views: 35.9ms | ActiveRecord: 2.4ms)


Started GET "/assets/application.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:54 -0700
Served asset /application.css - 304 Not Modified (0ms)


Started GET "/assets/approval.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:54 -0700
Served asset /approval.css - 304 Not Modified (8ms)


Started GET "/assets/base/jquery.ui.base.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:54 -0700
Served asset /base/jquery.ui.base.css - 304 Not Modified (2ms)


Started GET "/assets/base/jquery.ui.all.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:54 -0700
Served asset /base/jquery.ui.all.css - 304 Not Modified (1ms)


Started GET "/assets/base.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:54 -0700
Served asset /base.css - 304 Not Modified (2ms)


Started GET "/assets/base/jquery.ui.datepicker.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /base/jquery.ui.datepicker.css - 304 Not Modified (6ms)


Started GET "/assets/base/jquery.ui.core.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /base/jquery.ui.core.css - 304 Not Modified (1ms)


Started GET "/assets/base/jquery.ui.theme.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /base/jquery.ui.theme.css - 304 Not Modified (2ms)


Started GET "/assets/isotope.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /isotope.css - 304 Not Modified (1ms)


Started GET "/assets/events.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /events.css - 304 Not Modified (4ms)


Started GET "/assets/organizations.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /organizations.css - 304 Not Modified (1ms)


Started GET "/assets/scaffolds.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /scaffolds.css - 304 Not Modified (3ms)


Started GET "/assets/reset.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /reset.css - 304 Not Modified (1ms)


Started GET "/assets/base/jquery.ui.core.css" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /base/jquery.ui.core.css - 304 Not Modified (0ms)


Started GET "/assets/test.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /test.css - 304 Not Modified (2ms)


Started GET "/assets/users.css?body=1" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /users.css - 304 Not Modified (2ms)


Started GET "/assets/base/jquery.ui.datepicker.css" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /base/jquery.ui.datepicker.css - 304 Not Modified (0ms)


Started GET "/assets/base/jquery.ui.base.css" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /base/jquery.ui.base.css - 304 Not Modified (0ms)


Started GET "/assets/base/jquery.ui.theme.css" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /base/jquery.ui.theme.css - 304 Not Modified (0ms)


Started GET "/assets/application.js?body=1" for 127.0.0.1 at 2015-05-26 21:32:55 -0700
Served asset /application.js - 304 Not Modified (0ms)
