require "rails_helper"

# Acceptance Criteria
# [ ] On a TV shows show page, when I click on Review for a show I reviewed, it
      # brings me to a page with the review form pre-filled
# [ ] I can make changes to the review form fields
# [ ] When I click Save, I am redirected to the show page and the review is
      # updated with the changes made
# [ ] The edited reviews displays an updated time stamp and edited indicator

feature "authenticated user can make edits to posted reviews" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_as(@user, scope: :user)

    @game_of_thrones = Show.create(
      title: "Game of Thrones",
      description: "awesome HBO show", average_rating: 5
    )
    @review_for_thrones = Review.create(
    title: "The deaths hit you right in the feels",
    description: "Hodor", rating: 5, show: @game_of_thrones, user: @user
    )
  end

  scenario "authenticated user visits review edit page" do

    visit show_path(@game_of_thrones)

    click_link "edit"

    expect(current_path).to eq edit_show_review_path(@game_of_thrones,
                                                     @review_for_thrones)
    expect(find_field('Title').value).to eq @review_for_thrones.title

    expect(page).to have_content(@review_for_thrones.description)

  end

  scenario "user edits review and saves changes" do
    visit edit_show_review_path(@game_of_thrones, @review_for_thrones)

    fill_in('Title', with: 'Linter is Coming')
    fill_in('Review', with: 'sweet HBO show')
    select(3, from: 'Rating')

    click_button 'Update Review'

    expect(current_path).to eq show_path(@game_of_thrones)
    expect(page).to have_content("Linter is Coming")
    expect(page).to have_content("sweet HBO show")
    expect(page).to have_content(3)
    expect(page).to have_content "Edited @ #{@review_for_thrones.updated_at.
      strftime("%B %d %Y")}"
  end

  scenario "unauthenticated user cannot visit review edit page" do
    logout(:user)

    visit show_path(@game_of_thrones)

    expect(page).to_not have_link("edit")
  end

  scenario "user cannot visit review edit page for someone else's review" do
    user2 = FactoryGirl.create(:user)
    login_as(user2, scope: :user)

    visit show_path(@game_of_thrones)

    expect(page).to_not have_link("edit")
  end
end
