# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/routing/user/registration_routing_spec.rb

RSpec.describe User::RegistrationsController, "routing" do
  # cancel_user_registration GET      /auth/cancel(.:format)  user/registrations#cancel
  #    new_user_registration GET      /auth/sign-up(.:format) user/registrations#new
  #   edit_user_registration GET      /auth/edit(.:format)    user/registrations#edit
  #        user_registration PATCH    /auth(.:format)         user/registrations#update
  #                          PUT      /auth(.:format)         user/registrations#update
  #                          DELETE   /auth(.:format)         user/registrations#destroy
  #                          POST     /auth(.:format)         user/registrations#create

  it "GET /auth/cancel should be routable" do
    expect(get("/auth/cancel")).to be_routable
  end

  it "GET /auth/cancel should route to user/registrations#cancel" do
    expect(get("/auth/cancel")).to route_to("user/registrations#cancel")
  end

  it "GET cancel_user_registration_path should route to user/registrations#cancel" do
    expect(get(cancel_user_registration_path)).to route_to("user/registrations#cancel")
  end

  it "GET /auth/cancel should route to user/registrations#cancel" do
    expect(get("/auth/cancel")).to route_to(controller: "user/registrations", action: "cancel")
  end

  it "GET /auth/sign-up should be routable" do
    expect(get("/auth/sign-up")).to be_routable
  end

  it "GET /auth/sign-up should route to user/registrations#new" do
    expect(get("/auth/sign-up")).to route_to("user/registrations#new")
  end

  it "GET new_user_registration_path should route to user/registrations#new" do
    expect(get(new_user_registration_path)).to route_to("user/registrations#new")
  end

  it "GET /auth/sign-up should route to user/registrations#new" do
    expect(get("/auth/sign-up")).to route_to(controller: "user/registrations", action: "new")
  end

  it "GET /auth/edit should be routable" do
    expect(get("/auth/edit")).to be_routable
  end

  it "GET /auth/edit should route to user/registrations#edit" do
    expect(get("/auth/edit")).to route_to("user/registrations#edit")
  end

  it "GET edit_user_registration_path should route to user/registrations#edit" do
    expect(get(edit_user_registration_path)).to route_to("user/registrations#edit")
  end

  it "GET /auth/edit should route to user/registrations#edit" do
    expect(get("/auth/edit")).to route_to(controller: "user/registrations", action: "edit")
  end

  it "PATCH /auth should be routable" do
    expect(patch("/auth")).to be_routable
  end

  it "PATCH /auth should route to user/registrations#update" do
    expect(patch("/auth")).to route_to("user/registrations#update")
  end

  it "PATCH user_registration_path should route to user/registrations#update" do
    expect(patch(user_registration_path)).to route_to("user/registrations#update")
  end

  it "PATCH /auth should route to user/registrations#update" do
    expect(patch("/auth")).to route_to(controller: "user/registrations", action: "update")
  end

  it "PUT /auth should be routable" do
    expect(put("/auth")).to be_routable
  end

  it "PUT /auth should route to user/registrations#update" do
    expect(put("/auth")).to route_to("user/registrations#update")
  end

  it "PUT user_registration_path should route to user/registrations#update" do
    expect(put(user_registration_path)).to route_to("user/registrations#update")
  end

  it "PUT /auth should route to user/registrations#update" do
    expect(put("/auth")).to route_to(controller: "user/registrations", action: "update")
  end

  it "DELETE /auth should be routable" do
    expect(delete("/auth")).to be_routable
  end

  it "DELETE /auth should route to user/registrations#destroy" do
    expect(delete("/auth")).to route_to("user/registrations#destroy")
  end

  it "DELETE user_registration_path should route to user/registrations#destroy" do
    expect(delete(user_registration_path)).to route_to("user/registrations#destroy")
  end

  it "DELETE /auth should route to user/registrations#destroy" do
    expect(delete("/auth")).to route_to(controller: "user/registrations", action: "destroy")
  end

  it "POST /auth should be routable" do
    expect(post("/auth")).to be_routable
  end

  it "POST /auth should route to user/registrations#create" do
    expect(post("/auth")).to route_to("user/registrations#create")
  end

  it "POST user_registration_path should route to user/registrations#create" do
    expect(post(user_registration_path)).to route_to("user/registrations#create")
  end

  it "POST /auth should route to user/registrations#create" do
    expect(post("/auth")).to route_to(controller: "user/registrations", action: "create")
  end
end
