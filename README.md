# Rumbl

To install and setup PostgreSQL:

  * Install PostgreSQL for Windows from [here](https://www.postgresql.org/download/windows/)
  * Run through the installer
    * Enter a password when prompted that will be secure and memorable.
    * You don't necessarily need any of the addons from StackBuilder now.
  * Add the /bin and /lib paths from your PostgreSQL directory to your Environment Variables
  * In dev.exs, change the password for PostgreSQL to the one you used during installation
  * Run `mix ecto.create`
  * To login with the command line tool `psql` use `psql -U postgres postgres` and then enter your password
    * The first postgres is the default username and the second postgres is the default database


To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


To compile Comeonin on Windows you must first run the following, making changes to the path accordingly:
`cmd /K "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64`
Then run `mix deps.compile comeonin`



Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
