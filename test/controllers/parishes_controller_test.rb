require 'test_helper'

class ParishesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parish = parishes(:one)
  end

  test "should get index" do
    get parishes_url
    assert_response :success
  end

  test "should get new" do
    get new_parish_url
    assert_response :success
  end

  test "should create parish" do
    assert_difference('Parish.count') do
      post parishes_url, params: { parish: { address: @parish.address, city: @parish.city, contact: @parish.contact, deanery: @parish.deanery, email: @parish.email, fax: @parish.fax, name: @parish.name, phone: @parish.phone, state: @parish.state, website: @parish.website, zip: @parish.zip } }
    end

    assert_redirected_to parish_url(Parish.last)
  end

  test "should show parish" do
    get parish_url(@parish)
    assert_response :success
  end

  test "should get edit" do
    get edit_parish_url(@parish)
    assert_response :success
  end

  test "should update parish" do
    patch parish_url(@parish), params: { parish: { address: @parish.address, city: @parish.city, contact: @parish.contact, deanery: @parish.deanery, email: @parish.email, fax: @parish.fax, name: @parish.name, phone: @parish.phone, state: @parish.state, website: @parish.website, zip: @parish.zip } }
    assert_redirected_to parish_url(@parish)
  end

  test "should destroy parish" do
    assert_difference('Parish.count', -1) do
      delete parish_url(@parish)
    end

    assert_redirected_to parishes_url
  end
end
