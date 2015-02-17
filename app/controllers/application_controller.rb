class ApplicationController < ActionController::Base
    protect_from_forgery
    include Exceptions
        rescue_from Exception, :with => :render_error

    def render_error(exception)
        # the exception's backtrace is logged to
        # BoredPrototype/logs/production.log
	logger.debug exception.backtrace
	render	:text => "Exception #{exception}"
    end
end
