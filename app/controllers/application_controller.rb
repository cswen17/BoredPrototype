class ApplicationController < ActionController::Base
    protect_from_forgery
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
        @current_user ||= User.find_by_andrew_id('admin')
    end
    helper_method :current_user

    def dropbox_client
        # todo: put this token in a table
        tok = '7V9e7A8ykkAAAAAAAAAAD3KEU5113HGCq0yPSLSP89UJN5C-Ir40elPBauqHhC_3'
        @dropbox_client ||= DropboxClient.new(tok)
    end
    helper_method :dropbox

    def dropbox_url_for(flyer_path)
        # find the documentation for .media here:
        # dropbox.github.io/dropbox-sdk-ruby/api-docs/v1.6.4/DropboxClient.html
        if flyer_path == nil or flyer_path == ''
            return '/flyers/original/cmuthemall.jpg'
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
end
