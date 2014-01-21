class Spinach::Features::MultipleGames < Spinach::FeatureSteps
  step 'two players connected in the first game' do
    session(1)
    login('Bob')
    session(2)
    login('George')
  end

  step 'two other players connect' do
    session(3)
    login('Jim')
    session(4)
    login('Tom')
  end

  step 'the first two players should be in one game' do
    session(1)
    bob_game_id = current_path.match(/\/games\/(\d+)/)[1]
    session(2)
    george_game_id = current_path.match(/\/games\/(\d+)/)[1]
    expect(bob_game_id).to eq(george_game_id)
    @first_game_id = bob_game_id
  end

  step 'the second two players should be in a different game' do
    session(3)
    jim_game_id = current_path.match(/\/games\/(\d+)/)[1]
    session(4)
    tom_game_id = current_path.match(/\/games\/(\d+)/)[1]
    
    expect(jim_game_id).to eq(tom_game_id)
    expect(jim_game_id).not_to eq(@first_game_id)
  end
end
