# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/routing/user/confirmation_routing_spec.rb

RSpec.describe User::ConfirmationsController, "routing" do
  # new_user_confirmation GET      /auth/verification/new(.:format) user/confirmations#new
  #     user_confirmation GET      /auth/verification(.:format)     user/confirmations#show
  #                       POST     /auth/verification(.:format)     user/confirmations#create

  it "GET /auth/verification/new should be routable" do
    expect(get("/auth/verification/new").should be_routable)
  end

  it "GET /auth/verification/new should route to user/confirmations#new" do
    expect(get("/auth/verification/new").should route_to("user/confirmations#new"))
  end

  it "GET new_user_confirmation_path should route to user/confirmations#new" do
    expect(get(new_user_confirmation_path).should route_to("user/confirmations#new"))
  end

  it "GET /auth/verification/new should route to user/confirmations#new" do
    expect(get("/auth/verification/new").should route_to(controller: "user/confirmations", action: "new"))
  end

  it "GET /auth/verification should be routable" do
    expect(get("/auth/verification").should be_routable)
  end

  it "GET /auth/verification should route to user/confirmations#show" do
    expect(get("/auth/verification").should route_to("user/confirmations#show"))
  end

  it "GET user_confirmation_path should route to user/confirmations#show" do
    expect(get(user_confirmation_path).should route_to("user/confirmations#show"))
  end

  it "GET /auth/verification should route to user/confirmations#show" do
    expect(get("/auth/verification").should route_to(controller: "user/confirmations", action: "show"))
  end

  it "POST /auth/verification should be routable" do
    expect(post("/auth/verification").should be_routable)
  end

  it "POST /auth/verification should route to user/confirmations#create" do
    expect(post("/auth/verification").should route_to("user/confirmations#create"))
  end

  it "POST user_confirmation_path should route to user/confirmations#create" do
    expect(post(user_confirmation_path).should route_to("user/confirmations#create"))
  end

  it "POST /auth/verification should route to user/confirmations#create" do
    expect(post("/auth/verification").should route_to(controller: "user/confirmations", action: "create"))
  end
end
