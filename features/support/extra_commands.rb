class Spinach::FeatureSteps
  
  def login(who)
    visit '/login'
    within('.login') do
      fill_in 'name', :with => who
      click_on 'Log in'
    end
  end
  
  def cookies
    current_scope.session.driver.request.session
  end
  
  def session(name)
    ::Capybara.session_name = name
  end
end

class Capybara::Session
  def has_card?(card)
    has_css?("img[alt=\"#{card.to_s}\"]")
  end
end

class GoFishApp
  def self.reset
    @@game_broker = ::GoFishGameBroker.new
  end
  
  def self.create_game(hands, deck)
    @@game_broker.create_game(hands, deck)
  end
end

class GoFishGameBroker
  def create_game(hands, deck)
    @open_game = GoFishGameStatus.new(2, hands, deck)
    @games[@open_game.object_id.to_s] = @open_game
  end
end