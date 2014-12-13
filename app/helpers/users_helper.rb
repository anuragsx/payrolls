module UsersHelper
  def place_user_action(user)
    if user
      return t('users.deactivate') if user.activate?
      t('users.activate')
    else
      "Site Admin"
    end
  end
end
