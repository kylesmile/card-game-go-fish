class Spinach::Features::PlayerLogin < Spinach::FeatureSteps
  before do
    visit '/'
  end
  
  step 'a user visits the site for the first time' do
  end

  step 'he is prompted to log in' do
    expect(current_path).to eq '/login'
  end

  step 'a user wishing to log in' do
  end

  step 'he inputs an invalid username' do
    within('.login') do
      fill_in 'name', :with => '   '
      click_on 'Log in'
    end
  end

  step 'he should be prompted to pick a different name' do
    expect(current_path).to eq '/login'
    expect(page).to have_content('Please choose a valid username')
  end

  step 'he inputs a valid username' do
    within('.login') do
      fill_in 'name', :with => 'Bob'
      click_on 'Log in'
    end
  end

  step 'he should be directed to join or create a game' do
    expect(current_path).to eq '/games'
    expect(page).to have_content('Hi, Bob')
    expect(page).to have_content('Join or create a game')
  end
end
