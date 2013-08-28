# Change this file to be a wrapper around your daemon code.

# Do your post daemonization configuration here
# At minimum you need just the first line (without the block), or a lot
# of strange things might start happening...
DaemonKit::Application.running! do |config|
  # Trap signals with blocks or procs
  # config.trap( 'INT' ) do
  #   # do something clever
  # end
  # config.trap( 'TERM', Proc.new { puts 'No YesBot, Noooooooo!' } )
end

DaemonKit.logger.info "YesBot running"
r = Snooby::Client.new('YesBot by andrhamm, v1.0')
# r.authorize!('HmmmmmYes', 'nvCGKfmTSPlRPsHRCIG6kwwB0aRhtVHttm8QEhj5pOIdqJGktd5MZi0ESVETdi19')

loop do

  DaemonKit.logger.info "Looking for lulz…"

  # puts r.user('andrhamm').about
  r.r.posts.each do |post|
    DaemonKit.logger.info "Next post… #{post.id} (#{post.comments.count})"
    post.comments.each do |comment|
      if !comment.body.nil? && comment.body.length < 300 && comment.body =~ /^([^\?.]*) or (.*)\?$/
        already_yessed = false
        if defined? comment.replies[:data][:children]
          DaemonKit.logger.info "checking sub comments #{comment.id} (#{comment.replies[:data][:children].count})"
          comment.replies[:data][:children].each do |sub_comment|
            if !sub_comment[:data][:body].nil? && sub_comment[:data][:body] =~ /^yes/i
              already_yessed = true
            end
          end
        end
        puts ">>>>\n#{comment.body}\n<<<< #{post.permalink}, #{already_yessed}"
      end
    end
  end

  DaemonKit.logger.info "Napping…"

  sleep 30
end
