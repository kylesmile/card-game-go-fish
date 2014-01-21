class Spinach::Features::PlayingAGame < Spinach::FeatureSteps
  step 'two players connected' do
    session('player 1')
    login 'Bob'
    session('player 2')
    login 'George'
  end

  step 'one asks for cards' do
    session('player 1')
    within('.turn') do
      click_on('Ask')
    end
  end
  
  step 'both should see the results' do
    session('player 1')
    within('.last-turn-results') do
      expect(page).to have_content('Bob asked George for')
    end
    session('player 2')
    visit(current_path) #CHEATER!
    within('.last-turn-results') do
      expect(page).to have_content('Bob asked George for')
    end
  end
  
  step 'both should see whose turn it is' do
    session('player 2')
    within('.last-turn-results') do
      expect(page).to have_content("It's ")
      expect(page).to have_content(" turn")
    end
    session('player 1')
    within('.last-turn-results') do
      expect(page).to have_content("It's ")
      expect(page).to have_content(" turn")
    end
  end

end
