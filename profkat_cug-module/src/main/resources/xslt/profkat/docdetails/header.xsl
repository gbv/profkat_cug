<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:mcrclass="http://www.mycore.de/xslt/classification"
  xmlns:mcri18n="http://www.mycore.de/xslt/i18n"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all"
  expand-text="yes">

  <xsl:import href="resource:xslt/functions/classification.xsl" />
  <xsl:import href="resource:xslt/functions/i18n.xsl" />
  <xsl:import href="resource:xslt/docdetails/docdetails.xsl" />

  <xsl:output method="html" indent="yes" standalone="no" encoding="UTF-8" />

  <xsl:param name="CurrentLang" />
  <xsl:param name="DefaultLang" />
  <xsl:param name="WebApplicationBaseURL" />

  <xsl:template match="/">
    <div class="row">
      <div id="docdetails-header" class="col">
        <xsl:apply-templates select="mycoreobject" />
      </div>
    </div>
  </xsl:template>

  <xsl:template match="mycoreobject[contains(@ID, '_matrikel_')]">
    <xsl:variable name="name" select="(metadata/box.name/name)[1]" />

    <xsl:variable name="surname" select="$name/surname" />
    <xsl:variable name="firstname" select="$name/firstname" />
    <xsl:variable name="academic" select="$name/academic" />
    <xsl:variable name="prefix" select="$name/prefix" />
    <xsl:variable name="title" select="normalize-space(concat($academic, ' ', $prefix))" />

    <h2>
      <xsl:value-of select="
        if (normalize-space($title))
        then concat($title, ' ', $surname, ', ', $firstname)
        else concat($surname, ', ', $firstname)
      " />
    </h2>

    <xsl:variable name="semester" select="(metadata/box.semester/semester)[1]" />
    <xsl:variable name="field-of-study" select="(metadata/box.field-of-study/field-of-study)[1]" />
    <xsl:if test="exists($semester) or exists($field-of-study)">
      <xsl:call-template name="dd_block">
        <xsl:with-param name="key" select="'summary'" />
        <xsl:with-param name="showInfo" select="false()" />
        <xsl:with-param name="css_class" select="'col2 font-weight-bold w-100'" />
        <xsl:with-param name="items">
          <tr>
            <xsl:if test="$semester">
              <td>
                <xsl:value-of select="mcri18n:translate('cug.since') || ' ' || mcrclass:current-label-text($semester)" />
              </td>
            </xsl:if>
            <xsl:if test="$field-of-study">
              <td>
                <xsl:value-of select="mcrclass:current-label-text($field-of-study)" />
              </td>
            </xsl:if>
          </tr>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mycoreobject">
    <xsl:variable name="last" select="./metadata/box.surname/surname[1]" />
    <xsl:variable name="first" select="./metadata/box.firstname/firstname[1]" />
    <xsl:variable name="affix" select="./metadata/box.nameaffix/nameaffix[1]" />
    <xsl:variable name="akadtitle" select="string-join(./metadata/box.academictitle/academictitle, ', ')" />

    <h2>
      {$last},&#160;{$first}
      <xsl:if test="fn:string-length($affix)>1">({$affix})</xsl:if>
    </h2>
    <div id="docdetails-academictitle" class="docdetails-block">
      {if (fn:string-length($akadtitle)>2) then $akadtitle else '&#160;'}
    </div>

    <xsl:call-template name="dd_block">
      <xsl:with-param name="key" select="'professorships'"/>
      <xsl:with-param name="showInfo" select="false()"/>
      <xsl:with-param name="css_class" select="'col2 font-weight-bold w-100'"/>
      <xsl:with-param name="items">
        <xsl:for-each select="/mycoreobject/metadata/box.professorship/professorship">
          <tr>
            <td>
              <xsl:variable name="prof_time" select="./text[@xml:lang='de']" />
              <xsl:if test="$prof_time and not($prof_time = '#')">
                {$prof_time}
              </xsl:if>
            </td>
            <td>{./event}</td>
            <td class="profkat-prev-next">
              <div style="text-align: right; white-space: nowrap; font-size:80%;">
                <!-- TODO Trennzeichen bei mehreren Vorgängern / Nachfolgern prüfen alter Code: delims=":;|" -->
                <xsl:for-each select="tokenize(./text[@xml:lang='x-predec']/text(),'\|')">
                  <xsl:if test="contains(., '_person_')">
                    <xsl:try>
                      <xsl:variable name="linked" select="document(concat('mcrobject:',.))" />
                      <xsl:if test="$linked">
                        <xsl:variable name="doctitle">
                          {mcri18n:translate('OMD.profkat.hint.predec')}:
                          {$linked/mycoreobject/metadata/box.surname/surname[1]},&#160;
                          {$linked/mycoreobject/metadata/box.firstname/firstname[1]}
                          {if(string-length($linked/mycoreobject/metadata/box.nameaffix/nameaffix)>1)
                          then ($linked/mycoreobject/metadata/box.nameaffix/nameaffix[1])
                          else ()}
                        </xsl:variable>
                        <a href="{$WebApplicationBaseURL}resolve/id/{.}" style="color:grey;margin-left:6px">
                          <i class="fas fa-backward" title="{normalize-space($doctitle)}"></i>
                        </a>
                      </xsl:if>
                      <xsl:catch errors="*">
                      </xsl:catch>
                    </xsl:try>
                  </xsl:if>
                </xsl:for-each>

                <xsl:for-each select="tokenize(./text[@xml:lang='x-succ']/text(),'\|')">
                  <xsl:if test="contains(., '_person_')">
                    <xsl:try>
                      <xsl:variable name="linked" select="document(concat('mcrobject:',.))" />
                      <xsl:if test="$linked">
                        <xsl:variable name="doctitle">
                          {mcri18n:translate('OMD.profkat.hint.succ')}:
                          {$linked/mycoreobject/metadata/box.surname/surname[1]},&#160;
                          {$linked/mycoreobject/metadata/box.firstname/firstname[1]}
                          {if(string-length($linked/mycoreobject/metadata/box.nameaffix/nameaffix)>1)
                          then ($linked/mycoreobject/metadata/box.nameaffix/nameaffix[1])
                          else ()}
                        </xsl:variable>
                        <a href="{$WebApplicationBaseURL}resolve/id/{.}" style="color:grey;margin-left:6px">
                          <i class="fas fa-forward" title="{normalize-space($doctitle)}"></i>
                        </a>
                      </xsl:if>
                      <xsl:catch errors="*">
                      </xsl:catch>
                    </xsl:try>
                  </xsl:if>
                </xsl:for-each>
              </div>
            </td>
          </tr>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:if test="/mycoreobject/metadata/box.professorship/professorship/text[@xml:lang='x-succ' or @xml:lang='x-predec']">
      <div id="docdetails-label-predec_succ" class="text-right text-nowrap">
        <span class="docdetails-label">{mcri18n:translate('OMD.profkat.professorships.predec_succ')}</span>
      </div>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
