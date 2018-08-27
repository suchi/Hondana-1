class Shelf < ApplicationRecord
  has_many :entries
  has_many :books, through: :entries
  
  # validates_uniqueness_of :name 使い方がわからないので保留

#  def validate
#    errors.add_to_base "何か様子が変です"
#  end

  def countbook
    Entry.where(:shelf_id => id).size
  end

  def countbook_comment
    Entry.where(shelf_id:  id).find_all { |entry|
      entry.comment.to_s.length > 0
    }.length
  end

end
