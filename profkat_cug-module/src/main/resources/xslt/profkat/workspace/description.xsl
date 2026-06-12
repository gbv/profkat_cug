<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">

  <xsl:output method="html" indent="yes" standalone="no" encoding="UTF-8" />

  <xsl:template match="/">
    <xsl:apply-templates select="mycoreobject" />
  </xsl:template>

  <xsl:template match="mycoreobject[contains(@ID, '_person_')]">
    <xsl:variable name="birth" select="(metadata/box.birth/birth/text[@xml:lang='de'])[1]" />
    <xsl:variable name="death" select="(metadata/box.death/death/text[@xml:lang='de'])[1]" />

    <xsl:variable name="dates" as="xs:string*" select="
      if ($birth) then concat('* ', $birth) else (),
      if ($death) then concat('✝ ', $death) else ()
    " />

    <xsl:value-of select="string-join($dates, '&#160;&#160;&#160;')" />
  </xsl:template>

  <xsl:template match="mycoreobject" />

</xsl:stylesheet>
