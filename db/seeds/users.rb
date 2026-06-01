module Seeds
  module Users
    module_function

    def call
      admin_user = User.find_or_initialize_by(email: 'gabrielfca222@gmail.com')
      admin_user.password = 'londrina1993'
      admin_user.password_confirmation = 'londrina1993'
      admin_user.profile_type = 'admin'
      admin_user.save!

      admin_person = admin_user.people.first_or_initialize
      admin_person.assign_attributes(
        first_name: 'Gabriel',
        last_name: 'Admin',
        email: admin_user.email
      )
      admin_person.save!

      { admin_user: admin_user }
    end
  end
end
