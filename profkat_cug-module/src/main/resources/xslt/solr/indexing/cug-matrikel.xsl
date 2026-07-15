<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:solrutil="http://mycore.org/cug/xslt/solrutil"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">

  <xsl:import href="xslImport:solr-document:solr/indexing/cug-matrikel.xsl" />
  <xsl:import href="resource:xslt/solr/indexing/solrutil.xsl" />
  
  <xsl:param name="WebApplicationBaseURL" />

  <xsl:template match="mycoreobject[contains(@ID,'_matrikel_')]">
    <xsl:apply-imports />
    <xsl:apply-templates select="metadata" mode="matrikel" />
    <field name="purl">
      <xsl:value-of select="concat($WebApplicationBaseURL, 'resolve/id/', ./@ID)" />
    </field>
  </xsl:template>

  <xsl:template match="metadata" mode="matrikel">
    <xsl:call-template name="enrollment" />
    <xsl:call-template name="fee" />
    <xsl:call-template name="guardian" />
    <xsl:call-template name="origin" />
    <xsl:call-template name="name" />
    <xsl:call-template name="occupation" />
    <xsl:call-template name="other-info" />
    <xsl:call-template name="prior-enrollments" />
    <xsl:call-template name="prior-matriculation" />
    <xsl:call-template name="school-certificate" />
    <xsl:call-template name="source" />
    <xsl:call-template name="status" />
  </xsl:template>

  <xsl:template name="school-certificate">
    <xsl:if test="box.school-certificate/school-certificate/text">
      <field name="cug.matrikel.school_certificate">
        <xsl:value-of select="box.school-certificate/school-certificate/text" />
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template name="enrollment">
    <xsl:if test="box.enrollment-date/enrollment-date/text">
      <field name="cug.matrikel.enrollment_date">
        <xsl:value-of select="box.enrollment-date/enrollment-date/text" />
      </field>
    </xsl:if>
    <xsl:if test="box.enrollment-number/enrollment-number">
      <field name="cug.matrikel.enrollment_number">
        <xsl:value-of select="box.enrollment-number/enrollment-number" />
      </field>
    </xsl:if>
    <xsl:if test="box.enrollment-sequence-number/enrollment-sequence-number">
      <field name="cug.matrikel.enrollment_sequence_number">
        <xsl:value-of select="box.enrollment-sequence-number/enrollment-sequence-number" />
      </field>
    </xsl:if>
    <xsl:if test="box.semester/semester">
      <xsl:variable name="semester" select="box.semester/semester" />
      <field name="cug.matrikel.semester">
        <xsl:value-of select="
          document(
            concat('classification:metadata:0:children:', $semester/@classid, ':', $semester/@categid)
          )//category/label[@xml:lang='de']/@text
        " />
      </field>
    </xsl:if>
    <xsl:if test="box.field-of-study/field-of-study">
      <xsl:variable name="field" select="box.field-of-study/field-of-study" />
      <field name="cug.matrikel.field_of_study">
        <xsl:value-of select="
          document(
            concat('classification:metadata:0:children:', $field/@classid, ':', $field/@categid)
          )//category/label[@xml:lang='de']/@text
        " />
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template name="fee">
    <xsl:if test="box.fee/fee">
      <field name="cug.matrikel.fee">
        <xsl:value-of select="box.fee/fee" />
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template name="guardian">
    <xsl:if test="box.guardian/guardian">
      <field name="cug.matrikel.guardian">
        <xsl:value-of select="box.guardian/guardian" />
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template name="origin">
    <xsl:if test="box.origin/origin/place/text()">
      <field name="cug.matrikel.origin">
        <xsl:value-of select="box.origin/origin/place/text()" />
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template name="name">
    <xsl:variable name="name" select="(box.name/name)[1]" />
    <xsl:variable name="firstname" select="($name/firstname)[1]" />
    <xsl:variable name="surname" select="($name/surname)[1]" />
    <xsl:variable name="academic" select="($name/academic)[1]" />
    <xsl:variable name="prefix" select="($name/prefix)[1]" />
    <xsl:variable name="title" select="normalize-space(concat($academic, ' ', $prefix))" />

    <xsl:for-each select="$surname | $firstname">
      <field name="profkat.name">
        <xsl:value-of select="text()"/>
      </field>
    </xsl:for-each>

    <xsl:if test="$surname and $firstname">
      <field name="profkat.name">
        <xsl:value-of select="concat($firstname, ' ', $surname)"/>
      </field>
      <xsl:if test="$title">
        <field name="profkat.name">
          <xsl:value-of select="concat($title, ' ', $firstname, ' ', $surname)"/>
        </field>
      </xsl:if>
    </xsl:if>

    <xsl:if test="$academic and $surname">
      <field name="profkat.name">
        <xsl:value-of select="concat($academic, ' ', $surname)"/>
      </field>
    </xsl:if>

    <xsl:if test="$academic">
      <field name="profkat.academictitle">
        <xsl:value-of select="$academic"/>
      </field>
    </xsl:if>

    <xsl:if test="$surname">
      <field name="cug.matrikel.name.facet">
        <xsl:value-of select="solrutil:get-name-facet($surname)"/>
      </field>
      <field name="cug.matrikel.name.full">
      <xsl:value-of select="
        if ($title and $firstname) then concat($title, ' ', $surname, ', ', $firstname)
        else if ($title) then concat($title, ' ', $surname)
        else if ($firstname) then concat($surname, ', ', $firstname)
        else $surname
      "/>
      </field>
      <field name="cug.matrikel.name.plain">
        <xsl:value-of select="
          if ($firstname) then concat($surname, ', ', $firstname)
          else $surname
        "/>
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template name="occupation">
    <xsl:if test="box.occupation/occupation">
      <field name="cug.matrikel.occupation">
        <xsl:value-of select="box.occupation/occupation" />
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template name="other-info">
    <xsl:if test="box.otherinfo/otherinfo">
      <field name="cug.matrikel.other_info">
        <xsl:value-of select="box.otherinfo/otherinfo" />
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template name="prior-enrollments">
    <xsl:for-each select="box.prior-enrollment/prior-enrollment/text">
      <field name="cug.matrikel.prior_enrollment">
        <xsl:value-of select="." />
      </field>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="prior-matriculation">
    <xsl:if test="box.prior-matriculation/prior-matriculation">
      <field name="cug.matrikel.prior_matriculation">
        <xsl:value-of select="box.prior-matriculation/prior-matriculation" />
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template name="source">
    <xsl:if test="box.source/source">
      <field name="cug.matrikel.source">
        <xsl:value-of select="box.source/source" />
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template name="status">
    <xsl:if test="box.status/status">
      <field name="cug.matrikel.status">
        <xsl:value-of select="box.status/status/text()" />
      </field>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
