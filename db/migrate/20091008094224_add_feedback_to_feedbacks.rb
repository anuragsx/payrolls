class AddFeedbackToFeedbacks < ActiveRecord::Migration
  def self.up
    add_column :feedbacks, :feedback, :text
    add_column :feedbacks, :user_id, :integer
  end

  def self.down
    remove_column :feedbacks, :feedback
    remove_column :feedbacks, :user_id
  end
end
