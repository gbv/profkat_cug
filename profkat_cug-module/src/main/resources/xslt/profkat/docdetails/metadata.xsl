<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">

  <xsl:import href="resource:xslt/profkat/docdetails/matrikel-metadata.xsl" />
  <xsl:import href="resource:xslt/profkat/docdetails/person-metadata.xsl" />

  <xsl:output method="html" indent="yes" standalone="no" encoding="UTF-8"/>

  <xsl:template match="/mycoreobject">
    <xsl:choose>
      <xsl:when test="contains(@ID, '_matrikel_')">
        <xsl:apply-templates select="." mode="matrikel" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="person" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
