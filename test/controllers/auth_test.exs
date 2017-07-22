defmodule Rumbl.AuthTest do
    use Rumbl.ConnCase
    alias Rumbl.Auth

    setup %{conn: conn} do
        conn =
            conn
            |> bypass_through(Rumbl.Router, :browser)
            |> get("/")
        {:ok, %{conn: conn}}
    end

    test "authenticate_user halts when no current_user exists", %{conn: conn} do
        conn = Auth.authenticate_user(conn, [])
        assert conn.halted
    end

    test "authenticate_user continues when the current_user exists", %{conn: conn} do
        conn =
            conn
            |> assign(:current_user, %Rumbl.User{})
            |> Auth.authenticate_user([])

        refute conn.halted
    end

    test "login puts the user in the session", %{conn: conn} do
        # create a new connection by logging in a fake user to the current connection
        # and call send_resp which sends the response to the client with a given status and resp body
        login_conn =
            conn
            |> Auth.login(%Rumbl.User{id: 123})
            |> send_resp(:ok, "")

        # make sure that the new user survives the next request by making a new request
        # with the login_conn and ensure that the user is still in the session
        next_conn = get(login_conn, "/")
        assert get_session(next_conn, :user_id) == 123
    end

    test "logout drops the session", %{conn: conn} do
        # create a new connection by putting fake user id into current session
        # and call logout
        logout_conn =
            conn
            |> put_session(:user_id, 123)
            |> Auth.logout()
            |> send_resp(:ok, "")

        # make sure that the logout persisted through the request, we make a request
        # with get and make sure that no user_id is in the session
        next_conn = get(logout_conn, "/")
        refute get_session(next_conn, :user_id)
    end

    test "call places user from session into assigns", %{conn: conn} do
        user = insert_user()
        conn =
            conn
            |> put_session(:user_id, user.id)
            |> Auth.call(Repo)

        assert conn.assigns.current_user.id == user.id
    end

    test "call with no session sets the current_user assign to nil", %{conn: conn} do
        conn = Auth.call(conn, Repo)
        assert conn.assigns.current_user == nil
    end

    test "login with a valid username and pass", %{conn: conn} do
        user = insert_user(%{username: "me", password: "secret"})
        {:ok, conn} =
            Auth.login_by_username_and_pass(conn, "me", "secret", repo: Repo)

        assert conn.assigns.current_user.id == user.id
    end

    test "login with a not found user", %{conn: conn} do
        assert {:error, :not_found, _conn} =
            Auth.login_by_username_and_pass(conn, "me", "secret", repo: Repo)
    end

    test "login with a password mismatch", %{conn: conn} do
        _ = insert_user(%{username: "me", password: "secret"})
        assert {:error, :unauthorized, _conn} =
            Auth.login_by_username_and_pass(conn, "me", "wrong", repo: Repo)
    end
end