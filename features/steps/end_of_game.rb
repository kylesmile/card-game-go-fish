class Spinach::Features::EndOfGame < Spinach::FeatureSteps
  step 'the game is one move away from the end' do
    hand1 = GoFishHand.new([PlayingCard.new('A','D'), PlayingCard.new('A','H'), PlayingCard.new('A','C')])
    hand2 = GoFishHand.new([PlayingCard.new('A','S')])
    deck = CardDeck.new([])
    GoFishApp.create_game([hand1, hand2], deck)
  end
  
  step 'two players are connected' do
    session('player 1')
    visit '/'
    login('Bob')
    session('player 2')
    visit '/'
    login('George')
  end

  step 'a player makes the last move' do
    session('player 1')
    within('.turn') do
      click_on('Ask')
    end
  end

  step 'all players should be redirected to an end game screen' do
    expect(current_path).to eq('/end')
    
    session('player 2')
    visit(current_path) #CHEATER!
    expect(current_path).to eq('/end')
  end

  step 'the winner should be announced' do
    expect(page).to have_content('Bob wins!')
    session('player 1')
    expect(page).to have_content('You win!')
  end
end
