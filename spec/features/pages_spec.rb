require 'rails_helper'

feature "Static Pages" do

  # Here's a placeholder feature spec to use as an example, uses the default driver.
  scenario "/ should include the application name in its title" do
    visit root_path

    expect(page).to have_title 'Water Systems of California'
  end
end
