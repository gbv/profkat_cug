<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:mcrclass="http://www.mycore.de/xslt/classification"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all"
  expand-text="yes">

  <xsl:import href="resource:xslt/functions/classification.xsl" />
  <xsl:import href="resource:xslt/profkat/docdetails/metadata-util.xsl" />

  <xsl:template match="/mycoreobject" mode="matrikel">
    <xsl:variable name="project" select="substring-before(@ID, '_')" />
    <div class="row">
      <div id="docdetails-data" class="col">
        <xsl:call-template name="display-enrollment-date" />
        <xsl:call-template name="display-enrollment-number" />
        <xsl:call-template name="display-enrollment-sequence-number" />
        <xsl:call-template name="display-fee" />

        <xsl:call-template name="dd_separator" />

        <xsl:call-template name="display-origin" />
        <xsl:call-template name="display-guardian" />
        <xsl:call-template name="display-occupation" />

        <xsl:call-template name="dd_separator" />

        <xsl:call-template name="display-diploma" />
        <xsl:call-template name="display-prior-enrollment" />
        <xsl:call-template name="display-prior-matriculation" />

        <xsl:call-template name="dd_separator" />

        <xsl:call-template name="display-other-infos" />

        <xsl:call-template name="dd_separator" />

        <xsl:call-template name="display-meta">
          <xsl:with-param name="project" select="$project" />
        </xsl:call-template>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="display-semester">
    <xsl:if test="./metadata/box.semester">
      <xsl:call-template name="display-text">
        <xsl:with-param name="key" select="'semester'" />
        <xsl:with-param name="label-key" select="'cug.semester'" />
        <xsl:with-param name="text" select="mcrclass:current-label-text(./metadata/box.semester/semester)" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-enrollment-date">
    <xsl:if test="./metadata/box.enrollment-date/enrollment-date/text[@xml:lang='de']">
      <xsl:call-template name="display-text">
        <xsl:with-param name="key" select="'enrollment-date'" />
        <xsl:with-param name="label-key" select="'cug.enrollmentDate'" />
        <xsl:with-param name="text" select="./metadata/box.enrollment-date/enrollment-date/text[@xml:lang='de']" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-enrollment-number">
    <xsl:if test="./metadata/box.enrollment-number/enrollment-number/text()">
      <xsl:call-template name="display-text">
        <xsl:with-param name="key" select="'enrollment-number'" />
        <xsl:with-param name="label-key" select="'cug.enrollmentNumber'" />
        <xsl:with-param name="text" select="./metadata/box.enrollment-number/enrollment-number/text()" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-enrollment-sequence-number">
    <xsl:if test="./metadata/box.enrollment-sequence-number/enrollment-sequence-number/text()">
      <xsl:call-template name="display-text">
        <xsl:with-param name="key" select="'enrollment-sequence-number'" />
        <xsl:with-param name="label-key" select="'cug.enrollmentSequenceNumber'" />
        <xsl:with-param name="text" select="
          ./metadata/box.enrollment-sequence-number/enrollment-sequence-number/text()
        " />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-origin">
    <xsl:if test="./metadata/box.origin/origin/place/text()">
      <xsl:call-template name="display-text">
        <xsl:with-param name="key" select="'origin'" />
        <xsl:with-param name="label-key" select="'cug.origin'" />
        <xsl:with-param name="text" select="./metadata/box.origin/origin/place/text()" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-field-of-study">
    <xsl:if test="./metadata/box.field-of-study">
      <xsl:call-template name="display-text">
        <xsl:with-param name="key" select="'field-of-study'" />
        <xsl:with-param name="label-key" select="'cug.fieldOfStudy'" />
        <xsl:with-param name="text" select="
          mcrclass:current-label-text(./metadata/box.field-of-study/field-of-study)
        " />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-prior-enrollment">
    <xsl:if test="./metadata/box.prior-enrollment/prior-enrollment/text">
      <xsl:call-template name="display-text">
        <xsl:with-param name="key" select="'prior-enrollment'" />
        <xsl:with-param name="label-key" select="'cug.priorEnrollment'" />
        <xsl:with-param name="text" select="./metadata/box.prior-enrollment/prior-enrollment/text" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-prior-matriculation">
    <xsl:if test="./metadata/box.prior-matriculation/prior-matriculation/text()">
      <xsl:call-template name="display-text">
        <xsl:with-param name="key" select="'prior-matriculation'" />
        <xsl:with-param name="label-key" select="'cug.priorMatriculation'" />
        <xsl:with-param name="text" select="./metadata/box.prior-matriculation/prior-matriculation/text()" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-fee">
    <xsl:if test="./metadata/box.fee/fee/text()">
      <xsl:call-template name="display-text">
        <xsl:with-param name="key" select="'fee'" />
        <xsl:with-param name="label-key" select="'cug.fee'" />
        <xsl:with-param name="text" select="./metadata/box.fee/fee/text()" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-occupation">
    <xsl:if test="./metadata/box.occupation/occupation/text()">
      <xsl:call-template name="display-text">
        <xsl:with-param name="key" select="'occupation'" />
        <xsl:with-param name="label-key" select="'cug.occupation'" />
        <xsl:with-param name="text" select="./metadata/box.occupation/occupation/text()" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-guardian">
    <xsl:if test="./metadata/box.guardian/guardian/text()">
      <xsl:call-template name="display-text">
        <xsl:with-param name="key" select="'guardian'" />
        <xsl:with-param name="label-key" select="'cug.guardian'" />
        <xsl:with-param name="text" select="./metadata/box.guardian/guardian/text()" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-diploma">
    <xsl:if test="./metadata/box.diploma/diploma/text()">
      <xsl:call-template name="display-text">
        <xsl:with-param name="key" select="'diploma'" />
        <xsl:with-param name="label-key" select="'cug.diploma'" />
        <xsl:with-param name="text" select="./metadata/box.diploma/diploma/text()" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="display-text">
    <xsl:param name="key" />
    <xsl:param name="label-key" />
    <xsl:param name="text" />

    <xsl:call-template name="dd_block">
      <xsl:with-param name="key" select="$key"/>
      <xsl:with-param name="labelkey" select="$label-key"/>
      <xsl:with-param name="items">
        <tr>
          <td>
            <xsl:value-of select="$text" />
          </td>
        </tr>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
