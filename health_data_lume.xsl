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

	<xsl:template match="hl7:administrationUnitCode|hl7:awarenessCode|hl7:dischargeDispositionCode|hl7:ethnicGroupCode|hl7:functionCode|hl7:interpretationCode|hl7:maritalStatusCode|hl7:methodCode|hl7:modeCode|hl7:priorityCode|hl7:proficiencyLevelCode|hl7:raceCode|hl7:religiousAffiliationCode|hl7:routeCode|hl7:standardIndustryClassCode">
		<div>
			<xsl:call-template name="set-classes"/>
			<xsl:call-template name="CD"/>
		</div>
	</xsl:template>

	<xsl:template match="hl7:assignedAuthor">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:code"/>
				<xsl:choose>
					<xsl:when test="hl7:assignedPerson">
						<xsl:apply-templates select="hl7:assignedPerson"/>
						<xsl:apply-templates select="hl7:id"/>
						<xsl:apply-templates select="hl7:representedOrganization"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="hl7:representedOrganization"/>
						<xsl:apply-templates select="hl7:assignedAuthoringDevice"/>
						<xsl:apply-templates select="hl7:id"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="hl7:addr"/>
				<xsl:apply-templates select="hl7:telecom"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="hl7:assignedCustodian">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:representedCustodianOrganization"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="hl7:assignedEntity">
		<section>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:code"/>
					<xsl:apply-templates select="hl7:assignedPerson"/>
					<xsl:apply-templates select="hl7:id"/>
					<xsl:apply-templates select="hl7:representedOrganization"/>
					<xsl:apply-templates select="hl7:addr"/>
					<xsl:apply-templates select="hl7:telecom"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:associatedEntity">
		<section>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:code"/>
					<xsl:apply-templates select="hl7:id"/>
					<xsl:apply-templates select="hl7:associatedPerson"/>
					<xsl:apply-templates select="hl7:scopingOrganization"/>
					<xsl:apply-templates select="hl7:addr"/>
					<xsl:apply-templates select="hl7:telecom"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:authenticator|hl7:legalAuthenticator">
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
					<xsl:apply-templates select="hl7:assignedAuthor"/>
					<xsl:apply-templates select="hl7:functionCode"/>
					<xsl:apply-templates select="hl7:time" mode="TS"/>
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

	<xsl:template match="hl7:consent">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:code"/>
				<xsl:apply-templates select="hl7:id"/>
				<xsl:apply-templates select="hl7:statusCode"/>
			</xsl:otherwise>
		</xsl:choose>
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

	<xsl:template match="hl7:encompassingEncounter">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:effectiveTime"/>
				<xsl:apply-templates select="hl7:code"/>
				<xsl:apply-templates select="hl7:id"/>
				<xsl:apply-templates select="hl7:location"/>
				<xsl:apply-templates select="hl7:responsibleParty"/>
				<xsl:apply-templates select="hl7:dischargeDispositionCode"/>
				<xsl:apply-templates select="hl7:encounterParticipant"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="hl7:externalDocument">
		<section role="document">
			<xsl:call-template name="set-classes"/>
			<xsl:call-template name="ExternalDocument"/>
		</section>
	</xsl:template>

	<xsl:template match="hl7:reference/hl7:externalDocument|hl7:parentDocument">
		<xsl:call-template name="ExternalDocument"/>
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

	<xsl:template match="hl7:intendedRecipient">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:informationRecipient"/>
				<xsl:apply-templates select="hl7:receivedOrganization"/>
				<xsl:apply-templates select="hl7:id"/>
				<xsl:apply-templates select="hl7:telecom"/>
				<xsl:apply-templates select="hl7:addr"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="hl7:languageCode|hl7:realmCode|hl7:signatureCode|hl7:statusCode">
		<div>
			<xsl:call-template name="set-classes"/>
			<xsl:call-template name="CS"/>
		</div>
	</xsl:template>

	<xsl:template match="hl7:nonXMLBody|hl7:structuredBody">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="hl7:languageCode/@code">
					<xsl:attribute name="lang">
						<xsl:apply-templates select="hl7:languageCode/@code"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="hl7:confidentialityCode"/>
				<xsl:apply-templates select="hl7:component|hl7:text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="hl7:order">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:code"/>
				<xsl:apply-templates select="hl7:id"/>
				<xsl:apply-templates select="hl7:priorityCode"/>
			</xsl:otherwise>
		</xsl:choose>
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
					<!-- FIXME: IVL_TS -->
					<xsl:apply-templates select="hl7:time"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:patientRole">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:patient"/>
				<section>
					<xsl:apply-templates select="hl7:id"/>
					<xsl:apply-templates select="hl7:telecom"/>
					<xsl:apply-templates select="hl7:addr"/>
				</section>
				<xsl:apply-templates select="hl7:providerOrganization"/>
			</xsl:otherwise>
		</xsl:choose>
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

	<xsl:template match="hl7:relatedEntity">
		<section>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<header>
						<xsl:apply-templates select="hl7:relatedPerson"/>
						<xsl:apply-templates select="hl7:effectiveTime"/>
						<xsl:apply-templates select="hl7:code"/>
					</header>
					<xsl:apply-templates select="hl7:telecom"/>
					<xsl:apply-templates select="hl7:addr"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:serviceEvent">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:effectiveTime"/>
				<xsl:apply-templates select="hl7:code"/>
				<xsl:apply-templates select="hl7:performer"/>
				<xsl:apply-templates select="hl7:id"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="hl7:time" mode="TS">
		<xsl:call-template name="TS"/>
	</xsl:template>

	<!--  *******************************************  -->
	<!--  *******************************************  -->

	<!-- BEGIN: POCD_MT000040 Data Types -->

	<!-- POCD_MT000040.ParentDocument is an ExternalDocument -->
	<!-- POCD_MT000040.ExternalDocument -->
	<xsl:template name="ExternalDocument">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<header>
					<xsl:apply-templates select="hl7:code" mode="CD"/>
					<xsl:call-template name="document-info"/>
				</header>
				<xsl:apply-templates select="hl7:text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- END:   POCD_MT000040 Data Types -->

	<!--  *******************************************  -->
	<!--  *******************************************  -->

	<!-- BEGIN: ITS Data Types -->

	<!--  *******************************************  -->

	<!-- Coded Value ~ CD -->
	<!-- Coded Ordinal ~ CD -->
	<!-- Coded with Equivalents ~ CD -->
	<!-- BEGIN: Concept Descriptor -->
	<xsl:template name="CD">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:originalText"/>
				<div>
					<xsl:choose>
						<xsl:when test="./@displayName">
							<xsl:value-of select="./@displayName"/>
							<xsl:text> (</xsl:text>
							<xsl:value-of select="./@code"/>
							<xsl:text>)</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./@code"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="./@codeSystem or ./@codeSystemName">
						<xsl:text> in </xsl:text>
						<cite>
							<xsl:choose>
								<xsl:when test="./@codeSystemName">
									<xsl:comment><xsl:value-of select="./@codeSystem"/></xsl:comment>
									<xsl:value-of select="./@codeSystemName"/>
									<xsl:apply-templates select="./@codeVersion"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="./@codeSystem"/>
								</xsl:otherwise>
							</xsl:choose>
						</cite>
					</xsl:if>
				</div>
				<xsl:if test="hl7:translation">
					<ul><!-- SET[CD] -->
						<xsl:for-each select="hl7:translation">
							<li><xsl:call-template name="CD"/></li>
						</xsl:for-each>
					</ul>
				</xsl:if>
				<xsl:if test="hl7:qualifer"><!-- LIST[CR] -->
					<ol>
						<xsl:for-each select="hl7:qualifer">
							<li><xsl:call-template name="CR"/></li>
						</xsl:for-each>
					</ol>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Code System Version -->
	<xsl:template match="@codeSystemVersion">
		<xsl:text>, version </xsl:text>
		<xsl:value-of select="current()"/>
	</xsl:template>

	<!-- CD Original Text
	FIXME
	<xsl:template match="hl7:originalText">
		<xsl:call-template name="ED"/>
	</xsl:template>
	 -->
	<!-- END: Concept Descriptor -->

	<!--  *******************************************  -->

	<!-- BEGIN: Concept Role -->
	<xsl:template name="CR">
		<xsl:apply-templates select="./@nullFlavor"/>
		<xsl:apply-templates select="hl7:name" mode="CR"/>
		<xsl:text> is </xsl:text>
		<xsl:if test="./@inverted = 'true'">
			<strong><xsl:text>inverse of</xsl:text></strong>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:apply-templates select="hl7:value" mode="CR"/>
	</xsl:template>

	<!-- CR.Name -->
	<xsl:template match="hl7:name" mode="CR">
		<xsl:call-template name="CD"/>
	</xsl:template>

	<!-- CR.Value -->
	<xsl:template match="hl7:value" mode="CR">
		<xsl:call-template name="CD"/>
	</xsl:template>
	<!-- END: Concept Role -->

	<!--  *******************************************  -->

	<!-- Coded Simple Value -->
	<xsl:template name="CS">
		<xsl:param name="element" select="current()"/>
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$element/@code"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--  *******************************************  -->

	<!-- Point in Time -->
	<xsl:template name="TS">
		<xsl:param name="element" select="current()"/>
		<xsl:choose>
			<xsl:when test="$element/@nullFlavor">
				<span>
					<xsl:attribute name="class">
						 <xsl:value-of select="local-name($element)"/>
					</xsl:attribute>
					<xsl:apply-templates select="$element/@nullFlavor"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<time>
					<xsl:attribute name="class">
						 <xsl:value-of select="local-name($element)"/>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="string-length($element/@value) = 8 or string-length($element/@value) &gt;= 14">
							<xsl:variable name="time_string">
								<xsl:value-of select="substring($element/@value,1,4)"/>
								<xsl:text>-</xsl:text>
								<xsl:value-of select="substring($element/@value,5,2)"/>
								<xsl:text>-</xsl:text>
								<xsl:value-of select="substring($element/@value,7,2)"/>
								<xsl:if test="string-length($element/@value) &gt;= 14">
									<xsl:text>T</xsl:text>
									<xsl:value-of select="substring($element/@value,9,2)"/>
									<xsl:text>:</xsl:text>
									<xsl:value-of select="substring($element/@value,11,2)"/>
									<xsl:text>:</xsl:text>
									<xsl:value-of select="substring($element/@value,13)"/>
								</xsl:if>
							</xsl:variable>
							<xsl:attribute name="datetime">
								<xsl:value-of select="$time_string"/>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="string-length($time_string) &gt;= 19">
									<xsl:value-of select="substring-before($time_string,'T')"/>
									<xsl:text> </xsl:text>
									<xsl:value-of select="substring-after($time_string,'T')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$time_string"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$element/@value"/>
						</xsl:otherwise>
					</xsl:choose>
				</time>
				<!-- Actually from IVXB_TS, but it'll work ok here -->
				<xsl:if test="$element/@inclusive and ($element/@inclusive = 'false')">
					<xsl:text> (exclusive)</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- END:   ITS Data Types -->

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
