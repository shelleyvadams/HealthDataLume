<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cldoc="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output method="html" indent="yes" />

	<xsl:template match="cldoc:ClinicalDocument">
		<html>
			<head>
				<title><xsl:value-of select="cldoc:title"/></title>
				<style type="text/css">
				<![CDATA[
					body {
						font-family:sans-serif;
					}
				]]>
				</style>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
