<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.couchbase.com/xsl/extension-functions"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="fn xi xsi">

	<xsl:output method="xml" indent="yes"/>
	
	<xsl:include href="util.xslt"/>
	<xsl:include href="content.xslt"/>
	
	<xsl:template match="class">
		<!-- Merge the docs.  This allows processing as one large doc irregardless of whether
			 the docs are physically split (which is the way they are written). -->
		<xsl:variable name="docs">
			<xsl:for-each select="doc/*">
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:apply-templates select="$docs/h1">
			<xsl:with-param name="level-1-element-name">class</xsl:with-param>
			<xsl:with-param name="level-2-element-name">lesson</xsl:with-param>
			<xsl:with-param name="level-3-element-name">task</xsl:with-param>
			
			<xsl:with-param name="level-2-property-name">classes</xsl:with-param>
			<xsl:with-param name="level-3-property-name">lessons</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="guide">
		<!-- Merge the docs.  See 'class' for more info. -->
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
	
	<xsl:template match="h1">
		<xsl:param name="level-1-element-name" required="yes"/>
		<xsl:param name="level-2-element-name" required="yes"/>
		<xsl:param name="level-3-element-name" required="yes"/>
		<xsl:param name="level-2-property-name" required="yes"/>
		<xsl:param name="level-3-property-name" required="yes"/>
		
		<xsl:variable name="directory-path" select="concat($output-directory, fn:create-id(.))"/>
		
		<xsl:result-document href="{concat($directory-path, '/', $level-1-element-name, '.xml')}">
			<xsl:element name="{$level-1-element-name}">
				<xsl:namespace name="xi">http://www.w3.org/2001/XInclude</xsl:namespace>
				<xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
				
				<xsl:attribute name="id" select="fn:create-id(.)"/>
				<xsl:attribute name="title" select="."/>
				<xsl:attribute name="description">TODO: Add description.</xsl:attribute>
				
				<xsl:attribute name="xsi:noNamespaceSchemaLocation" select="fn:root-path($directory-path, 'docs.xsd')"/>
				
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
		
		<xsl:variable name="directory-path" select="concat($output-directory, fn:create-id(preceding-sibling::h1))"/>
		<xsl:variable name="file-name" select="concat(fn:create-id(.), '.xml')"/>
		
		<xsl:element name="xi:include">
			<xsl:attribute name="href" select="$file-name"/>
		</xsl:element>
		
		<xsl:result-document href="{concat($directory-path, '/', $file-name)}">
			<xsl:element name="{$level-2-element-name}">
				<xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
				
				<xsl:attribute name="id" select="fn:create-id(.)"/>
				<xsl:attribute name="title" select="."/>
				<xsl:attribute name="description">TODO: Add description.</xsl:attribute>
				
				<xsl:attribute name="xsi:noNamespaceSchemaLocation" select="fn:root-path($directory-path, 'docs.xsd')"/>
				
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
		<subsection title="{.}">
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