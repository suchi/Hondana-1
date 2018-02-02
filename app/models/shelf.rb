class Shelf < ApplicationRecord
  has_many :entries
  has_many :books, through: :entries
  
  # validates_uniqueness_of :name 使い方がわからないので保留

#  def validate
#    errors.add_to_base "何か様子が変です"
#  end

  def countbook
    return Entry.count(:conditions => ["shelf_id = #{id}"])
  end

  def countbook_comm
    return Entry.count(:conditions => ["LENGTH(comment) > 0 AND shelf_id = #{id}"])
  end

end
