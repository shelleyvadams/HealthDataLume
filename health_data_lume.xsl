<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">
	<xsl:output method="html" indent="yes" version="5" omit-xml-declaration="yes" media-type="text/html"/>

	<xsl:template match="hl7:ClinicalDocument">
		<xsl:apply-templates select="hl7:languageCode/@code"/>
		<header>
			<xsl:apply-templates select="hl7:confidentialityCode"/>

			<h1>
				<xsl:choose>
					<xsl:when test="hl7:title and ( string-length(hl7:title) &gt; 0 )">
						<xsl:apply-templates select="hl7:title"/>
						<xsl:text> </xsl:text>
						<small><xsl:value-of select="hl7:code/@displayName"/></small>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="hl7:code/@displayName"/>
					</xsl:otherwise>
				</xsl:choose>
			</h1>

			<xsl:apply-templates select="hl7:recordTarget"/>

			<xsl:apply-templates select="hl7:effectiveTime"/>
			<xsl:call-template name="document-info"/>

		</header>

		<section>
			<xsl:apply-templates select="hl7:custodian"/>
			<xsl:apply-templates select="hl7:author"/>
			<xsl:apply-templates select="hl7:dataEnterer"/>
			<xsl:apply-templates select="hl7:legalAuthenticator"/>
			<xsl:apply-templates select="hl7:authenticator"/>
		</section>

		<xsl:apply-templates select="hl7:informant"/>
		<xsl:apply-templates select="hl7:participant"/>

		<xsl:apply-templates select="hl7:informationRecipient"/>
		<xsl:apply-templates select="hl7:inFulfillmentOf"/>

		<xsl:apply-templates select="hl7:documentationOf"/>
		<xsl:apply-templates select="hl7:relatedDocument"/>
		<xsl:apply-templates select="hl7:componentOf"/>

		<xsl:apply-templates select="hl7:authorization"/>

		<xsl:apply-templates select="hl7:component"/>

	</xsl:template>

	<!--  *******************************************  -->
	<!--  *******************************************  -->

	<xsl:template match="@language|hl7:languageCode/@code">
		<xsl:attribute name="lang">
			<xsl:value-of select="current()"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="hl7:authenticator">
		<section>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:time" mode="TS"/>
					<xsl:apply-templates select="hl7:signatureCode"/>
					<xsl:apply-templates select="hl7:assignedEntity"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:author">
		<section>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:call-template name="build-class-string">
						<xsl:with-param name="toBuildFrom" select="hl7:assignedAuthor"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:functionCode"/>
					<xsl:apply-templates select="hl7:time" mode="TS"/>
					<xsl:apply-templates select="hl7:assignedAuthor"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:authorization">
		<section>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:call-template name="build-class-string">
						<xsl:with-param name="toBuildFrom" select="hl7:consent"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:consent"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:ClinicalDocument/hl7:component">
		<section>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="more-classes">
					<xsl:call-template name="build-class-string">
						<xsl:with-param name="toBuildFrom" select="hl7:nonXMLBody|hl7:structuredBody"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:nonXMLBody|hl7:structuredBody"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:componentOf">
		<section>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:call-template name="build-class-string">
						<xsl:with-param name="toBuildFrom" select="hl7:encompassingEncounter"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:encompassingEncounter"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:custodian">
		<section>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:call-template name="build-class-string">
						<xsl:with-param name="toBuildFrom" select="hl7:assignedCustodian"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:assignedCustodian"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:dataEnterer">
		<section>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:assignedEntity"/>
					<xsl:apply-templates select="hl7:time" mode="TS"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:documentationOf">
		<section>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:call-template name="build-class-string">
						<xsl:with-param name="toBuildFrom" select="hl7:serviceEvent"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:serviceEvent"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:informant">
		<section>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:assignedEntity|hl7:relatedEntity"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:ClinicalDocument/hl7:informationRecipient">
		<section>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:call-template name="build-class-string">
						<xsl:with-param name="toBuildFrom" select="hl7:intendedRecipient"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:intendedRecipient"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:inFulfillmentOf">
		<section>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:call-template name="build-class-string">
						<xsl:with-param name="toBuildFrom" select="hl7:order"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:order"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:legalAuthenticator">
		<section>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:assignedEntity"/>
					<xsl:apply-templates select="hl7:signatureCode"/>
					<xsl:apply-templates select="hl7:time" mode="TS"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:ClinicalDocument/hl7:participant">
		<section>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:associatedEntity"/>
					<xsl:apply-templates select="hl7:functionCode"/>
					<xsl:apply-templates select="hl7:time"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:recordTarget">
		<section>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:if test="hl7:patientRole">
						<xsl:call-template name="build-class-string">
							<xsl:with-param name="toBuildFrom" select="hl7:patientRole"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:patientRole"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:relatedDocument">
		<section role="document">
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:parentDocument"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<!--  *******************************************  -->
	<!--  *******************************************  -->

	<!-- BEGIN: Code Systems -->

	<!-- Confidentiality [2.16.840.1.113883.5.25] -->
	<xsl:template match="hl7:confidentialityCode">
		<aside class="pull-right cda-confidentialityCode">
			<strong><xsl:text>Confidentiality:</xsl:text></strong>
			<xsl:text> </xsl:text>
			<xsl:choose>
				<xsl:when test="@code = 'U'">
					<xsl:text>Unrestricted</xsl:text>
				</xsl:when>
				<xsl:when test="@code = 'L'">
					<xsl:text>Low</xsl:text>
				</xsl:when>
				<xsl:when test="@code = 'M'">
					<xsl:text>Moderate</xsl:text>
				</xsl:when>
				<xsl:when test="@code = 'N'">
					<xsl:text>Normal</xsl:text>
				</xsl:when>
				<xsl:when test="@code = 'R'">
					<xsl:text>Restricted</xsl:text>
				</xsl:when>
				<xsl:when test="@code = 'V'">
					<xsl:text>Very Restricted</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<!-- FIXME
					<xsl:call-template name="CD"/>
					-->
				</xsl:otherwise>
			</xsl:choose>
		</aside>
	</xsl:template>

	<!-- NullFlavor [2.16.840.1.113883.5.1008] -->
	<xsl:template match="@nullFlavor">
		<span>
			<xsl:attribute name="class">
				<xsl:value-of select="local-name()"/>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="current() = 'NI'">
					<xsl:text>No Information</xsl:text>
				</xsl:when>
				<xsl:when test="current() = 'INV'">
					<xsl:text>Invalid</xsl:text>
				</xsl:when>
				<xsl:when test="current() = 'DER'">
					<xsl:text>Derived</xsl:text>
				</xsl:when>
				<xsl:when test="current() = 'OTH'">
					<xsl:text>Other</xsl:text>
				</xsl:when>
				<xsl:when test="current() = 'NINF'">
					<abbr title="negative infinity"><xsl:text>&#8722;&#8734;</xsl:text></abbr>
				</xsl:when>
				<xsl:when test="current() = 'PINF'">
					<abbr title="positive infinity"><xsl:text>+&#8734;</xsl:text></abbr>
				</xsl:when>
				<xsl:when test="current() = 'UNC'">
					<xsl:text>Un-encoded</xsl:text>
				</xsl:when>
				<xsl:when test="current() = 'MSK'">
					<xsl:text>Masked</xsl:text>
				</xsl:when>
				<xsl:when test="current() = 'NA'">
					<xsl:text>Not Applicable</xsl:text>
				</xsl:when>
				<xsl:when test="current() = 'UNK'">
					<xsl:text>Unknown</xsl:text>
				</xsl:when>
				<xsl:when test="current() = 'ASKU'">
					<xsl:text>Asked but Unknown</xsl:text>
				</xsl:when>
				<xsl:when test="current() = 'NAV'">
					<xsl:text>Temporarily Unavailable</xsl:text>
				</xsl:when>
				<xsl:when test="current() = 'NASK'">
					<xsl:text>Not Asked</xsl:text>
				</xsl:when>
				<xsl:when test="current() = 'QS'">
					<xsl:text>Sufficient Quantity</xsl:text>
				</xsl:when>
				<xsl:when test="current() = 'TRC'">
					<xsl:text>Trace</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="local-name()"/>
					<xsl:text>: </xsl:text>
					<code><xsl:value-of select="current()"/></code>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>

	<!-- END:   Code Systems -->

	<!--  *******************************************  -->
	<!--  *******************************************  -->

	<!-- BEGIN: Utility Templates -->

	<xsl:template name="document-info">
		<xsl:apply-templates select="hl7:id"/>
		<xsl:if test="hl7:setId">
			<section class="cda-set">
				<xsl:apply-templates select="hl7:setId"/>
				<xsl:if test="hl7:versionNumber">
					<xsl:text>, </xsl:text>
					<xsl:apply-templates select="hl7:versionNumber"/>
				</xsl:if>
			</section>
		</xsl:if>
	</xsl:template>

	<xsl:template name="set-classes">
		<xsl:param name="moreClasses"/>
		<xsl:attribute name="class">
			<xsl:call-template name="build-class-string"/>
			<xsl:if test="$moreClasses and ( string-length($moreClasses) &gt; 0 )">
				<xsl:text> </xsl:text>
				<xsl:value-of select="$moreClasses"/>
			</xsl:if>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="build-class-string">
		<xsl:param name="toBuildFrom" select="current()"/>
		<xsl:text>cda-</xsl:text>
		<xsl:value-of select="local-name($toBuildFrom)"/>
		<xsl:for-each select="$toBuildFrom/@classCode|$toBuildFrom/@moodCode|$toBuildFrom/@typeCode">
			<xsl:text> cda-</xsl:text>
			<xsl:value-of select="current()"/>
		</xsl:for-each>
	</xsl:template>

	<!-- END:   Utility Templates -->

</xsl:stylesheet>
