class Spinach::Features::SeveralLogins < Spinach::FeatureSteps
  step 'one player logged in as Bob' do
    visit '/login'
    fill_in 'name', :with => 'Bob'
    click_on 'Log in'
  end

  step 'a second player attempts to log in as Bob' do
    ::Capybara.session_name = "session 2"
    visit '/login'
    fill_in 'name', :with => 'Bob'
    click_on 'Log in'
  end

  step 'the second player should have to pick a different name' do
    expect(current_path).to eq('/login')
    expect(page).to have_content('That username is in use')
  end

  step 'a second player logs in with a different name' do
    ::Capybara.session_name = "session 2"
    visit '/login'
    fill_in 'name', :with => "George"
    click_on 'Log in'
  end

  step 'the second player should be logged in' do
    expect(current_path).to eq('/games')
    expect(page).to have_content('Join or create a game')
  end
end
