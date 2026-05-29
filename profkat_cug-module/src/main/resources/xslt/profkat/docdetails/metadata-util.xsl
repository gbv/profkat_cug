<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:mcri18n="http://www.mycore.de/xslt/i18n"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all"
  expand-text="yes">

  <xsl:template name="display-surnames">
    <xsl:if test="./metadata/box.surname/surname[position()>1] | ./metadata/box.variantname/variantname">
      <xsl:call-template name="dd_block">
        <xsl:with-param name="key" select="'variantnames'"/>
        <xsl:with-param name="labelkey" select="'OMD.profkat.variantnames'"/>
        <xsl:with-param name="items">
          <xsl:for-each select="./metadata/box.surname/surname[position()>1] | ./metadata/box.variantname/variantname">
            <tr>
              <td>{.}</td>
            </tr>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-firstnames">
    <xsl:if test="./metadata/box.firstname/firstname[position()>1]">
      <xsl:call-template name="dd_block">
        <xsl:with-param name="key" select="'variantnames'"/>
        <xsl:with-param name="labelkey" select="'OMD.profkat.firstnames'"/>
        <xsl:with-param name="showInfo" select="false()"/>
        <xsl:with-param name="items">
          <xsl:for-each select="./metadata/box.firstname/firstname[position()>1]">
            <tr>
              <td>{.}</td>
            </tr>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-other-infos">
    <xsl:if test="./metadata/box.otherinfo/otherinfo">
      <xsl:call-template name="dd_block">
        <xsl:with-param name="key" select="'otherinfo'"/>
        <xsl:with-param name="labelkey" select="'OMD.profkat.otherinfos'"/>
        <xsl:with-param name="items">
          <xsl:for-each select="./metadata/box.otherinfo/otherinfo">
            <tr>
              <td><xsl:value-of select="." /></td>
            </tr>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-meta">
    <xsl:param name="project" />

    <xsl:if test=".">
      <xsl:call-template name="dd_block">
        <xsl:with-param name="key" select="'created_changed'"/>
        <xsl:with-param name="labelkey" select="'OMD.profkat.created_changed'"/>
        <xsl:with-param name="css_class" select="'col2 w-100'"/>
        <xsl:with-param name="items">
          <tr>
            <td colspan="2">
              {format-dateTime(./service/servdates/servdate[@type='createdate'], '[D,2].[M,2].[Y]')}{
              if(not($project='cpb')) then (concat(', ', ./service/servflags/servflag[@type='createdby'])) else()}
              /
              {format-dateTime(./service/servdates/servdate[@type='modifydate'], '[D,2].[M,2].[Y]')}{
              if(not($project='cpb')) then (concat(', ', ./service/servflags/servflag[@type='modifiedby'])) else()}
            </td>
          </tr>
          <xsl:for-each select="./metadata/box.internalinfo/internalinfo[@type='editor']">
            <tr>
              <td>
                {mcri18n:translate(concat('OMD.profkat.internalinfo.',./@type))}
              </td>
              <td>
                <xsl:value-of select="./text()" />
              </td>
            </tr>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
