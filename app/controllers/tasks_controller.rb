class TasksController < ApplicationController
  #未ログイン時はログイン画面に飛ぶ
  before_action :require_user_logged_in, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  #ログインしていなければタスクの操作 (CRUD) ができない
  before_action :correct_user, only: [:show, :edit, :update, :destroy] 
  

  def index
     @tasks = current_user.tasks.order(id: :desc).page(params[:page])
  end
  
  def show
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'タスクが正常に追加されました'
      redirect_to @task
    else
       flash.now[:danger] = 'タスクが追加されませんでした'
       render :new
    end
  end
  
  def edit
  end
  
  def update 
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    
    flash[:success] = 'タスクが正常に削除されました'
    redirect_to tasks_url
  end


  private
  
  # Strong Parameter
  #def set_task
   # @task = Task.find(params[:id])
  #end
  def task_params
    params.require(:task).permit(:content, :status)
  end
  def correct_user
     @task = current_user.tasks.find_by(id: params[:id])
    
    unless @task
      redirect_to root_url
    end
  end
  

end