# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/routing/user/password_routing_spec.rb

RSpec.describe User::PasswordsController, type: :routing do
  #  new_user_password GET      /auth/password/new(.:format)  user/passwords#new
  # edit_user_password GET      /auth/password/edit(.:format) user/passwords#edit
  #      user_password PATCH    /auth/password(.:format)      user/passwords#update
  #                    PUT      /auth/password(.:format)      user/passwords#update
  #                    POST     /auth/password(.:format)      user/passwords#create

  it "GET /auth/password/new should be routable" do
    expect(get("/auth/password/new")).to be_routable
  end

  it "GET /auth/password/new should route to user/passwords#new" do
    expect(get("/auth/password/new")).to route_to("user/passwords#new")
  end

  it "GET new_user_password_path should route to user/passwords#new" do
    expect(get(new_user_password_path)).to route_to("user/passwords#new")
  end

  it "GET /auth/password/new should route to user/passwords#new" do
    expect(get("/auth/password/new")).to route_to(controller: "user/passwords", action: "new")
  end

  it "GET /auth/password/edit should be routable" do
    expect(get("/auth/password/edit")).to be_routable
  end

  it "GET /auth/password/edit should route to user/passwords#edit" do
    expect(get("/auth/password/edit")).to route_to("user/passwords#edit")
  end

  it "GET edit_user_password_path should route to user/passwords#edit" do
    expect(get(edit_user_password_path)).to route_to("user/passwords#edit")
  end

  it "GET /auth/password/edit should route to user/passwords#edit" do
    expect(get("/auth/password/edit")).to route_to(controller: "user/passwords", action: "edit")
  end

  it "POST /auth/password should be routable" do
    expect(post("/auth/password")).to be_routable
  end

  it "POST /auth/password should route to user/passwords#create" do
    expect(post("/auth/password")).to route_to("user/passwords#create")
  end

  it "POST user_password_path should route to user/passwords#create" do
    expect(post(user_password_path)).to route_to("user/passwords#create")
  end

  it "POST /auth/password should route to user/passwords#create" do
    expect(post("/auth/password")).to route_to(controller: "user/passwords", action: "create")
  end

  it "PUT /auth/password should be routable" do
    expect(put("/auth/password")).to be_routable
  end

  it "PUT /auth/password should route to user/passwords#update" do
    expect(put("/auth/password")).to route_to("user/passwords#update")
  end

  it "PUT user_password_path should route to user/passwords#update" do
    expect(put(user_password_path)).to route_to("user/passwords#update")
  end

  it "PUT /auth/password should route to user/passwords#update" do
    expect(put("/auth/password")).to route_to(controller: "user/passwords", action: "update")
  end

  it "PATCH /auth/password should be routable" do
    expect(patch("/auth/password")).to be_routable
  end

  it "PATCH /auth/password should route to user/passwords#update" do
    expect(patch("/auth/password")).to route_to("user/passwords#update")
  end

  it "PATCH user_password_path should route to user/passwords#update" do
    expect(patch(user_password_path)).to route_to("user/passwords#update")
  end

  it "PATCH /auth/password should route to user/passwords#update" do
    expect(patch("/auth/password")).to route_to(controller: "user/passwords", action: "update")
  end
end
