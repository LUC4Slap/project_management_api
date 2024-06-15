class TasksController < ApplicationController
  before_action :require_token

  def index
    project = Project.find(parms(:id))
    tasks = project.tasks
    render json: tasks
  end

  def create
    project = Project.find(parms(:id))
    task = project.tasks.build(task_params)
    if task.save
      render json: task, status: :created
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def update
    task = Task.find(parms[:id])
    if task.update(task_params)
      render json: task
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    task = Task.find(parms[:id])
    task.destroy
    head :no_content
  end

  private
  def task_params
    params.require(:task).permit(:title, :descriprion, :completed)
  end

  def require_token
    render json: { error: 'Token required' }, status: :unauthorized unless @current_user
  end
end
