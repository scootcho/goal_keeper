class AddNameOfAttrForFilepickerUrlToGoal < ActiveRecord::Migration
  def change
    add_column :goals, :filepicker_url, :string
  end
end
