# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    if !Movie.find_by(:title => movie[:title], :rating=> movie[:rating], :release_date => movie[:release_date])
        Movie.create!(:title => movie[:title], :rating=> movie[:rating], :release_date => movie[:release_date])
    end
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  
  rating_list = arg1.split(', ')
  all_ratings = Movie.all_ratings
  all_ratings.each do |rating|
    if rating_list.index(rating)
        check("ratings[#{rating}]")
    else
        uncheck("ratings[#{rating}]")
    end
  end
  click_button('Refresh')
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    rating_list = arg1.split(', ')
    foundInvalidMovie=false
    all("tr").each do |tr|
        foundRightRating = false
        rating_list.each do |currRating|
            if tr.has_content?(currRating)
                foundRightRating = true
                break
            end
        end
        if !foundRightRating
           foundInvalidMovie = true
           break
        end
    end  
  expect(!foundInvalidMovie).to be_truthy
end

Then /^I should see all of the movies$/ do
  #first check to make sure we have the same number of table rows as we do movies
  sameNumber = false
  if all("tr").size == Movie.all.size+1
      sameNumber = true
  end
  
  #now check to make sure that we have the same movies as the table
  missingMovie = false
  Movie.all.each do |movie|
     foundMovie = false
     all("tr").each do |tr|
         if tr.has_content?(movie.title) && tr.has_content?(movie.rating) && tr.has_content?(movie.release_date)
            foundMovie = true 
            break
         end
     end
     if !foundMovie
         missingMovie = true
         break
     end
  end
  
  expect(sameNumber).to be_truthy
      
end



