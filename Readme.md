# Thelia project skeleton

This is the Composer project skeleton for [Thelia](https://thelia.net), the open-source e-commerce framework. Use it to bootstrap a new Thelia 3 project.

To contribute to Thelia itself, head over to [thelia/thelia](https://github.com/thelia/thelia).

## Requirements

- PHP 8.3
- MariaDB 10.11 / MySQL 8
- Composer 2.7+
- Web server (Nginx or Apache)
- Node.js 20 + npm (only required when building front-office and back-office templates that ship a Webpack pipeline; see the asset build step below)

Required PHP extensions: `pdo_mysql`, `openssl`, `intl`, `gd`, `curl`, `dom`, `mbstring`, `zip`.

## Quick start

### 1. Create a new project

```bash
composer create-project thelia/thelia-project:dev-twig my-shop
cd my-shop
```

This pulls the latest dev sources for the upcoming Thelia 3 release. Stable releases will be available via `composer create-project thelia/thelia-project my-shop` once the first major version is tagged on Packagist.

### 2. Start the local environment

The repository does not ship a Docker setup; the recommended path is [DDEV](https://ddev.com), which gives you PHP 8.3, MariaDB 10.11 and Node.js 20 with a single command.

```bash
ddev config --project-type=php --php-version=8.3 --database=mariadb:10.11 --docroot=public --nodejs-version=20
ddev start
ddev exec composer install
```

If you prefer your own stack (LAMP, Symfony CLI, Docker Compose, etc.), point your web server's docroot at `public/` and make sure the PHP binary you use to run `bin/install` and `bin/console` is the same major version your web server uses.

### 3. Install Thelia

`bin/install` reads its database credentials from the `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_NAME`, `DATABASE_USER` and `DATABASE_PASSWORD` environment variables. You can also pass them on the command line.

With DDEV, the database is exposed inside the web container as `db:3306` with user `db` / password `db`:

```bash
ddev exec bin/install \
  --database_host=db --database_port=3306 \
  --database_name=db --database_user=db --database_password=db \
  --frontoffice_theme=flexy --backoffice_theme=default-twig \
  --pdf_theme=default --email_theme=default \
  --with-demo --with-admin \
  --admin_login=thelia --admin_password=thelia \
  --admin_first_name=Admin --admin_last_name=User \
  --admin_email=admin@example.com
```

Outside DDEV, export the matching env vars (or write them to `.env.local`) and run `php bin/install` with the same flags minus `--database_*`.

`bin/install` creates the database if needed, applies the schema, registers and activates modules, installs the selected templates, optionally imports demo data and creates an admin user. Running it again is idempotent for the credentials part: only the data steps (demo, admin) recreate state.

### 4. Build front-office and back-office assets

The Flexy front-office template and the default-twig back-office template both ship a Webpack pipeline. Once `bin/install` finishes, build their static assets:

```bash
# Front-office (Flexy)
ddev exec bash -c "cd templates/frontOffice/flexy && npm install && npm run build"

# Back-office (default-twig)
ddev exec bash -c "cd templates/backOffice/default-twig && npm install && npm run build"
```

Once built, open `https://my-shop.ddev.site` for the storefront and `https://my-shop.ddev.site/admin` for the admin (default credentials: `thelia` / `thelia` if you used the snippet above).

## Back-office templates

The skeleton installs the Twig back-office (`templates/backOffice/default-twig/`) by default. It is built with Twig, Symfony UX and Bootstrap 5.

### Using the legacy Smarty back-office

The Smarty back-office from Thelia 2 is still available for projects that need it while they migrate. Add it next to the Twig one:

```bash
ddev exec composer require thelia/backoffice-default-template
ddev exec bin/console template:set backOffice default
ddev exec bin/console cache:clear -e dev
```

Both back-office templates can cohabit: the active one is controlled by `bin/console template:set backOffice <name>` (`default-twig` or `default`). Third-party modules built against the Smarty back-office keep working. If you maintain a module, the migration guide is in `templates/backOffice/default-twig/BREAKING_CHANGES.md`.

## Documentation

- Project home: <https://thelia.net>
- Documentation: <https://doc.thelia.net>
- Source code: [thelia/thelia](https://github.com/thelia/thelia)
- Modules: [thelia-modules](https://github.com/thelia-modules)

## License

LGPL-3.0-or-later. See `LICENSE.txt`.
