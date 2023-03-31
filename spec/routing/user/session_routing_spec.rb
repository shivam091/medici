# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/routing/user/session_routing_spec.rb

RSpec.describe User::SessionsController, type: :routing do
  #     new_user_session   GET      /auth/sign-in(.:format)  user/sessions#new
  #         user_session   POST     /auth/sign-in(.:format)  user/sessions#create
  # destroy_user_session   DELETE   /auth/sign-out(.:format) user/sessions#destroy

  it "GET /auth/sign-in should be routable" do
    expect(get("/auth/sign-in")).to be_routable
  end

  it "GET /auth/sign-in should route to user/sessions#new" do
    expect(get("/auth/sign-in")).to route_to("user/sessions#new")
  end

  it "GET new_user_session_path should route to user/sessions#new" do
    expect(get(new_user_session_path)).to route_to("user/sessions#new")
  end

  it "GET /auth/sign-in should route to user/sessions#new" do
    expect(get("/auth/sign-in")).to route_to(controller: "user/sessions", action: "new")
  end

  it "POST /auth/sign-in should be routable" do
    expect(post("/auth/sign-in")).to be_routable
  end

  it "POST /auth/sign-in should route to user/sessions#create" do
    expect(post("/auth/sign-in")).to route_to("user/sessions#create")
  end

  it "POST /auth/sign-in should route to user/sessions#create" do
    expect(post("/auth/sign-in")).to route_to(controller: "user/sessions", action: "create")
  end

  it "POST user_session_path should route to user/sessions#create" do
    expect(post(user_session_path)).to route_to("user/sessions#create")
  end

  it "DELETE /auth/sign-out should be routable" do
    expect(delete("/auth/sign-out")).to be_routable
  end

  it "DELETE /auth/sign-out should route to user/sessions#destroy" do
    expect(delete("/auth/sign-out")).to route_to(controller: "user/sessions", action: "destroy")
  end

  it "DELETE /auth/sign-out should route to user/sessions#destroy" do
    expect(delete("/auth/sign-out")).to route_to("user/sessions#destroy")
  end

  it "DELETE destroy_user_session_path should route to user/sessions#destroy" do
    expect(delete(destroy_user_session_path)).to route_to("user/sessions#destroy")
  end
end
