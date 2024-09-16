# Catalogus Universitatis Gottingensis

Hier entsteht ein Anwendungsmodul für den auf MyCoRe basierenden [Professorenkatalog](https://github.com/MyCoRe-Org/professorenkatalog) im Rahmen des Projektes "[Catalogus Universitatis Gottingensis](https://www.uni-goettingen.de/de/projekt%3a+catalogus/676623.html)".

## Installation Instructions

* clone repository
* run `mvn clean install`
* unzip profkat_cug-cli to user defined cli directory
* change to cli directory
* run `bin/profkat_cug.sh create configuration directory`
* you now have a config dir `~/.mycore/profkat_cug`
* configure your database connection in `~/.mycore/profkat_cug/resources/META-INF/persistence.xml`
* perhaps you need to download a driver to `~/.mycore/profkat_cug/lib/`
* run cli command `bin/profkat_cug.sh process config/setup-commands.txt to load default data`
* Go to profkat_cug-webapp
* Install solr with the command: `mvn solr-runner:copyHome`
* Run solr with the command `mvn solr-runner:start` (End with `mvn solr-runner:stop`)
* Run Jetty with the command: `mvn jetty:run` (End with ctrl+c)
* Fast rebuild and Jetty restart `mvn clean install && cd profkat_cug-module && mvn jetty:run` (End with ctrl+c)