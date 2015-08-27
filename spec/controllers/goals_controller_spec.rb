require 'rails_helper'

describe GoalsController do

  describe "GET #home" do
    it "return a goal"
  end

  describe "GET #index" do
    it "return an ordered list of goals" do
      first_goal = create(:goal, title: "Vacation to Taiwan")
      second_goal = create(:goal, title: "Vacation to Thailand!")
      get :index
      expect(assigns(:goals)).to match_array([first_goal, second_goal])
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested goal to @goal" do
      goal = create(:goal)
      get :show, id: goal
      expect(assigns(:goal)).to eq goal
    end

    it "renders the :show template" do
      goal = create(:goal)
      get :show, id: goal
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    it "assigns a new Goal to @goal"
    it "renders the :new template"
  end

  describe "GET #edit" do
    it "assigns the requested goal to @goal"
    it "renders the :edit template"
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new goal in the database"
      it "redirects to the :index view"
    end

    context "with invalid attributes" do
      it "does not save the new goal in the database"
      it "re-renders the :new template"
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "saves the @goal to database"
      it "redirects to the :show page"
    end

    context "with invalid attributes" do
      it "does not save to database"
      it "re-renders the :edit template"
    end
  end

  describe "POST #destroy" do
    it "destroy the @goal from the database"
    it "redirects to the :index page"
  end

end
