<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.couchbase.com/xsl/extension-functions"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="fn xi">

	<xsl:output method="xml" indent="yes"/>
	
	<xsl:include href="util.xslt"/>
	<xsl:include href="content.xslt"/>
	
	<xsl:template match="h1">
		<xsl:param name="level-1-element-name" required="yes"/>
		<xsl:param name="level-2-element-name" required="yes"/>
		<xsl:param name="level-3-element-name" required="yes"/>
		<xsl:param name="level-2-property-name" required="yes"/>
		<xsl:param name="level-3-property-name" required="yes"/>
		
		<xsl:result-document href="{concat($output-directory, fn:create-id(.), '/guide.xml')}">
			<xsl:element name="{$level-1-element-name}">
				<xsl:attribute name="id" select="fn:create-id(.)"/>
				<xsl:attribute name="title" select="."/>
				
				<xsl:namespace name="xi">http://www.w3.org/2001/XInclude</xsl:namespace>
				
				<xsl:variable name="level-1-index" select="count(self::h1 | preceding-sibling::h1)"/>
				<xsl:variable name="level-2-index" select="count(self::h2 | preceding-sibling::h2)"/>
				<xsl:variable name="level-3-index" select="count(self::h3 | preceding-sibling::h3)"/>
				<xsl:variable name="level-4-index" select="count(self::h4 | preceding-sibling::h4)"/>
				<xsl:variable name="level-5-index" select="count(self::h5 | preceding-sibling::h5)"/>
				
				<introduction>
					<xsl:apply-templates select="following-sibling::*[count(self::h1 | preceding-sibling::h1) = $level-1-index and count(self::h2 | preceding-sibling::h2) = $level-2-index and count(self::h3 | preceding-sibling::h3) = $level-3-index and count(self::h4 | preceding-sibling::h4) = $level-4-index and count(self::h5 | preceding-sibling::h5) = $level-5-index]"/>
				</introduction>
				
				<xsl:variable name="level-2" select="following-sibling::h2[count(self::h1 | preceding-sibling::h1) = $level-1-index]"/>
				<xsl:if test="$level-2">
					<xsl:element name="{$level-2-property-name}">
						<xsl:apply-templates select="$level-2">
							<xsl:with-param name="level-2-element-name" select="$level-2-element-name"/>
							<xsl:with-param name="level-3-element-name" select="$level-3-element-name"/>
							<xsl:with-param name="level-2-property-name" select="$level-2-property-name"/>
							<xsl:with-param name="level-3-property-name" select="$level-3-property-name"/>
						</xsl:apply-templates>
					</xsl:element>
				</xsl:if>
			</xsl:element>
		</xsl:result-document>
	</xsl:template>
	
	<xsl:template match="h2">
		<xsl:param name="level-2-element-name" required="yes"/>
		<xsl:param name="level-3-element-name" required="yes"/>
		<xsl:param name="level-2-property-name" required="yes"/>
		<xsl:param name="level-3-property-name" required="yes"/>
		
		<xsl:variable name="file-name" select="concat(fn:create-id(.), '.xml')"/>
		
		<xsl:element name="include">
			<xsl:namespace name="xi">http://www.w3.org/2001/XInclude</xsl:namespace>
			
			<xsl:attribute name="href" select="$file-name"/>
		</xsl:element>
		
		<xsl:result-document href="{concat($output-directory, fn:create-id(preceding-sibling::h1), '/', $file-name)}">
			<xsl:element name="{$level-2-element-name}">
				<xsl:attribute name="id" select="fn:create-id(.)"/>
				<xsl:attribute name="title" select="."/>
				
				<xsl:variable name="level-1-index" select="count(self::h1 | preceding-sibling::h1)"/>
				<xsl:variable name="level-2-index" select="count(self::h2 | preceding-sibling::h2)"/>
				<xsl:variable name="level-3-index" select="count(self::h3 | preceding-sibling::h3)"/>
				<xsl:variable name="level-4-index" select="count(self::h4 | preceding-sibling::h4)"/>
				<xsl:variable name="level-5-index" select="count(self::h5 | preceding-sibling::h5)"/>
				
				<introduction>
					<xsl:apply-templates select="following-sibling::*[count(self::h1 | preceding-sibling::h1) = $level-1-index and count(self::h2 | preceding-sibling::h2) = $level-2-index and count(self::h3 | preceding-sibling::h3) = $level-3-index and count(self::h4 | preceding-sibling::h4) = $level-4-index and count(self::h5 | preceding-sibling::h5) = $level-5-index]"/>
				</introduction>
				
				<xsl:variable name="level-3" select="following-sibling::h3[count(self::h1 | preceding-sibling::h1) = $level-1-index and count(self::h2 | preceding-sibling::h2) = $level-2-index]"/>
				<xsl:if test="$level-3">
					<xsl:element name="{$level-3-property-name}">
						<xsl:apply-templates select="$level-3">
							<xsl:with-param name="level-3-element-name" select="$level-3-element-name"/>
						</xsl:apply-templates>
					</xsl:element>
				</xsl:if>
			</xsl:element>
		</xsl:result-document>
	</xsl:template>
	
	<xsl:template match="h3">
		<xsl:param name="level-3-element-name" required="yes"/>
		
		<xsl:element name="{$level-3-element-name}">
			<xsl:attribute name="id" select="fn:create-id(.)"/>
			<xsl:attribute name="title" select="."/>
			
			<xsl:variable name="level-1-index" select="count(self::h1 | preceding-sibling::h1)"/>
			<xsl:variable name="level-2-index" select="count(self::h2 | preceding-sibling::h2)"/>
			<xsl:variable name="level-3-index" select="count(self::h3 | preceding-sibling::h3)"/>
			<xsl:variable name="level-4-index" select="count(self::h4 | preceding-sibling::h4)"/>
			<xsl:variable name="level-5-index" select="count(self::h5 | preceding-sibling::h5)"/>
			
			<xsl:apply-templates select="following-sibling::*[count(self::h1 | preceding-sibling::h1) = $level-1-index and count(self::h2 | preceding-sibling::h2) = $level-2-index and count(self::h3 | preceding-sibling::h3) = $level-3-index and count(self::h4 | preceding-sibling::h4) = $level-4-index and count(self::h5 | preceding-sibling::h5) = $level-5-index]
				| following-sibling::h4[count(self::h1 | preceding-sibling::h1) = $level-1-index and count(self::h2 | preceding-sibling::h2) = $level-2-index and count(self::h3 | preceding-sibling::h3) = $level-3-index]"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="h4">
		<section id="{fn:create-id(.)}" title="{.}">
			<xsl:variable name="level-1-index" select="count(self::h1 | preceding-sibling::h1)"/>
			<xsl:variable name="level-2-index" select="count(self::h2 | preceding-sibling::h2)"/>
			<xsl:variable name="level-3-index" select="count(self::h3 | preceding-sibling::h3)"/>
			<xsl:variable name="level-4-index" select="count(self::h4 | preceding-sibling::h4)"/>
			<xsl:variable name="level-5-index" select="count(self::h5 | preceding-sibling::h5)"/>
			
			<xsl:apply-templates select="following-sibling::*[count(self::h1 | preceding-sibling::h1) = $level-1-index and count(self::h2 | preceding-sibling::h2) = $level-2-index and count(self::h3 | preceding-sibling::h3) = $level-3-index and count(self::h4 | preceding-sibling::h4) = $level-4-index and count(self::h5 | preceding-sibling::h5) = $level-5-index]
				| following-sibling::h5[count(self::h1 | preceding-sibling::h1) = $level-1-index and count(self::h2 | preceding-sibling::h2) = $level-2-index and count(self::h3 | preceding-sibling::h3) = $level-3-index and count(self::h4 | preceding-sibling::h4) = $level-4-index]"/>
		</section>
	</xsl:template>
	
	<xsl:template match="h5">
		<subsection id="{fn:create-id(.)}" title="{.}">
			<xsl:variable name="level-1-index" select="count(self::h1 | preceding-sibling::h1)"/>
			<xsl:variable name="level-2-index" select="count(self::h2 | preceding-sibling::h2)"/>
			<xsl:variable name="level-3-index" select="count(self::h3 | preceding-sibling::h3)"/>
			<xsl:variable name="level-4-index" select="count(self::h4 | preceding-sibling::h4)"/>
			<xsl:variable name="level-5-index" select="count(self::h5 | preceding-sibling::h5)"/>
			
			<xsl:apply-templates select="following-sibling::*[count(self::h1 | preceding-sibling::h1) = $level-1-index and count(self::h2 | preceding-sibling::h2) = $level-2-index and count(self::h3 | preceding-sibling::h3) = $level-3-index and count(self::h4 | preceding-sibling::h4) = $level-4-index and count(self::h5 | preceding-sibling::h5) = $level-5-index]"/>
		</subsection>
	</xsl:template>
	
	<xsl:function name="fn:create-id">
		<xsl:param name="title"/>
		
		<xsl:value-of select="lower-case(replace($title, '[^a-zA-Z0-9_]', '-'))"/>
	</xsl:function>
</xsl:stylesheet>