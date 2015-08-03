class ApplicationController < ActionController::Base
    protect_from_forgery
    include Exceptions
        rescue_from Exception, :with => :render_error

    def render_error(exception)
        # the exception's backtrace is logged to
        # BoredPrototype/logs/production.log
        logger.debug exception.backtrace
        render	:text => "Exception #{exception}, backtrace #{exception.backtrace}"
    end

    def current_user
        @current_user ||= User.find_by_andrew_id('admin')
    end
    helper_method :current_user
end
