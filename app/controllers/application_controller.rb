class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :store_location
  before_filter :authenticate_user!

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from ActionController::ParameterMissing , with: :parameter_empty

  protected

  def after_sign_out_path_for(resource_or_scope)
    projects_path
  end

  def store_location
    if user_signed_in?
      if not request.fullpath === new_user_ichain_session_path and request.get?
        session["user_return_to"] = request.fullpath
      end
    end
  end

  def keyword_tokens
    required_parameters :q
    render json: Keyword.find_keyword(params[:q])
  end

  def parameter_empty
    redirect_to(:back)
    flash["alert-warning"] = 'Parameter missing...'
  end

end
