<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" indent="yes"/>
	
	<xsl:include href="doc.xslt"/>
	
	<xsl:template match="guide">
		<!-- Merge the docs.  This allows processing as one large doc irregardless of whether
			 the docs are physically split (which is the way they are written). -->
		<xsl:variable name="docs">
			<xsl:for-each select="doc/*">
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:apply-templates select="$docs/h1">
			<xsl:with-param name="level-1-element-name">guide</xsl:with-param>
			<xsl:with-param name="level-2-element-name">article</xsl:with-param>
			<xsl:with-param name="level-3-element-name">topic</xsl:with-param>
			
			<xsl:with-param name="level-2-property-name">articles</xsl:with-param>
			<xsl:with-param name="level-3-property-name">topics</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>