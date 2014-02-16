<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.couchbase.com/xsl/extension-functions"
                exclude-result-prefixes="fn">

<xsl:param name="output-directory">gen/</xsl:param>

<!-- If expr == true then returns the supplied 'true' othewise returns the supplied 'false'. -->
<xsl:function name="fn:iif">
    <xsl:param name="expr"/>
    <xsl:param name="true"/>
    <xsl:param name="false"/>
    
    <xsl:choose>
        <xsl:when test="$expr">
            <xsl:value-of select="$true"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$false"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>
	
<xsl:function name="fn:trim">
	<xsl:param name="string"/>
	
	<xsl:value-of select="replace($string, '^(\s\n\r)*(.+?)(\s\n\r)*$', '$1')"/>
</xsl:function>
	
<xsl:function name="fn:equals">
	<xsl:param name="node1"/>
	<xsl:param name="node2"/>
	
	<xsl:copy-of select="generate-id($node1) = generate-id($node2)"/>
</xsl:function>

</xsl:stylesheet>