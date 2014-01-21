class Spinach::Features::PlayerLogin < Spinach::FeatureSteps
  step 'a user visiting the site' do
    visit '/'
  end

  step 'being prompted to log in' do
    expect(current_path).to eq('/login')
    expect(page).to have_content('Log in')
  end

  step 'he inputs a valid username' do
    within('.login') do
      fill_in 'name', :with => 'George'
      click_on 'Log in'
    end
  end

  step 'he should be redirected to a new game' do
    match = current_path.match(/\/games\/(\d+)/)
    expect(match).not_to be_nil
    game = GoFishApp.games[match[1]]
    within('.hand') do
      game.hand(1).cards.each do |card|
        expect(page).to have_card(card)
      end
    end
  end

  step 'have a cookie set with his username' do
    expect(cookies['user_name']).to eq('George')
  end

  step 'he inputs an invalid username' do
    within('.login') do
      fill_in 'name',  :with => '   '
      click_on 'Log in'
    end
  end

  step 'he should be prompted to pick a different name' do
    expect(current_path).to eq('/login')
    expect(page).to have_content('Please choose a valid username')
  end
end
