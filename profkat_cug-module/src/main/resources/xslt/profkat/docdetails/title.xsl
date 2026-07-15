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
    <xsl:variable name="name" select="./metadata/box.name/name[1]" />
    <xsl:variable name="surname" select="$name/surname[1]" />
    <xsl:variable name="firstname" select="$name/firstname[1]" />
    <xsl:variable name="academic" select="$name/academic[1]" />
    <xsl:variable name="prefix" select="$name/prefix[1]" />
    <xsl:variable name="title" select="normalize-space(concat($academic, ' ', $prefix))" />

    <xsl:value-of select="
      if ($title)
      then concat($title, ' ', $surname, ', ', $firstname)
      else concat($surname, ', ', $firstname)
    " />
  </xsl:template>

  <xsl:template match="mycoreobject[contains(@ID, '_person_') and metadata/box.surname/surname]">
    <xsl:variable name="surname" select="./metadata/box.surname/surname" />
    <xsl:variable name="firstname" select="./metadata/box.firstname/firstname" />
    <xsl:variable name="affix" select="./metadata/box.nameaffix/nameaffix" />

    <xsl:value-of select="
      if ($affix)
      then concat($surname, ', ', $firstname, ' (', $affix, ')')
      else concat($surname, ', ', $firstname)
    " />
  </xsl:template>

  <xsl:template match="mycoreobject">
    <xsl:value-of select="mcri18n:translate('WF.common.newObject')" />
  </xsl:template>

</xsl:stylesheet>
