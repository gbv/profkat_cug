<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:cugmetadatautils="http://mycore.org/cug/xslt/metadatautils"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">

  <xsl:import href="xslImport:docdetails-title:profkat/docdetails/cug-title-matrikel.xsl" />
  <xsl:import href="resource:xslt/functions/cug-metadata-utils.xsl" />

  <xsl:template match="/mycoreobject[contains(@ID, '_matrikel_') and metadata/box.name/name/(surname or firstname)]">
    <xsl:value-of select="cugmetadatautils:format-name((metadata/box.name/name)[1])" />
  </xsl:template>

</xsl:stylesheet>
