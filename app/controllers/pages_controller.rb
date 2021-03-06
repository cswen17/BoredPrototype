class PagesController < ApplicationController
  # GET /about
  def about
  end

  # GET /developer
  def developer
    # lifted from: stackoverflow.com/questions/10224481/
    # running-a-command-from-ruby-displaying-and-capturing-the-output
    remote = [] 
    r, io = IO.pipe
    fork do
      system("git remote show origin", out: io, err: :out)
    end
    io.close

    r.each_line do |line|
      remote << line
    end

    git_remote_output = remote.join(' ')
    matches = /Remote branches:(.*)Local/m.match(git_remote_output)
    if matches.nil?
      @branches = []
    else
      remote_branches = matches[1].split("\n")
      @branches = []
      
      remote_branches.each do |branch|
        if branch.empty?
          next
        end
        branch_name = branch.split(' ')
        @branches << branch_name[0]
      end
    end
  end

  # POST /deploy
  def deploy
    branch = params[:branch]
    system("#{Rails.root.to_s}/lib/script/restart_#{Rails.env}.sh #{branch}")
    flash[:deploy] = "Thanks for deploying branch #{branch}!
                      We can't wait to see your changes to Teudu.
                      Wait about 3-4 seconds for the server to restart,
                      then click around to review the site for your
                      changes."
    redirect_to root_path
  end
end
