class Spinach::Features::PlayerLogin < Spinach::FeatureSteps
  step 'a user visiting the site' do
    visit '/'
  end

  step 'being prompted to log in' do
    expect(current_path).to eq('/login')
    expect(page).to have_content('Log in')
  end

  step 'he inputs a valid username' do
    login 'George'
  end

  step 'he should be redirected to a new game' do
    expect(current_path).to eq("/")
    game = GoFishApp.games[cookies['game_id']]
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
    login '   '
  end

  step 'he should be prompted to pick a different name' do
    expect(current_path).to eq('/login')
    expect(page).to have_content('Please choose a valid username')
  end
end
