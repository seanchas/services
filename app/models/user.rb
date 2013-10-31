class User < PassportModel

  passport

  has_and_belongs_to_many :roles, :join_table => "services.roles_users"

  def admin?
    roles.collect(&:name).include?("admin")
  end

  has_many :user_infosell_requisites, :order => :updated_at

  has_many :access_flags, :class_name => AuthorizedUrlAccessFlag.to_s

  def self.find_by_infosell_requisite(requisite)
    UserInfosellRequisite.find_by_infosell_code(requisite).try(:user) or raise ActiveRecord::RecordNotFound
  end

  def current_user_infosell_requisite
    @current_infosell_requisite ||= user_infosell_requisites.last
  end

  def infosell_requisites
    @infosell_requisites ||= user_infosell_requisites.empty? ? [] : Infosell::Requisite.find(*user_infosell_requisites.collect(&:infosell_code))
  end

  def infosell_requisite
    infosell_requisites.detect { |requisite| requisite.code == current_user_infosell_requisite.infosell_code } || infosell_requisites.first unless infosell_requisites.empty? rescue nil
  end

  def infosell_orders
    @infosell_orders ||= Infosell::Order.all(infosell_requisite) rescue []
  end

  def full_name
    @full_name ||= [last_name, first_name, middle_name].compact.join(" ")
  end

  def screen_name
    @screen_name ||= full_name.blank? ? nickname : full_name
  end

  def update_access_flags(resource_list = [], name = "infosell")
    resource_hash = resource_list.inject({}) do |memo, item|
      resource_id = item.is_a?(Hash) ? item['resid'] : item.to_s
      memo[resource_id] ||= []
      memo[resource_id].push({:from => begin
        DateTime.parse(item['from']) rescue nil
      end, :till => begin
        DateTime.parse(item['till']) rescue nil
      end})
      memo
    end

    resources_ids = resource_hash.keys
    resources = Infosell::Resource.all.select { |r| resources_ids.include? r.code }

    access_flags_to_keep, access_flags_to_destroy = access_flags.partition { |f| f.author == 'admin' }

    access_flags_to_keep = access_flags_to_keep.inject({}) do |memo, item|
      memo[item.authorized_url_id] ||= []
      memo[item.authorized_url_id].push({:from => item.from, :till => item.till})
      memo
    end

    AuthorizedUrlAccessFlag.transaction do

      access_flags_to_destroy.each(&:destroy)

      resources.each do |resource|
        authorized_urls = AuthorizedUrl.find_by_infosell_resources(resource.code)

        authorized_urls.each do |authorized_url|

          admin_dates = access_flags_to_keep[authorized_url.id]

          resource_hash[resource.code].each do |dates|
            unless (admin_dates || []).any? { |d| d[:from] == dates[:from] && d[:till] == dates[:till] }
              access_flags.create :authorized_url_id => authorized_url.id, :author => name, :from => dates[:from], :till => dates[:till]
            end
          end

        end
      end

    end

    Passport::CertificateAuth.reset_permissions(to_param)

    true
  end

end
