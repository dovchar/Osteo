module Calendar
  class ApplicationController < ActionController::Base

    # Locale
    before_filter :set_locale

    protected

    # Sets the locale from parameters.
    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    # Sets the locale as part of the URLs.
    # See http://guides.rubyonrails.org/i18n.html
    # See http://apidock.com/rails/ActionController/Base/default_url_options
    def default_url_options(options = nil)
      { locale: I18n.locale }
    end
  end
end
