# Redmine Login Audit

If you like this plugin, you're welcome to endorse me!
[![endorse](https://api.coderwall.com/martin-denizet/endorsecount.png)](https://coderwall.com/martin-denizet)

Work sponsored by Algen, visit us at http://algen.co

## Feature

* Logs successful login attempts in Redmine
* Report successful login attempts in Redmine
* Can send email on successful login attempts in Redmine

## Roadmap

If anybody could be interested, the next features to implement would be:
* Filtering
* API logging

## Downloading and installing the plugin

First download the plugin using git, open a terminal in your Redmine installation directory:

```git clone git@github.com:martin-denizet/redmine_login_audit.git vendor/plugins/```

Then you will need to do migrate the database for the plugin.

```rake db:migrate_plugins RAILS_ENV=production```

The installation is now finished and you will be able to use the plugin after you restart your Redmine instance.

## Credits

* Krzysztof Dryja: Original idea and code contribution
* Martin Denizet: Development
* Maiko de Andrade: Brasilian Portuguese translation
* Sergei Bershadsky: Russian translation
* R-i-c-k-y: Italian translation

## License

GPLv2


