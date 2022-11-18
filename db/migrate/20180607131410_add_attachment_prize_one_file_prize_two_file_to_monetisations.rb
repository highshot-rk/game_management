class AddAttachmentPrizeOneFilePrizeTwoFileToMonetisations < ActiveRecord::Migration
  def self.up
    change_table :monetisations do |t|
      t.attachment :prize_one_file
      t.attachment :prize_two_file
    end
  end

  def self.down
    remove_attachment :monetisations, :prize_one_file
    remove_attachment :monetisations, :prize_two_file
  end
end
