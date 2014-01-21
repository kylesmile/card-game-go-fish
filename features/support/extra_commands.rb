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