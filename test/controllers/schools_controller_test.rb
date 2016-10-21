require 'test_helper'

class SchoolsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @school = schools(:one)
  end

  test "should get index" do
    get schools_url
    assert_response :success
  end

  test "should get new" do
    get new_school_url
    assert_response :success
  end

  test "should create school" do
    assert_difference('School.count') do
      post schools_url, params: { school: { address: @school.address, city: @school.city, email: @school.email, fax: @school.fax, name: @school.name, parish_id: @school.parish_id, phone: @school.phone, state: @school.state, website: @school.website, zip: @school.zip } }
    end

    assert_redirected_to school_url(School.last)
  end

  test "should show school" do
    get school_url(@school)
    assert_response :success
  end

  test "should get edit" do
    get edit_school_url(@school)
    assert_response :success
  end

  test "should update school" do
    patch school_url(@school), params: { school: { address: @school.address, city: @school.city, email: @school.email, fax: @school.fax, name: @school.name, parish_id: @school.parish_id, phone: @school.phone, state: @school.state, website: @school.website, zip: @school.zip } }
    assert_redirected_to school_url(@school)
  end

  test "should destroy school" do
    assert_difference('School.count', -1) do
      delete school_url(@school)
    end

    assert_redirected_to schools_url
  end
end
