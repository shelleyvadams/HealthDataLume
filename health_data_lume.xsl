<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">
	<xsl:output method="html" indent="yes" version="5" omit-xml-declaration="yes" media-type="text/html"/>

	<xsl:template match="hl7:ClinicalDocument">
		<header>
			<h1><xsl:value-of select="hl7:title"/></h1>
		</header>
		<xsl:apply-templates/>
	</xsl:template>

</xsl:stylesheet>
