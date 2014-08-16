<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">
	<xsl:output method="html" indent="yes" version="5" omit-xml-declaration="yes" media-type="text/html"/>

	<xsl:template match="hl7:ClinicalDocument">
		<xsl:apply-templates select="hl7:languageCode/@code"/>
		<header>
			<div class="row">
				<div class="col-md-8">
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
				</div>
				<div class="col-md-4">
					<xsl:apply-templates select="hl7:confidentialityCode"/>
				</div>
			</div>

			<div class="row">
				<div class="col-md-6 col-lg-8">
					<xsl:apply-templates select="hl7:recordTarget"/>

					<xsl:apply-templates select="hl7:effectiveTime"/>
				</div>
				<div class="col-md-6 col-lg-4">
					<section class="panel-group" id="headerEntities">
						<xsl:apply-templates select="hl7:custodian"/>
						<xsl:for-each select="hl7:author">
							<section class="panel panel-default">
								<header class="panel-heading">
									<h2 class="panel-title" data-toggle="collapse" data-parent="#headerEntities">
										<xsl:attribute name="data-target">
											<xsl:text>#headerEntities .</xsl:text>
											<xsl:value-of select="local-name()"/>
											<xsl:value-of select="position()"/>
										</xsl:attribute>
										<xsl:text>Author </xsl:text>
										<xsl:value-of select="position()"/>
									</h2>
								</header>
								<div>
									<xsl:attribute name="class">
										<xsl:text>panel-collapse collapse </xsl:text>
										<xsl:value-of select="local-name()"/>
										<xsl:value-of select="position()"/>
									</xsl:attribute>
									<div class="panel-body">
										<xsl:apply-templates select="current()"/>
									</div>
								</div>
							</section>
						</xsl:for-each>
						<xsl:apply-templates select="hl7:dataEnterer"/>
						<xsl:apply-templates select="hl7:legalAuthenticator"/>
						<xsl:apply-templates select="hl7:authenticator"/>
						<xsl:apply-templates select="hl7:participant"/>
						<xsl:for-each select="hl7:informant">
							<section class="panel panel-default">
								<header class="panel-heading">
									<h2 class="panel-title" data-toggle="collapse" data-parent="#headerEntities">
										<xsl:attribute name="data-target">
											<xsl:text>#headerEntities .</xsl:text>
											<xsl:value-of select="local-name()"/>
											<xsl:value-of select="position()"/>
										</xsl:attribute>
										<xsl:text>Informant </xsl:text>
										<xsl:value-of select="position()"/>
									</h2>
								</header>
								<div>
									<xsl:attribute name="class">
										<xsl:text>panel-collapse collapse </xsl:text>
										<xsl:value-of select="local-name()"/>
										<xsl:value-of select="position()"/>
									</xsl:attribute>
									<div class="panel-body">
										<xsl:apply-templates select="current()"/>
									</div>
								</div>
							</section>
						</xsl:for-each>
						<xsl:apply-templates select="hl7:informationRecipient"/>
					</section>
				</div>
			</div>
		</header>


		<xsl:apply-templates select="hl7:inFulfillmentOf"/>

		<xsl:apply-templates select="hl7:documentationOf"/>
		<xsl:apply-templates select="hl7:relatedDocument"/>
		<xsl:apply-templates select="hl7:componentOf"/>

		<xsl:apply-templates select="hl7:authorization"/>

		<xsl:apply-templates select="hl7:component"/>

		<footer>
			<xsl:call-template name="document-info"/>
		</footer>
	</xsl:template>

	<!--  *******************************************  -->
	<!--  *******************************************  -->

	<xsl:template match="@language|hl7:languageCode/@code">
		<xsl:attribute name="lang">
			<xsl:value-of select="current()"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="hl7:addr">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="./@use"/>
				<address>
					<xsl:for-each select="hl7:delimiter|hl7:country|hl7:state|hl7:county|hl7:city|hl7:postalCode|hl7:streetAddressLine|hl7:houseNumber|hl7:houseNumberNumeric|hl7:direction|hl7:streetName|hl7:streetNameBase|hl7:streetNameType|hl7:additionalLocator|hl7:unitID|hl7:unitType|hl7:careOf|hl7:censusTract|hl7:deliveryAddressLine|hl7:deliveryInstallationType|hl7:deliveryInstallationArea|hl7:deliveryInstallationQualifier|hl7:deliveryMode|hl7:deliveryModeIdentifier|hl7:buildingNumberSuffix|hl7:postBox|hl7:precinct">
						<xsl:apply-templates select="current()"/>
						<xsl:text> </xsl:text>
					</xsl:for-each>
				</address>
				<xsl:apply-templates select="useablePeriod"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="hl7:administrationUnitCode|hl7:awarenessCode|hl7:dischargeDispositionCode|hl7:ethnicGroupCode|hl7:functionCode|hl7:interpretationCode|hl7:maritalStatusCode|hl7:methodCode|hl7:modeCode|hl7:priorityCode|hl7:proficiencyLevelCode|hl7:raceCode|hl7:religiousAffiliationCode|hl7:routeCode|hl7:standardIndustryClassCode">
		<div>
			<xsl:call-template name="set-classes"/>
			<xsl:call-template name="CD"/>
		</div>
	</xsl:template>

	<xsl:template match="hl7:assignedAuthoringDevice|hl7:playingDevice">
		<section>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:softwareName"/>
					<xsl:apply-templates select="hl7:manufacturerModelName"/>
					<xsl:apply-templates select="hl7:code"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:assignedEntity|hl7:associatedEntity">
		<section>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:assignedPerson|hl7:associatedPerson"/>
					<xsl:apply-templates select="hl7:code"/>
					<xsl:apply-templates select="hl7:id"/>
					<xsl:apply-templates select="hl7:representedOrganization|hl7:scopingOrganization"/>
					<xsl:apply-templates select="hl7:telecom"/>
					<xsl:apply-templates select="hl7:addr"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:assignedPerson|hl7:associatedPerson|hl7:guardianPerson|hl7:intendedRecipient/hl7:informationRecipient|hl7:relatedPerson">
		<div>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:name" mode="PN"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="hl7:authenticator|hl7:legalAuthenticator">
		<section>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:text>panel panel-default</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<header class="panel-heading">
						<h2 class="panel-title" data-toggle="collapse" data-parent="#headerEntities">
							<xsl:attribute name="data-target">
								<xsl:text>#headerEntities .</xsl:text>
								<xsl:value-of select="local-name()"/>
								<xsl:value-of select="position()"/>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="local-name() = 'legalAuthenticator'">
									<xsl:text>Legal Authenticator</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>Authenticator </xsl:text>
									<xsl:value-of select="position()"/>
								</xsl:otherwise>
							</xsl:choose>
						</h2>
					</header>
					<div>
						<xsl:attribute name="class">
							<xsl:text>panel-collapse collapse </xsl:text>
							<xsl:value-of select="local-name()"/>
							<xsl:value-of select="position()"/>
						</xsl:attribute>
						<div class="panel-body">
							<xsl:apply-templates select="hl7:assignedEntity"/>
							<xsl:apply-templates select="hl7:signatureCode"/>
							<xsl:apply-templates select="hl7:time" mode="TS"/>
						</div>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:author">
		<div>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:call-template name="build-class-string">
						<xsl:with-param name="toBuildFrom" select="hl7:assignedAuthor"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<div class="alert alert-warning">
						<strong><xsl:text>No author:</xsl:text></strong>
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="./@nullFlavor"/>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="hl7:assignedAuthor/@nullFlavor">
							<p>
								<strong><xsl:text>No author assigned</xsl:text></strong>
								<xsl:text> (</xsl:text>
								<xsl:apply-templates select="hl7:assignedAuthor/@nullFlavor"/>
								<xsl:text>)</xsl:text>
							</p>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="hl7:assignedAuthor/hl7:code"/>
							<xsl:apply-templates select="hl7:assignedAuthor/hl7:assignedPerson|hl7:assignedAuthor/hl7:assignedAuthoringDevice"/>
							<xsl:apply-templates select="hl7:assignedAuthor/hl7:id"/>
							<xsl:apply-templates select="hl7:assignedAuthor/hl7:representedOrganization"/>
							<xsl:apply-templates select="hl7:assignedAuthor/hl7:addr"/>
							<xsl:apply-templates select="hl7:assignedAuthor/hl7:telecom"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates select="hl7:functionCode"/>
					<xsl:apply-templates select="hl7:time" mode="TS"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
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

	<xsl:template match="hl7:birthTime">
		<xsl:call-template name="TS"/>
	</xsl:template>

	<xsl:template match="hl7:code">
		<div class="code"><xsl:call-template name="CD"/></div>
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

	<xsl:template match="hl7:structuredBody/hl7:component">
	<section>
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:section"/>
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
					<xsl:text> </xsl:text>
					<xsl:call-template name="build-class-string">
						<xsl:with-param name="toBuildFrom" select="hl7:assignedCustodian/hl7:representedCustodianOrganization"/>
					</xsl:call-template>
					<xsl:text> panel panel-default</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:when test="hl7:assignedCustodian/@nullFlavor">
					<xsl:apply-templates select="hl7:assignedCustodian/@nullFlavor"/>
				</xsl:when>
				<xsl:when test="hl7:assignedCustodian/hl7:representedCustodianOrganization/@nullFlavor">
					<xsl:apply-templates select="hl7:assignedCustodian/hl7:representedCustodianOrganization/@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<header class="panel-heading">
						<h2 class="panel-title" data-toggle="collapse" data-parent="#headerEntities" data-target="#custodianDetails">
							<xsl:text>Custodian</xsl:text>
						</h2>
					</header>
					<div class="panel-collapse collapse" id="custodianDetails">
						<div class="panel-body">
							<xsl:if test="hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:name">
								<h3><xsl:apply-templates select="hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:name"/></h3>
							</xsl:if>
							<xsl:apply-templates select="hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:id"/>
							<xsl:apply-templates select="hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:telecom"/>
							<xsl:apply-templates select="hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:addr"/>
						</div>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:dataEnterer">
		<section>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:text> panel panel-default</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<header class="panel-heading">
				<h2 class="panel-title" data-toggle="collapse" data-parent="#headerEntities" data-target="#dataEntererDetails">
					<xsl:text>Data Enterer</xsl:text>
				</h2>
			</header>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<div class="panel-collapse collapse" id="dataEntererDetails">
						<div class="panel-body">
							<xsl:apply-templates select="hl7:assignedEntity"/>
							<xsl:apply-templates select="hl7:time" mode="TS"/>
						</div>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:desc|hl7:text|hl7:observationMedia/hl7:value">
		<section>
			<xsl:call-template name="set-classes"/>
			<xsl:call-template name="ED"/>
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

	<xsl:template match="hl7:effectiveTime|hl7:expectedUseTime|hl7:time">
		<div>
			<xsl:call-template name="set-classes"/>
			<xsl:call-template name="IVL_TS"/>
		</div>
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

	<xsl:template match="hl7:encounterParticipant">
		<section>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:assignedEntity"/>
					<xsl:apply-templates select="hl7:time"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
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

	<xsl:template match="hl7:guardianOrganization|hl7:manufacturerOrganization|hl7:providerOrganization|hl7:receivedOrganization|hl7:representedOrganization|hl7:scopingOrganization|hl7:serviceProviderOrganization|hl7:wholeOrganization">
		<details>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<summary>
						<xsl:apply-templates select="hl7:name" mode="ON"/>
					</summary>
					<div>
						<xsl:apply-templates select="hl7:asOrganizationPartOf"/>
						<xsl:apply-templates select="hl7:id"/>
						<xsl:apply-templates select="hl7:telecom"/>
						<xsl:apply-templates select="hl7:addr"/>
						<xsl:apply-templates select="hl7:standardIndustryClassCode"/>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</details>
	</xsl:template>

	<xsl:template match="hl7:id">
		<div class="id">
			<strong>
				<xsl:text>ID: </xsl:text>
			</strong>
			<xsl:call-template name="II"/>
		</div>
	</xsl:template>

	<xsl:template match="hl7:informant">
		<div>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:assignedEntity|hl7:relatedEntity"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="hl7:ClinicalDocument/hl7:informationRecipient">
		<section>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:call-template name="build-class-string">
						<xsl:with-param name="toBuildFrom" select="hl7:intendedRecipient"/>
					</xsl:call-template>
					<xsl:text> panel panel-default</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<header class="panel-heading">
				<h2 class="panel-title" data-toggle="collapse" data-parent="#headerEntities">
					<xsl:attribute name="data-target">
						<xsl:text>#headerEntities .</xsl:text>
						<xsl:value-of select="local-name()"/>
						<xsl:value-of select="position()"/>
					</xsl:attribute>
					<xsl:text>Information Recipient </xsl:text>
					<xsl:value-of select="position()"/>
				</h2>
			</header>
			<div>
				<xsl:attribute name="class">
					<xsl:text>panel-collapse collapse </xsl:text>
					<xsl:value-of select="local-name()"/>
					<xsl:value-of select="position()"/>
				</xsl:attribute>
				<div class="panel-body">
					<xsl:choose>
						<xsl:when test="./@nullFlavor">
							<xsl:apply-templates select="./@nullFlavor"/>
						</xsl:when>
						<xsl:when test="hl7:intendedRecipient/@nullFlavor">
							<xsl:apply-templates select="hl7:intendedRecipient/@nullFlavor"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="hl7:intendedRecipient/hl7:informationRecipient"/>
							<xsl:apply-templates select="hl7:intendedRecipient/hl7:receivedOrganization"/>
							<xsl:apply-templates select="hl7:intendedRecipient/hl7:id"/>
							<xsl:apply-templates select="hl7:intendedRecipient/hl7:telecom"/>
							<xsl:apply-templates select="hl7:intendedRecipient/hl7:addr"/>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
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

	<xsl:template match="hl7:languageCode|hl7:realmCode|hl7:signatureCode|hl7:statusCode">
		<div>
			<xsl:call-template name="set-classes"/>
			<xsl:call-template name="CS"/>
		</div>
	</xsl:template>

	<xsl:template match="hl7:encompassingEncounter/hl7:location">
		<section>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">	
					<xsl:call-template name="build-class-string">
						<xsl:with-param name="toBuildFrom" select="hl7:healthCareFacility"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:when test="hl7:healthCareFacility/@nullFlavor">
					<xsl:apply-templates select="hl7:healthCareFacility/@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:healthCareFacility/hl7:code"/>
					<xsl:apply-templates select="hl7:healthCareFacility/hl7:id"/>
					<xsl:apply-templates select="hl7:healthCareFacility/hl7:location"/>
					<xsl:apply-templates select="hl7:healthCareFacility/hl7:serviceProviderOrganization"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:nonXMLBody|hl7:structuredBody">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="hl7:languageCode/@code"/>
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
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:text>panel panel-default</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<header class="panel-heading">
				<h2 class="panel-title" data-toggle="collapse" data-parent="#headerEntities">
					<xsl:attribute name="data-target">
						<xsl:text>#headerEntities .</xsl:text>
						<xsl:value-of select="local-name()"/>
						<xsl:value-of select="position()"/>
					</xsl:attribute>
					<xsl:text>Participant </xsl:text>
					<xsl:value-of select="position()"/>
				</h2>
			</header>
			<div>
				<xsl:attribute name="class">
					<xsl:text>panel-collapse collapse </xsl:text>
					<xsl:value-of select="local-name()"/>
					<xsl:value-of select="position()"/>
				</xsl:attribute>
				<div class="panel-body">
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
				</div>
			</div>
		</section>
	</xsl:template>

	<xsl:template match="hl7:performer">
		<section>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:assignedEntity"/>
					<xsl:apply-templates select="hl7:functionCode|hl7:modeCode"/>
					<xsl:apply-templates select="hl7:time"/>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>

	<xsl:template match="hl7:recordTarget">
		<section>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:call-template name="build-class-string">
						<xsl:with-param name="toBuildFrom" select="hl7:patientRole"/>
					</xsl:call-template>
					<xsl:if test="hl7:patientRole/hl7:patient">
						<xsl:text> </xsl:text>
						<xsl:call-template name="build-class-string">
							<xsl:with-param name="toBuildFrom" select="hl7:patientRole/hl7:patient"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:when test="hl7:patientRole/@nullFlavor">
					<xsl:apply-templates select="hl7:patientRole/@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<header>
						<xsl:choose>
							<xsl:when test="hl7:patientRole/hl7:patient/@nullFlavor">
								<xsl:apply-templates select="hl7:patientRole/hl7:patient/@nullFlavor"/>
							</xsl:when>
							<xsl:otherwise>
								<h2><xsl:apply-templates select="hl7:patientRole/hl7:patient/hl7:name" mode="PN"/></h2>
								<xsl:apply-templates select="hl7:patientRole/hl7:patient/hl7:administrativeGenderCode"/>
								<xsl:if test="hl7:patientRole/hl7:patient/hl7:birthTime">
									<p>
										<xsl:text>DOB: </xsl:text>
										<xsl:apply-templates select="hl7:patientRole/hl7:patient/hl7:birthTime"/>
									</p>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</header>
					<xsl:apply-templates select="hl7:patientRole/hl7:patient/hl7:birthplace"/>
					<xsl:apply-templates select="hl7:patientRole/hl7:patient/hl7:languageCommunication"/>
					<xsl:apply-templates select="hl7:patientRole/hl7:patient/hl7:maritalStatusCode"/>
					<xsl:apply-templates select="hl7:patientRole/hl7:patient/hl7:ethnicGroupCode"/>
					<xsl:apply-templates select="hl7:patientRole/hl7:patient/hl7:raceCode"/>
					<xsl:apply-templates select="hl7:patientRole/hl7:patient/hl7:religiousAffiliationCode"/>
					<xsl:apply-templates select="hl7:patientRole/hl7:patient/hl7:guardian"/>
					<xsl:apply-templates select="hl7:patientRole/hl7:id"/>
					<xsl:apply-templates select="hl7:patientRole/hl7:telecom"/>
					<xsl:apply-templates select="hl7:patientRole/hl7:addr"/>
					<xsl:apply-templates select="hl7:patientRole/hl7:providerOrganization"/>
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

	<xsl:template match="hl7:responsibleParty">
		<section>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="hl7:assignedEntity"/>
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

	<xsl:template match="hl7:setId">
		<span>
			<xsl:call-template name="set-classes"/>
			<strong>
				<xsl:text>Set: </xsl:text>
			</strong>
			<xsl:call-template name="II"/>
		</span>
	</xsl:template>

	<xsl:template match="hl7:telecom">
		<div>
			<xsl:call-template name="set-classes"/>
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="./@use">
						<strong><xsl:apply-templates select="./@use"/></strong>
						<xsl:text> </xsl:text>
					</xsl:if>
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="./@value"/>
						</xsl:attribute>
						<xsl:attribute name="target">
							<xsl:text>_blank</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="./@value"/>
					</a>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="hl7:useablePeriod"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="hl7:time" mode="TS">
		<xsl:call-template name="TS"/>
	</xsl:template>

	<xsl:template match="hl7:useablePeriod">
		<xsl:text>Useable: </xsl:text>
		<xsl:call-template name="IVL_TS"/>
	</xsl:template>

	<xsl:template match="hl7:versionNumber">
		<span>
			<xsl:call-template name="set-classes"/>
			<xsl:text>version </xsl:text>
			<xsl:call-template name="INT"/>
		</span>
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
					<xsl:apply-templates select="hl7:code"/>
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
					<xsl:if test="hl7:translation">
						<a data-toggle="collapse">
							<xsl:attribute name="href">
								<xsl:text>#translationsFor</xsl:text>
								<xsl:value-of select="./@code"/>
							</xsl:attribute>
							<i class="fa fa-caret-square-o-down"></i>
							<span class="sr-only"> toggle list</span>
						</a>
						<ul class="collapse"><!-- SET[CD] -->
							<xsl:attribute name="id">
								<xsl:text>translationsFor</xsl:text>
								<xsl:value-of select="./@code"/>
							</xsl:attribute>
							<xsl:for-each select="hl7:translation">
								<li><xsl:call-template name="CD"/></li>
							</xsl:for-each>
						</ul>
					</xsl:if>
				</div>
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

	<xsl:template match="hl7:originalText">
		<xsl:call-template name="ED"/>
	</xsl:template>

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

	<!-- BEGIN: Encapsulated Data -->
	<xsl:template name="ED">
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<xsl:apply-templates select="./@nullFlavor"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="url">
						<xsl:choose>
							<xsl:when test="hl7:reference/@value">
								<xsl:value-of select="hl7:reference/@value"/>
							</xsl:when>
							<xsl:when test="(./@representation = 'B64') and ./@mediaType">
								<xsl:text>data:</xsl:text>
								<xsl:value-of select="./@mediaType"/>
								<xsl:text>;base64,</xsl:text>
								<xsl:value-of select="current()"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="hl7:thumbnail">
							<a>
								<xsl:if test="./@mediaType">
									<xsl:attribute name="type">
										<xsl:value-of select="./@mediaType"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="href">
									<xsl:value-of select="$url"/>
								</xsl:attribute>
								<xsl:apply-templates select="hl7:thumbnail"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="starts-with($url,'#')">
									<xsl:apply-templates select="//*[@ID=substring($url,2)]" mode="fromReference"/>
								</xsl:when>
								<xsl:when test="./@mediaType = 'image/png' or ./@mediaType = 'image/jpeg' or ./@mediaType = 'image/gif' or ./@mediaType = 'image/tiff'">
									<img>
										<xsl:attribute name="src">
											<xsl:value-of select="$url"/>
										</xsl:attribute>
									</img>
								</xsl:when>
								<xsl:when test="./@mediaType = 'audio/basic' or ./@mediaType = 'audio/mpeg' or ./@mediaType = 'audio/k32adpcm'">
									<audio controls="controls">
										<source>
											<xsl:attribute name="src">
												<xsl:value-of select="$url"/>
											</xsl:attribute>
											<xsl:attribute name="type">
												<xsl:value-of select="./@mediaType"/>
											</xsl:attribute>
										</source>
									</audio>
								</xsl:when>
								<xsl:when test="./@mediaType = 'video/mpeg'">
									<video controls="controls">
										<source>
											<xsl:attribute name="src">
												<xsl:value-of select="$url"/>
											</xsl:attribute>
											<xsl:attribute name="type">
												<xsl:value-of select="./@mediaType"/>
											</xsl:attribute>
										</source>
									</video>
								</xsl:when>
								<xsl:when test="./@mediaType = 'text/plain'">
									<pre><xsl:value-of select="current()"/></pre>
								</xsl:when>
								<xsl:when test="./@mediaType = 'text/html'">
									<iframe>
										<xsl:attribute name="src">
											<xsl:value-of select="$url"/>
										</xsl:attribute>
									</iframe>
								</xsl:when>
								<xsl:when test="not(./@mediaType) and ( not(./@representation) or not(./@representation = 'B64') )">
									<xsl:apply-templates/>
								</xsl:when>
								<xsl:otherwise>
									<p>
										<code><xsl:value-of select="local-name()"/></code>
										<xsl:text> is </xsl:text>
										<code><xsl:value-of select="./@mediaType"/></code>
										<xsl:text> not sure what to do with it.</xsl:text>
										<xsl:if test="string-length($url) &gt; 0">
											<xsl:text> </xsl:text>
											<a>
												<xsl:attribute name="type">
													<xsl:value-of select="./@mediaType"/>
												</xsl:attribute>
												<xsl:attribute name="href">
													<xsl:value-of select="$url"/>
												</xsl:attribute>
												<xsl:text>Here is a link.</xsl:text>
											</a>
										</xsl:if>
									</p>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="hl7:reference/hl7:useablePeriod">
						<p><xsl:apply-templates select="hl7:reference/hl7:useablePeriod"/></p>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>

	<!-- ED.Thumbnail : ED -->
	<xsl:template match="hl7:thumbnail">
		<xsl:call-template name="ED"/>
	</xsl:template>
	<!-- END: Encapsulated Data -->

	<!--  *******************************************  -->

	<!-- Instance Identifier -->
	<xsl:template name="II">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:when test="@displayable = 'false'">
				<xsl:text>Not displayable</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="./@extension and ./@root">
						<xsl:value-of select="./@extension"/>
						<small>
							<xsl:text> within </xsl:text>
							<xsl:value-of select="./@root"/>
						</small>
					</xsl:when>
					<xsl:when test="./@extension">
						<xsl:value-of select="./@extension"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="./@root"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="./@assigningAuthorityName">
					<xsl:text> from </xsl:text>
					<xsl:value-of select="./@assigningAuthorityName"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--  *******************************************  -->

	<!-- Integer Number -->
	<xsl:template name="INT">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<xsl:apply-templates select="./@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<span class="integer quantity">
					<xsl:value-of select="./@value"/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--  *******************************************  -->

	<!-- Interval - Time -->
	<xsl:template name="IVL_TS">
		<xsl:param name="element" select="current()"/>
		<xsl:choose>
			<xsl:when test="$element/@nullFlavor">
				<xsl:apply-templates select="$element/@nullFlavor"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$element/@operator"/>
				<xsl:choose>
					<xsl:when test="$element/@value">
						<xsl:call-template name="TS"/>
					</xsl:when>
					<xsl:when test="$element/hl7:low and not($element/hl7:low/@nullFlavor) and ( $element/hl7:high/@nullFlavor or not($element/hl7:high) )">
<!--
						<xsl:text>from </xsl:text>
-->
						<xsl:call-template name="TS">
							<xsl:with-param name="element" select="$element/hl7:low"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="( $element/hl7:low/@nullFlavor or not($element/hl7:low) ) and $element/hl7:high and not($element/hl7:high/@nullFlavor)">
						<xsl:text>until </xsl:text>
						<xsl:call-template name="TS">
							<xsl:with-param name="element" select="$element/hl7:high"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$element/hl7:low and $element/hl7:high">
						<xsl:call-template name="TS">
							<xsl:with-param name="element" select="$element/hl7:low"/>
						</xsl:call-template>
						<xsl:text> to </xsl:text>
						<xsl:call-template name="TS">
							<xsl:with-param name="element" select="$element/hl7:high"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="( $element/hl7:low/@nullFlavor or not($element/hl7:low) ) and $element/hl7:high">
						<xsl:text>centered at </xsl:text>
						<xsl:call-template name="TS">
							<xsl:with-param name="element" select="$element/hl7:center"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
				<xsl:apply-templates select="$element/hl7:width"/>
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

	<!-- AddressUse [2.16.840.1.113883.5.1119] -->
	<xsl:template match="hl7:addr/@use|hl7:telecom/@use">
		<span class="use_type">
		<xsl:choose>
			<xsl:when test="contains(current(), 'BAD')">
				<i class="fa fa-ban"></i>
				<xsl:text> Bad (do not use)</xsl:text>
			</xsl:when>
			<xsl:when test="contains(current(), 'CONF')">
				<i class="fa fa-lock"></i>
				<xsl:text> Confidential</xsl:text>
			</xsl:when>
			<xsl:when test="contains(current(), 'TMP')">
				<i class="fa fa-clock-o"></i>
				<xsl:text> Temporary</xsl:text>
			</xsl:when>
			<xsl:when test="contains(current(), 'WP')">
				<i class="fa fa-briefcase"></i>
				<span class="sr-only"><xsl:text> Work</xsl:text></span>
			</xsl:when>
			<xsl:when test="contains(current(), 'H')">
				<i class="fa fa-home"></i>
				<span class="sr-only"><xsl:text> Home</xsl:text></span>
			</xsl:when>
			<xsl:when test="contains(current(), 'PHYS')">
				<i class="fa fa-map-marker"></i>
				<span class="sr-only"><xsl:text> Physical address</xsl:text></span>
			</xsl:when>
			<xsl:when test="contains(current(), 'PST')">
				<i class="fa fa-envelope-o"></i>
				<span class="sr-only"><xsl:text> Postal address</xsl:text></span>
			</xsl:when>
			<xsl:when test="contains(current(), 'AS')">
				<xsl:text>Answering service</xsl:text>
			</xsl:when>
			<xsl:when test="contains(current(), 'EC')">
				<xsl:text>Emergency contact</xsl:text>
			</xsl:when>
			<xsl:when test="contains(current(), 'MC')">
				<i class="fa fa-mobile"></i>
				<span class="sr-only"><xsl:text> Mobile</xsl:text></span>
			</xsl:when>
			<xsl:when test="contains(current(), 'PG')">
				<xsl:text>Pager</xsl:text>
			</xsl:when>
			<xsl:when test="contains(current(), 'HP')">
				<span class="fa-stack">
					<i class="fa fa-circle-thin"></i>
					<i class="fa fa-home"></i>
				</span>
				<xsl:text> Primary home</xsl:text>
			</xsl:when>
			<xsl:when test="contains(current(), 'HV')">
				<i class="fa fa-suitcase"></i>
				<xsl:text> Vacation home</xsl:text>
			</xsl:when>
			<xsl:when test="contains(current(), 'DIR')">
				<xsl:text>Direct</xsl:text>
			</xsl:when>
			<xsl:when test="contains(current(), 'PUB')">
				<i class="fa fa-unlock"></i>
				<xsl:text> Public</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="local-name()"/>
				<xsl:text>: </xsl:text>
				<code><xsl:value-of select="current()"/></code>
			</xsl:otherwise>
		</xsl:choose>
		</span>
	</xsl:template>

	<!-- AdministrativeGender [2.16.840.1.113883.5.1] -->
	<xsl:template match="hl7:administrativeGenderCode">
		<xsl:choose>
			<xsl:when test="./@nullFlavor">
				<span class="administrativeGender"><xsl:apply-templates select="./@nullFlavor"/></span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="./@code = 'F'">
						<abbr class="administrativeGender" title="Female">
							<xsl:text>&#9792;</xsl:text><!-- Female symbol (U+2640 Venus) -->
						</abbr>
					</xsl:when>
					<xsl:when test="./@code = 'M'">
						<abbr class="administrativeGender" title="Male">
							<xsl:text>&#9794;</xsl:text><!-- Male symbol (U+2642 Mars) -->
						</abbr>
					</xsl:when>
					<xsl:when test="./@code = 'UN'">
						<abbr class="administrativeGender" title="Undifferentiated">
							<xsl:text>&#9900;</xsl:text><!-- Genderless/Sexless/Asexuality symbol (U+26AA Medium white circle) -->
						</abbr>
					</xsl:when>
					<xsl:otherwise>
						<span class="administrativeGender"><xsl:call-template name="CD"/></span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Confidentiality [2.16.840.1.113883.5.25] -->
	<xsl:template match="hl7:confidentialityCode">
		<aside>
			<xsl:call-template name="set-classes">
				<xsl:with-param name="moreClasses">
					<xsl:choose>
						<xsl:when test="@code = 'U'">
							<xsl:text> alert alert-success</xsl:text>
						</xsl:when>
						<xsl:when test="@code = 'L'">
							<xsl:text> alert alert-info</xsl:text>
						</xsl:when>
						<xsl:when test="@code = 'M' or @code = 'N'">
							<xsl:text> alert alert-warning</xsl:text>
						</xsl:when>
						<xsl:when test="@code = 'R' or @code = 'V'">
							<xsl:text> alert alert-danger</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text> well</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:text> </xsl:text>
			<xsl:choose>
				<xsl:when test="@code = 'U'">
					<i class="fa fa-unlock fa-2x"></i>
					<xsl:text> Unrestricted Confidentiality</xsl:text>
				</xsl:when>
				<xsl:when test="@code = 'L'">
					<i class="fa fa-shield fa-2x"></i>
					<xsl:text> Low Confidentiality</xsl:text>
				</xsl:when>
				<xsl:when test="@code = 'M'">
					<i class="fa fa-key fa-2x"></i>
					<xsl:text> Moderate Confidentiality</xsl:text>
				</xsl:when>
				<xsl:when test="@code = 'N'">
					<i class="fa fa-lock fa-2x"></i>
					<xsl:text> Normal Confidentiality</xsl:text>
				</xsl:when>
				<xsl:when test="@code = 'R'">
					<i class="fa fa-exclamation-circle fa-2x"></i>
					<xsl:text> Restricted Confidentiality</xsl:text>
				</xsl:when>
				<xsl:when test="@code = 'V'">
					<i class="fa fa-exclamation-triangle fa-2x"></i>
					<xsl:text> Very Restricted Confidentiality</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="CD"/>
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
