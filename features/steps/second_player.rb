class Spinach::Features::SecondPlayer < Spinach::FeatureSteps
  step 'one player is already connected' do
    session("first player")
    visit '/'
    login 'George'
  end

  step 'the second player connects' do
    session("second player")
    visit '/'
    login 'Bob'
  end

  step 'they should both be in the same game' do
    # @bob_game = GoFishApp.games[cookies['game_id']]
    
    # session("first player")
    # @george_game = GoFishApp.games[cookies['game_id']]
    
    # expect(@bob_game).to eq(@george_game)
    expect(GoFishApp.games.count).to eq(1)
  end

  step 'they should each have the proper hands' do
    session("first player")
    @game = GoFishApp.games.values.first
    within('.hand') do
      @game.hand(1).cards.each do |card|
        expect(page).to have_card(card)
      end
    end
    
    session("second player")
    within('.hand') do
      @game.hand(2).cards.each do |card|
        expect(page).to have_card(card)
      end
    end
  end
    
  step 'only player 1 should be able to ask for cards' do
    
    expect(page).not_to have_css('.turn')
    
    session("first player")
    
    expect(page).to have_css('.turn')
    
    within('.turn') do
      within('#opponent') do
        expect(page).to have_css('option[value="2"]')
        expect(page).not_to have_css('option[value="1"]')
        within('option') do
          expect(page).to have_content('Bob')
          expect(page).not_to have_content('George')
        end
      end
      
      within('#card') do
        @game.hand(1).cards.each do |card|
          expect(page).to have_css("option[value=\"#{card.rank}\"]")
        end
      end
    end
    
  end
  
end
