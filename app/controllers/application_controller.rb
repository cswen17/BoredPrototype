class ApplicationController < ActionController::Base

  protect_from_forgery

  include Secrets
  include Exceptions
  rescue_from Exception, :with => :render_error

  def render_error(exception)
    # the exception's backtrace is logged to
    # BoredPrototype/logs/production.log
    logger.debug exception.backtrace
    exc = exception
    render	:text => "Exception #{exc}, backtrace #{exc.backtrace}"
  end

  def current_user
    current_user = nil
    if Rails.env == "production"
      shibboleth_current_user = ENV["eppn"]
      current_user = User.find_by_andrew_id(shibboleth_current_user)
      # if the current user doesn't exist, then we should create them
      new_user = User.new()
      shibboleth_possible_name = ENV["displayName"].split(' ')

      if shibboleth_possible_name.empty?
        # fixme: remove me. this is connie posing the hugest security
        # threat to the app because she is locked out of teudu
        # because she is no longer a student at cmu
        shibboleth_current_user = 'cswen'
        shibboleth_possible_name = 'Connie Wen'

      end

      first_name = shibboleth_possible_name.first or '(None)'
      last_name = shibboleth_possible_name.last or '(None)'

      new_user.andrew_id = shibboleth_current_user
      new_user.first_name = first_name
      new_user.last_name = last_name
      new_user.save()
      current_user = new_user
    else
      current_user = User.find_by_andrew_id('admin')
    end
    @current_user ||= current_user
  end
  helper_method :current_user

  def dropbox_client
    # todo: put this token in a table
    tok = Secrets.get_dropbox
    @dropbox_client ||= DropboxClient.new(tok)
  end
  helper_method :dropbox

  def dropbox_url_for(flyer_path)
    # find the documentation for .media here:
    # dropbox.github.io/dropbox-sdk-ruby/api-docs/v1.6.4/DropboxClient.html
    return '/flyers/original/cmuthemall.jpg'
    if flyer_path == nil or flyer_path == ''
        return '/flyers/original/cmuthemall.jpg'
    end
    if flyer_path == '/flyers/original/cmuthemall.jpg'
        return flyer_path
    end
    if flyer_path.include? "http"
        return flyer_path 
    end
    response = dropbox_client().media(flyer_path)
    if response == nil or response["url"] == nil
        logger.debug response
        logger.debug response['url']
        return '/public/flyers/original/missing.png'
    end
    return response["url"]
  end
  helper_method :dropbox_url_for

  def facebook_secret
    render json: Secrets.get_facebook.to_json
  end

  def google_secret
    render json: Secrets.get_google.to_json
  end
end
