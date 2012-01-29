class Role < ActiveRecord::Base
  def admin?
    self.permission == "admin"
  end
end
