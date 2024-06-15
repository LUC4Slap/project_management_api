class MembershipsController < ApplicationController
  before_action :require_token

  def index
    project = Project.find(params[:project_id])
    memberships = project.memberships
    render json: memberships
  end

  def create
    project = Project.find(params[:project_id])
    membership = project.memberships.build(membership_params)
    # debugger
    existe = project.memberships.find { |hash| hash[:user_id] == membership_params[:user_id]}
    if existe
      render json: { message: "Usuario ja esta no projeto"}, status: :unprocessable_entity
      return
    end
    if membership.save
      render json: membership, status: :created
    else
      render json: membership.errors, status: :unprocessable_entity
    end
  end

  def update
    membership = Membership.find(params[:id])
    if membership.update(membership_params)
      render json: membership
    else
      render json: membership.errors, status: :unprocessable_entity
    end
  end

  def destroy
    membership = Membership.find(params[:id])
    membership.destroy
    head :no_content
  end

  private

  def membership_params
    params.require(:membership).permit(:user_id, :role)
  end

  def require_token
    render json: { error: 'Token required' }, status: :unauthorized unless @current_user
  end
end
