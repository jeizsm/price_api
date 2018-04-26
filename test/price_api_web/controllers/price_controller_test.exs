defmodule PriceApiWeb.PriceControllerTest do
  use PriceApiWeb.ConnCase

  alias PriceApi.Prices
  alias PriceApi.Prices.Price

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:price) do
    {:ok, price} = Prices.create_price(@create_attrs)
    price
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all prices", %{conn: conn} do
      conn = get conn, Routes.price_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create price" do
    test "renders price when data is valid", %{conn: conn} do
      conn = post conn, Routes.price_path(conn, :create), price: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, Routes.price_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.price_path(conn, :create), price: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update price" do
    setup [:create_price]

    test "renders price when data is valid", %{conn: conn, price: %Price{id: id} = price} do
      conn = put conn, Routes.price_path(conn, :update, price), price: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, Routes.price_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, price: price} do
      conn = put conn, Routes.price_path(conn, :update, price), price: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete price" do
    setup [:create_price]

    test "deletes chosen price", %{conn: conn, price: price} do
      conn = delete conn, Routes.price_path(conn, :delete, price)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, Routes.price_path(conn, :show, price)
      end
    end
  end

  defp create_price(_) do
    price = fixture(:price)
    {:ok, price: price}
  end
end
