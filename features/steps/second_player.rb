class Spinach::Features::SecondPlayer < Spinach::FeatureSteps
  before do
    GoFishApp.reset
  end
  
  step 'one player is already connected' do
    visit '/'
    login 'George'
  end

  step 'the second player connects' do
    ::Capybara.session_name = "second player"
    visit '/'
    login 'Bob'
  end

  step 'they should both be in the same game' do
    @bob_game = GoFishApp.games[cookies['game_id']]
    
    ::Capybara.session_name = :default
    @george_game = GoFishApp.games[cookies['game_id']]
    
    expect(@bob_game).to eq(@george_game)
  end

  step 'they should each have the proper hands and things' do
    visit(current_path)
    
    game = @bob_game
    within('.hand') do
      game.hand(1).cards.each do |card|
        expect(page).to have_card(card)
      end
    end
    
    within('.turn') do
      within('#opponent') do
        expect(page).to have_css('option[value="2"]')
        expect(page).not_to have_css('option[value="1"]')
        expect(page).to have_content('Bob')
        expect(page).not_to have_content('George')
      end
      
      within('#card') do
        game.hand(1).cards.each do |card|
          expect(page).to have_css("option[value=\"#{card.rank}\"]")
        end
      end
      
    end
    
    ::Capybara.session_name = "second player"
    
    within('.hand') do
      game.hand(2).cards.each do |card|
        expect(page).to have_card(card)
      end
    end
    
    within('.turn') do
      within('#opponent') do
        expect(page).to have_css('option[value="1"]')
        expect(page).not_to have_css('option[value="2"]')
        expect(page).to have_content('George')
        expect(page).not_to have_content('Bob')
      end
      
      within('#card') do
        game.hand(2).cards.each do |card|
          expect(page).to have_css("option[value=\"#{card.rank}\"]")
        end
      end
      
    end
    
  end
  
end
