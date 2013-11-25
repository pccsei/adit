module CommonMethods
  def get_current_project
    project = Project.find_by "project_end > ?", Time.now
    return project.id
  end
end