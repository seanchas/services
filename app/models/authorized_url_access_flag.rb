class AuthorizedUrlAccessFlag < PassportModel

  belongs_to :user
  belongs_to :authorized_url

end