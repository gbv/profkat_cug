<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:cugmetadatautils="http://mycore.org/cug/xslt/metadatautils"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">

  <xsl:function name="cugmetadatautils:format-name" as="xs:string">
    <xsl:param name="name" as="element()?" />

    <xsl:variable name="surname" select="$name/surname" />
    <xsl:variable name="firstname" select="$name/firstname" />
    <xsl:variable name="academic" select="$name/academic" />
    <xsl:variable name="prefix" select="$name/prefix" />
    <xsl:variable name="title" select="normalize-space(concat($academic, ' ', $prefix))" />

    <xsl:variable name="fullname" as="xs:string" select="
      string-join(($surname, if ($firstname) then concat(', ', $firstname) else ()), '')
    " />

    <xsl:sequence select="
      if ($title)
      then concat($title, ' ', $fullname)
      else $fullname
    " />
  </xsl:function>

</xsl:stylesheet>
