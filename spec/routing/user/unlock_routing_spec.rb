# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/routing/user/unlock_routing_spec.rb

RSpec.describe User::UnlocksController, "routing" do
  # new_user_unlock GET       /auth/unlock/new(.:format) user/unlocks#new
  #     user_unlock GET       /auth/unlock(.:format)     user/unlocks#show
  #                 POST      /auth/unlock(.:format)     user/unlocks#create

  it "GET /auth/unlock/new should be routable" do
    expect(get("/auth/unlock/new").should be_routable)
  end

  it "GET /auth/unlock/new should route to user/unlocks#new" do
    expect(get("/auth/unlock/new").should route_to("user/unlocks#new"))
  end

  it "GET new_user_unlock_path should route to user/unlocks#new" do
    expect(get(new_user_unlock_path).should route_to("user/unlocks#new"))
  end

  it "GET /auth/unlock/new should route to user/unlocks#new" do
    expect(get("/auth/unlock/new").should route_to(controller: "user/unlocks", action: "new"))
  end

  it "GET /auth/unlock should be routable" do
    expect(get("/auth/unlock").should be_routable)
  end

  it "GET /auth/unlock should route to user/unlocks#show" do
    expect(get("/auth/unlock").should route_to("user/unlocks#show"))
  end

  it "GET user_unlock_path should route to user/unlocks#show" do
    expect(get(user_unlock_path).should route_to("user/unlocks#show"))
  end

  it "GET /auth/unlock should route to user/unlocks#show" do
    expect(get("/auth/unlock").should route_to(controller: "user/unlocks", action: "show"))
  end

  it "POST /auth/unlock should be routable" do
    expect(post("/auth/unlock").should be_routable)
  end

  it "POST /auth/unlock should route to user/unlocks#create" do
    expect(post("/auth/unlock").should route_to("user/unlocks#create"))
  end

  it "POST user_unlock_path should route to user/unlocks#create" do
    expect(post(user_unlock_path).should route_to("user/unlocks#create"))
  end

  it "POST /auth/unlock should route to user/unlocks#create" do
    expect(post("/auth/unlock").should route_to(controller: "user/unlocks", action: "create"))
  end
end
