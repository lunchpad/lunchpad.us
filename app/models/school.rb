class School < ActiveRecord::Base
  resourcify
  has_many :vendors
  has_many :off_days
  has_many :accounts
  has_many :orders, through: :accounts
  has_many :ordered_items, through: :orders
  has_many :menu_items
  has_many :available_menu_items


  validates :name, presence: true
  validates :phone, presence: true
  validates :address, presence: true

  has_attached_file :logo,
                    :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png",
                    :storage => :s3,
                    :bucket  => ENV['MY_BUCKET_NAME']
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  def report_for(date)
    items = self.ordered_items.ordered_between(date.beginning_of_day,
                                               date.end_of_day)
    sorted = items.sort_by { |item| [item.section,
                                     item.account.name,
                                     item.vendor,
                                     item.menu_item] }
  end

  def has_off_day(date)
    full_day = date.beginning_of_day..date.end_of_day
    off_day = self.off_days.where(date: full_day)
    off_day.empty? ? false : off_day
  end

end
