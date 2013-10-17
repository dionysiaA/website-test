Given /^I am on the home page/ do
  visit('/')
  page.driver.browser.manage.window.maximize
end

##############################################################
# testing header
##############################################################

When /^I click on the website logo$/ do
  #find('[data-test="logo-link"]').click
  find('div#logo').first('a').click
end

Then /^I should return to the home page$/ do
  current_path.should == '/'
end

##############################################################
# testing main navigation
##############################################################

Then /^I should be on the (.*?) page$/ do |page_name|
  assert_page_path(page_name)
end

##############################################################
# testing footer links
##############################################################

Given /^the blinkbox books help link is present in the footer$/ do
  @help_link = find('[data-test="bottom-footer-container"]').find('[data-test="footer-help-link"]')
  @help_link.visible?.should == true
end

Then /^the link should point to the blinkbox books help home page$/ do
  @help_link[:href].should == 'https://blinkboxbooks.zendesk.com/'
  @help_link[:target].should == '_blank'
  @help_link[:title].should == 'Help'
end

Given /^the blinkbox movies link is present in the footer$/ do
  @movies_link = find('[data-test="bottom-footer-container"]').find('[data-test="footer-movies-link"]')
  @movies_link.visible?
end

Then /^the link should point to the blinkbox movies home page$/ do
  @movies_link[:href].should == 'http://www.blinkbox.com/'
  @movies_link[:target].should == '_blank'
  @movies_link[:title].should == 'blinkbox movies'
end

Given /^the blinkbox music link is present in the footer$/ do
  @music_link = find('[data-test="bottom-footer-container"]').find('[data-test="footer-music-link"]')
  @music_link.visible?
end

Then /^the link should point to the blinkbox music home page$/ do
  @music_link[:href].should == 'http://www.blinkboxmusic.com/'
  @music_link[:target].should == '_blank'
  @music_link[:title].should == 'blinkbox music'
end

And /^I click on the (.*) link$/ do |page_name|
  click_link_or_button(get_element_id_for(page_name))
end

When /^I click on the (.*) header tab$/ do |page_name|
  within('div#main-navigation') do
    click_link page_name
  end
end

And /^I press browser back$/ do
  page.evaluate_script('window.history.back()')
end

And /^main header tabs should not be selected$/ do
  within("#nav_menu") do
    page.all('li').to_a.each do |li|
      ((li[:class]).include?("current")).should == false
    end
  end

end

And /^footer is displayed$/ do
  find('[data-test="bottom-footer-container"]').visible?
end

When /^a promotable category has more books to display$/ do
  within("#books_news") do
    @visible_books = page.all('li', :visible => true).count
    @all_books = page.all('li', :visible => false).count
    #TODO: Given step should not assert
    @all_books.should > @visible_books
  end
end

And /^I click on View (.*) button$/ do |arg1|
  within("#books_news") do
    if (@all_books > @visible_books)
      find('[data-test="expand-list-button"]').click
    end
  end
end

Then /^I should see more books displayed$/ do
  within('#books_news') do
    (page.all('li', :visible => true).count).should > (@visible_books)
  end
end

And /^I click on view more button until all the books are displayed$/ do
  within('#books_news') do
    until  @all_books == page.all('li', :visible => true).count
      find('[data-test="expand-list-button"]').click
    end
  end
end

Then /^the button should change to View less$/ do
  within('#books_news') do
    ((find('[data-test="expand-list-button"]'))[:title]).should =="View less"
  end
end

Then /^the button should change to View more$/ do
  within('#books_news') do
    ((find('[data-test="expand-list-button"]'))[:title]).should =="View more"
  end
end

And /^(.*?) header is (.*?)$/ do |section_name, text|
  assert_container(get_element_id_for(section_name))
  assert_section_header(get_element_id_for(section_name), text)
end

And /^I should see 'Fiction' and 'Non\-Fiction' tabs$/ do
  within('[data-test="bestsellers-container"]') do
    page.find('[title="Fiction"]').visible?
    page.find('[title="Non-Fiction"]').visible?
  end
end

And /^Grid view and List view buttons displayed$/ do
  page.find('[title="Set view to list"]').visible?
  page.find('[title="Set view to grid"]').visible?

end

And /^I should see Promotions section header as (.*?)$/ do |promo_text|
  within('[data-id="399"]') do
    page.should have_content(promo_text)
  end
end

And /^I should see (\d+) books being displayed$/ do |books|
  within('[data-title="All time best selling books"]') do
    page.all('li').count.should == books.to_i
  end
end

And(/^I click on (Fiction|Non\-Fiction) tab$/) do |tab|
  case tab
    when 'Fiction'
    when 'Non-Fiction'
      find('[title="Non-Fiction"]').click
  end
end

Then /^I should see (Fiction|Non\-Fiction) books in (gird|list) view$/ do |book_type, view|
  case view
    when 'grid'
      (find('[data-test="grid-button"]')[:class]).should =='active'
      within('[data-test="bestsellers-container"]') do
        find('.selected').text.should == book_type
      end
    when 'list'
      (find('[data-test="list-button"]')[:class]).should == 'active'
      within('[data-test="bestsellers-container"]') do
        find('.selected').text.should == book_type
      end
  end
end

And /^I should see 'Top categories' and 'All categories' sections$/ do
  (find('[data-test="recommended-category-container"]').visible?).should == true
  (find('[data-test="all-categories-container"]').visible?).should == true
end

Given /^I am on crime and thriller category page$/ do
  visit('#!/category/crime-and-thriller/')
  current_path.should.eql?('#!/category/crime-and-thriller/') == true
  find('[data-test="category-title"]').text.eql?('All books in Crime and Thriller').should == true
  (find('[data-test="categoryid-109"]').visible?).should == true
  find('[data-test="list-button"]').click
end

When /^I select a book to view book details$/ do
  book = page.first('[class="book"]').find('[data-test="book-title-cover"]')
  @book_href = book[:href]
  book.click
end

Then /^details page of the corresponding book is displayed$/ do
  (current_url.include?(@book_href)).should == true
end

And /^details of above book are displayed$/ do
  assert_book_details
end

Given /^I am on Categories page$/ do
  within('div#main-navigation') do
    click_link 'Categories'
  end
  assert_page_path('Categories')
end


When /^I click on a category$/ do
  @category_name = click_on_a_category
end


Then /^corresponding category page is displayed$/ do
  page.current_url.should.eql?(@category_name)
end

Given /^I am on a book Category page$/ do
  click_link_or_button(get_element_id_for('Categories'))
  click_on_a_category
end

And /^the book reader is displayed$/ do
  assert_book_reader
end

And /^I am able to read the sample of corresponding book$/ do
  read_sample_book
end
