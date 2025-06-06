# Catalogus Universitatis Gottingensis

Hier entsteht ein Anwendungsmodul für den auf MyCoRe basierenden [Professorenkatalog](https://github.com/MyCoRe-Org/professorenkatalog) im Rahmen des Projektes "[Catalogus Universitatis Gottingensis](https://www.uni-goettingen.de/de/projekt%3a+catalogus/676623.html)".

## Installation Instructions

* clone repository
* run `mvn clean install`
* unzip profkat_cug-cli to user defined cli directory
* change to cli directory
* run `bin/profkat_cug.sh create configuration directory`
* you now have a config dir `~/.mycore/profkat_cug`
* configure your database connection in `~/.mycore/profkat_cug/mycore.properties`
* configure your BPM-Engine h2 connection in `~/.mycore/profkat_cug/resources/camunda.cfg.xml`
* perhaps you need to download a driver to `~/.mycore/profkat_cug/lib/`
* run cli command `bin/profkat_cug.sh process config/setup-commands.txt to load default data`
* Go to profkat_cug-webapp
* Install solr with the command: `mvn solr-runner:copyHome`
* Run solr with the command `mvn solr-runner:start` (End with `mvn solr-runner:stop`)
* Go back to profkat_cug `cd ..`
* Run Tomcat with the command: `mvn cargo:run -Dtomcat=10 -pl profkat_cug-webapp` (End with ctrl+c)
* Fast rebuild and Tomcat restart `mvn clean install && mvn cargo:run -Dtomcat=10 -pl profkat_cug-webapp` (End with ctrl+c)