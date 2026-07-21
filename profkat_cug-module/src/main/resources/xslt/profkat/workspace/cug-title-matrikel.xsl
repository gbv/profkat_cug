<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="#all">

  <xsl:import href="xslImport:workspace-title:profkat/workspace/cug-title-matrikel.xsl" />

  <xsl:template match="mycoreobject[contains(@ID, '_matrikel_') and metadata/box.name/name/surname]">
    <xsl:variable name="name" select="(metadata/box.name/name)[1]" />
    <xsl:value-of select="normalize-space(string-join(($name/firstname, $name/surname), ' '))" />
  </xsl:template>

</xsl:stylesheet>
