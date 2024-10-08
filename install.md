Installationsanleitung für Profkat Anwendung
===================================================
Voraussetzungen
---------------
Installation:
- Git
- Maven
- Ant

Betrieb:
- PostgreSQL (Produktion) / H2 (Test, Debug)
- SOLR
- Tomcat

Checkout
--------

- Verzeichnis erstellen
``` cmd
mkdir C:\profkat_cug\git
cd C:\profkat_cug\git
```

- Repos auschecken / in main-Branch wechseln

git clone https://github.com/gbv/profkat_cug.git
``` cmd
cd profkat_cug
git checkout production

Build
-----
``` cmd
mvn clean install
```


Configuration
-------------
- Konfigurationsverzeichnis erstellen
  > ant create.configuration.directory
- Datenbank installieren (H2 im Testbetrieb)
  - Version 1.4.199 verwenden (letzte aktuell mit MyCoRe funktionierende Version)
  - JAR-Datei herunterladen
    - via GUI: https://search.maven.org/artifact/com.h2database/h2/1.4.199/jar
    - direkt: https://repo1.maven.org/maven2/com/h2database/h2/1.4.199/h2-1.4.199.jar
  - in Config-Verzeichnis im Unterordner /lib ablegen
 - Datenbanktreiber installieren (PostgreSQL in Produktion)
    - in profkat_cug-module\pom.xml Postgres-Treiber als Dependency aktivieren
      <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
        <scope>runtime</scope>
      </dependency>
    - Anwendung bauen (> mvn clean install)
 - DatenbankSchemata erstellen (PostgresSQL)
   - via pgAdmin
   - neue Datenbank `mycoredb` (falls noch nicht vorhanden)
   - neue Schemata: `profkat_cug`, `profkat_cug_bpm`
 
 - Datenbank konfigurieren (H2 im Testbetrieb)   
   - resources\META-INF\persistence.xml
     <property name="javax.persistence.jdbc.driver" value="org.h2.Driver" />
     <property name="javax.persistence.jdbc.url" value="jdbc:h2:file:c:/Users/mcradmin/AppData/Local/MyCoRe/profkat_cug/data/h2/mycore;AUTO_SERVER=TRUE" />
   - camunda.cfg.xml (H2-Konfiguration für BPM-Engine)
     <property name="jdbcDriver" value="org.h2.Driver" />
     <property name="jdbcUrl" value="jdbc:h2:file:c:/Users/mcradmin/AppData/Local/MyCoRe/profkat_cug/data/h2/bpm" />
  
 - Datenbank konfigurieren (PostgreSQL in Produktion)
   - $MYCORE_HOME\resources\META-INF\persistence.xml
       <property name="javax.persistence.jdbc.driver" value="org.postgresql.Driver" />
       <property name="javax.persistence.jdbc.url" value="jdbc:postgresql://127.0.0.1/mycoredb?currentSchema=profkat_cug" />
       <property name="javax.persistence.jdbc.user" value="mcradmin" />
       <property name="javax.persistence.jdbc.password" value="***" />
   - C3P0 Connection Pooling aktivieren
   - $MYCORE_HOME\resources\camunda.cfg.xml
      <property name="jdbcUrl" value="jdbc:postgresql://127.0.0.1/mycoredb?currentSchema=profkat_cug_bpm" />
      <property name="databaseSchema" value="profkat_cug_bpm" />
      <property name="databaseTablePrefix" value="profkat_cug_bpm." />
      <property name="jdbcDriver" value="org.postgresql.Driver" />
      <property name="jdbcUsername" value="mcradmin" />
      <property name="jdbcPassword" value="***" />
   
   - ant update.database.config
     (oder Kommando: reload mappings in jpa configuration file)
            
  - SOLR installieren und konfigurieren
    - https://www.mycore.de/documentation/getting_started/gs_solr8/
    https://www.mycore.de/documentation/search/search_solr_use/
    C:\SOLR\solr-8.11.1\bin> .\solr create -c cug_main -d mycore_main
    C:\SOLR\solr-8.11.1\bin> .\solr create -c cug_classification -d mycore_classification

  - Konfiguration (mycore.properties) anpassen
  
    MCR.Solr.ServerURL=http://localhost:8983/
    MCR.Solr.Core.main.Name=cug_main
    MCR.Solr.Core.main.ServerURL=%MCR.Solr.ServerURL%
    MCR.Solr.Core.classification.Name=cug_classification
    MCR.Solr.Core.classification.ServerURL=%MCR.Solr.ServerURL%
    
    MCR.baseurl=http://localhost:8080/profkat_cug/
    #MCR.datadir=/opt/mycore/data/myapp
    MCR.datadir=C:\\WORK\\mycore-data\\profkat_cug
  
  - SOLR einrichten
    - > ant update.solr.config
    
  - Nutzer erstellen und laden
   - Verzeichnis: `profkat_cug-cli\src\main\config\user`
   - XML-Dateien bearbeiten + ggf. Build-Skript anpassen
   - > ant create.users
  
  - Klassifikationen erstellen und laden
    - Verzeichnis: `profkat_cug-cli\src\main\config\classification`
    - XML-Dateien bearbeiten + ggf. Build-Skript anpassen
    - > ant create.class
    
  
- ggf. Daten übernehmen
  - Altsystem: 
    - MyCoRe-ClI: > backup all objects of type person to directory ....
    - Daten zippen und herunterladen
    - Daten migrieren (https://lab.ub.uni-rostock.de/git/projects.cpr/cpr_migration)
  - Neu-System:
    - MyCoRe-ClI: > restore all objects from directory ...
  
  
  
  
  