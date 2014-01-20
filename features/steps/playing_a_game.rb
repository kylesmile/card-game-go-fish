class Spinach::Features::PlayingAGame < Spinach::FeatureSteps
  step 'two players connected' do
    session('player 1')
    visit '/'
    login 'Bob'
    session('player 2')
    visit '/'
    login 'George'
  end

  step 'one asks for cards' do
    session('player 1')
    within('.turn') do
      click_on('Ask')
    end
  end

  step 'both should see the results' do
    within('.last-turn-results') do
      expect(page).to have_content('Bob asked George for')
    end
    session('player 2')
    binding.pry
    within('.last-turn-results') do
      expect(page).to have_content('Bob asked George for')
    end
  end

  step 'both should see whose turn it is' do
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
