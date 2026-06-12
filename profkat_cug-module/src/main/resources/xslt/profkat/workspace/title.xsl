<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:mcri18n="http://www.mycore.de/xslt/i18n"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">
 
  <xsl:import href="resource:xslt/functions/i18n.xsl" />

  <xsl:output method="html" indent="yes" standalone="no" encoding="UTF-8" />

  <xsl:template match="/">
    <xsl:apply-templates select="mycoreobject" />
  </xsl:template>

  <xsl:template match="mycoreobject[contains(@ID, '_matrikel_') and metadata/box.name/name/surname]">
    <xsl:variable name="name" select="(metadata/box.name/name)[1]" />

    <xsl:call-template name="display-name">
      <xsl:with-param name="surname" select="$name/surname" />
      <xsl:with-param name="firstname" select="$name/firstname" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="mycoreobject[contains(@ID, '_person_') and metadata/box.surname/surname]">
    <xsl:call-template name="display-name">
      <xsl:with-param name="surname" select="(metadata/box.surname/surname)[1]" />
      <xsl:with-param name="firstname" select="(metadata/box.firstname/firstname)[1]" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="mycoreobject">
    <xsl:value-of select="mcri18n:translate('WF.common.newObject')" />
  </xsl:template>

  <xsl:template name="display-name">
    <xsl:param name="surname" />
    <xsl:param name="firstname" />

    <xsl:value-of select="normalize-space(string-join(($firstname, $surname), ' '))" />
  </xsl:template>

</xsl:stylesheet>
