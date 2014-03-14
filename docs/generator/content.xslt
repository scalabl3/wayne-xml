<?xml version="1.0"?>
<!DOCTYPE xml [
  <!ENTITY line-feed "&#10;">
]>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="p">
		<paragraph>
			<xsl:apply-templates select="*|text()"/>
		</paragraph>
	</xsl:template>
	
	<xsl:template match="strong">
		<strong>
			<xsl:apply-templates select="*|text()"/>
		</strong>
	</xsl:template>
	
	<xsl:template match="em">
		<emphasis>
			<xsl:apply-templates select="*|text()"/>
		</emphasis>
	</xsl:template>
	
	<xsl:template match="ol">
		<ordered-list>
			<xsl:apply-templates select="li"/>
		</ordered-list>
	</xsl:template>
	
	<xsl:template match="ul">
		<unordered-list>
			<xsl:apply-templates select="li"/>
		</unordered-list>
	</xsl:template>
	
	<xsl:template match="li">
		<list-item>
			<xsl:apply-templates select="*|text()"/>
		</list-item>
	</xsl:template>
	
	<xsl:template match="pre[code]">
		<code-block>
			<xsl:text>&line-feed;</xsl:text>
			<xsl:apply-templates select="code/(*|text())"/>
		</code-block>
	</xsl:template>
	
	<xsl:template match="code">
		<code>
			<xsl:apply-templates select="*|text()"/>
		</code>
	</xsl:template>
	
	<xsl:template match="div[contains(@class, 'notebox')]">
		<note>
			<xsl:attribute name="type">
				<xsl:choose>
					<xsl:when test="contains(@class, 'tip')">tip</xsl:when>
					<xsl:when test="contains(@class, 'warning')">caution</xsl:when>
					<xsl:otherwise>note</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:apply-templates select="p[1]/following-sibling::*"/>
		</note>
	</xsl:template>
	
	<xsl:template match="img">
		<image href="{@src}">
			<xsl:if test="@alt">
				<xsl:attribute name="alt" select="@alt"/>
			</xsl:if>
			<xsl:if test="@width">
				<xsl:attribute name="width" select="@width"/>
			</xsl:if>
			<xsl:if test="@height">
				<xsl:attribute name="height" select="@height"/>
			</xsl:if>
		</image>
	</xsl:template>
	
	<xsl:template match="a">
		<ref href="{@href}">
			<xsl:if test="starts-with(@href, 'http://')">
				<xsl:attribute name="scope">external</xsl:attribute>
			</xsl:if>
			
			<xsl:value-of select="*|text()"/>
		</ref>
	</xsl:template>
	
	<xsl:template match="table">
		<table>
			<xsl:for-each select="thead">
				<header>
					<xsl:for-each select="tr">
						<row>
							<xsl:for-each select="th">
								<entry>
									<xsl:if test="@colspan">
										<xsl:attribute name="colspan" select="@colspan"/>
									</xsl:if>
									<xsl:if test="@rowspan">
										<xsl:attribute name="rowspan" select="@rowspan"/>
									</xsl:if>
									
									<xsl:value-of select="."/>
								</entry>
							</xsl:for-each>
						</row>
					</xsl:for-each>
				</header>
			</xsl:for-each>
			<xsl:for-each select="tbody">
				<body>
					<xsl:for-each select="tr">
						<row>
							<xsl:for-each select="td">
								<entry>
									<xsl:if test="@colspan">
										<xsl:attribute name="colspan" select="@colspan"/>
									</xsl:if>
									<xsl:if test="@rowspan">
										<xsl:attribute name="rowspan" select="@rowspan"/>
									</xsl:if>
									
									<xsl:apply-templates select="*|text()"/>
								</entry>
							</xsl:for-each>
						</row>
					</xsl:for-each>
				</body>
			</xsl:for-each>
		</table>
	</xsl:template>
	
	<xsl:template match="br">
		<!-- Do nothing.  We don't support br. -->
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:message>
			<xsl:text>Convert Error: </xsl:text>
			<xsl:text>&line-feed;</xsl:text>
			<xsl:text>  Element Not Handled: </xsl:text>
			<xsl:value-of select="name()"/>
			<xsl:text>&line-feed;</xsl:text>
		</xsl:message>
	</xsl:template>
	
</xsl:stylesheet>