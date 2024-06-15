class ProjectsController < ApplicationController
  before_action :require_token

  def index
    projects = Project.all
    render json: projects
  end

  def show
    project = Project.find(params[:id])
    render json: project
  end

  def create
    project = Project.new(params[:project_params])
    if project.save
      render json: project, status: :created
    else
      render json: project.error, status: :unprocessable_entity
    end
  end

  def update
    project = Project.find(params[:id])
    if project.update(project_params)
      render json: project
    else
      render json: project.error, status: :unprocessable_entity
    end
  end

  def destroy
    project = Project.find(params[:id])
    project.destroy
    head :no_content
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end

  def require_token
    render json: { error: 'Token required' }, status: :unauthorized unless @current_user
  end

end
