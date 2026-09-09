<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:solrutil="http://mycore.org/cug/xslt/solrutil"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">

  <xsl:function name="solrutil:normalize-german-chars" as="xs:string">
    <xsl:param name="value" as="xs:string"/>

    <xsl:variable name="char-replacements" select="map{
      'ä': 'ae', 'Ä': 'AE',
      'ö': 'oe', 'Ö': 'OE',
      'ü': 'ue', 'Ü': 'UE',
      'ß': 'ss', 'ẞ': 'SS'
    }"/>

    <xsl:sequence select="
      fn:fold-left(map:keys($char-replacements), $value, function($acc, $key) {
        fn:replace($acc, $key, map:get($char-replacements, $key))
      })
    "/>
  </xsl:function>

  <xsl:function name="solrutil:get-name-facet" as="xs:string">
    <xsl:param name="value" as="xs:string"/>

    <xsl:variable name="normed" select="solrutil:normalize-german-chars($value)" />

    <xsl:sequence select="
      if (starts-with($normed, 'Sch')) then substring($normed, 1, 4)
      else if (starts-with($normed, 'St'))  then substring($normed, 1, 3)
      else upper-case(substring($normed, 1, 1)) || substring($normed, 2, 1)
    " />
  </xsl:function>

</xsl:stylesheet>
