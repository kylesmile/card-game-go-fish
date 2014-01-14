class Spinach::Features::UnableToLogInTwice < Spinach::FeatureSteps
  step 'a player is already logged in' do
    visit '/login'
    fill_in 'name', :with => 'Bob'
  end

  step 'the player tries to visit the log in page' do
    visit '/login'
  end

  step 'he is redirected to another page' do
    expect(current_path).not_to eq('/login')
  end
end
