# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
require 'garb'

Garb::Session.login("google@shelby.tv", "s0up4y0u")
profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == 'UA-21191360-6'}

class Stats
  extend Garb::Model

  metrics :pageviews, :visitors, :avgTimeOnSite, :totalEvents
end

SCHEDULER.every '60s' do
  stat = Stats.results(profile, :start_date => Time.now()-604800, :end_date => Time.now(), :filters => {:page_path.does_not_contain => '/video'}).to_a[0]
  puts stat.inspect
  send_event('analytics_page_views', { current: stat.pageviews.to_i })
  send_event('analytics_visitors', { current: stat.visitors.to_i })
  send_event('analytics_avgTimeOnSite', { current: (stat.avg_time_on_site.to_i/60) })

end
