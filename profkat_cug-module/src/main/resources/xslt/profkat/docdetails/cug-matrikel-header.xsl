<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:cugmetadatautils="http://mycore.org/cug/xslt/metadatautils"
  xmlns:mcrclass="http://www.mycore.de/xslt/classification"
  xmlns:mcri18n="http://www.mycore.de/xslt/i18n"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">

  <xsl:import href="xslImport:docdetails-header:profkat/docdetails/cug-matrikel-header.xsl" />
  <xsl:import href="resource:xslt/functions/classification.xsl" />
  <xsl:import href="resource:xslt/functions/i18n.xsl" />
  <xsl:import href="resource:xslt/functions/cug-metadata-utils.xsl" />
  <xsl:import href="resource:xslt/docdetails/docdetails.xsl" />

  <xsl:param name="CurrentLang" />
  <xsl:param name="DefaultLang" />

  <xsl:template match="/mycoreobject[contains(@ID, '_matrikel_')]">
    <div class="row">
      <div id="docdetails-header" class="col">
        <h2>
          <xsl:value-of select="cugmetadatautils:format-name((metadata/box.name/name)[1])" />
        </h2>
        <xsl:variable name="semester" select="(metadata/box.semester/semester)[1]" />
        <xsl:variable name="fields-of-study" select="metadata/box.field-of-study/field-of-study" />
        <xsl:if test="exists($semester) or exists($fields-of-study)">
          <xsl:call-template name="dd_block">
            <xsl:with-param name="key" select="'summary'" />
            <xsl:with-param name="showInfo" select="false()" />
            <xsl:with-param name="css_class" select="'col2 font-weight-bold w-100'" />
            <xsl:with-param name="items">
              <tr>
                <xsl:if test="$semester">
                  <xsl:variable name="semester-text" select="mcrclass:current-label-text($semester)" />
                  <td>
                    <xsl:value-of select="mcri18n:translate('cug.since') || ' ' || $semester-text" />
                  </td>
                </xsl:if>
                <xsl:if test="exists($fields-of-study)">
                  <td>
                    <xsl:value-of select="
                      string-join(for $f in $fields-of-study return mcrclass:current-label-text($f), ', ')
                    " />
                  </td>
                </xsl:if>
              </tr>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
