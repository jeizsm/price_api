defmodule PriceApi.PriceControllerTest do
  use PriceApi.ConnCase

  alias PriceApi.Price
  @valid_attrs %{price: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, price_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    price = Repo.insert! %Price{}
    conn = get conn, price_path(conn, :show, price)
    assert json_response(conn, 200)["data"] == %{"id" => price.id,
      "price" => price.price}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, price_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, price_path(conn, :create), price: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Price, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, price_path(conn, :create), price: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    price = Repo.insert! %Price{}
    conn = put conn, price_path(conn, :update, price), price: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Price, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    price = Repo.insert! %Price{}
    conn = put conn, price_path(conn, :update, price), price: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    price = Repo.insert! %Price{}
    conn = delete conn, price_path(conn, :delete, price)
    assert response(conn, 204)
    refute Repo.get(Price, price.id)
  end
end
