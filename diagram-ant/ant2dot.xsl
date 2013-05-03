<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!--

	Create a GraphViz-style dot file describing the relationships of targets
	in an ant build file.

	-->

	<xsl:output
		indent="no"
		method="text"
		omit-xml-declaration="yes"
	/>
	<xsl:strip-space elements="*" />

	<xsl:template match="/">

digraph DataDictionary
{
	node
	[
		shape=record,
		width=0.1,
		height=0.1,
		fontname=Helvetica,
		fontsize=8,
		style=filled,
		fillcolor=lightyellow
	];

	// rankdir=LR;

		<!--

			//center="false";
			//nodesep="0.3";
			//ranksep="0.3 equally";
			//size="40,40";
			//page="8.5,11";
			//ratio=compress;

			edge
			[
				fontname=Helvetica,
				fontsize=8,
				labelfontname=Helvetica,
				labelfontsize=8
			];
		-->

		<xsl:apply-templates select="//target">
			<xsl:sort />
		</xsl:apply-templates>

}
	</xsl:template>

	<!-- ================================================================ -->
	<!-- handle each target                                         -->
	<!-- ================================================================ -->

	<xsl:template match="target">
		/* ********** <xsl:value-of select="@name" /> build target ********** */
		<xsl:call-template name="quote-name">
			<xsl:with-param name="name" select="@name" />
		</xsl:call-template>
		<!-- if this is a top-level target, use a different color -->
		<xsl:if test="@description">
			[ fillcolor= palegreen ]
		</xsl:if> ;
		<!-- connect this target to all its dependencies (if any) -->
		<xsl:if test="@depends">
			<xsl:call-template name="split">
				<xsl:with-param name="parent"  select="@name" />
				<xsl:with-param name="child"   select="@depends" />
				<xsl:with-param name="divider" select="','" />
			</xsl:call-template>
		</xsl:if>
		<!-- targets may also contain calls to other targets -->
		<xsl:if test="antcall">
			<xsl:call-template name="create-link">
				<xsl:with-param name="parent" select="@name" />
				<xsl:with-param name="child"  select="antcall/@target" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- ================================================================ -->
	<!-- Split the passed string into component parts                     -->
	<!-- ================================================================ -->

	<xsl:template name="split">
		<xsl:param name="parent"  select="''" />
		<xsl:param name="child"   select="''" />
		<xsl:param name="divider" select="';'" />
		<xsl:choose>
			<xsl:when test="contains($child,$divider)">
				<xsl:call-template name="create-link">
					<xsl:with-param name="parent" select="$parent" />
					<xsl:with-param name="child"  select="substring-before($child,$divider)" />
				</xsl:call-template>
				<xsl:call-template name="split">
					<xsl:with-param name="parent"  select="$parent"/>
					<xsl:with-param name="child"   select="substring-after($child,$divider)"/>
					<xsl:with-param name="divider" select="$divider"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="create-link">
					<xsl:with-param name="parent" select="$parent" />
					<xsl:with-param name="child"  select="$child" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ================================================================ -->
	<!-- Create a link between the passed parent and child                -->
	<!-- ================================================================ -->

	<xsl:template name="create-link">
		<xsl:param name="parent" select="MissingParent" />
		<xsl:param name="child"  select="MissingChild" />
		<!-- connect the children to their parent -->
		<xsl:call-template name="quote-name"><xsl:with-param name="name" select="$parent" /></xsl:call-template> -&gt; <xsl:call-template name="quote-name"><xsl:with-param name="name" select="$child" /></xsl:call-template> ;
	</xsl:template>

	<!-- ================================================================ -->
	<!-- Create a quoted name from the passed value                       -->
	<!-- ================================================================ -->

	<xsl:template name="quote-name"><xsl:param name="name" />&quot;<xsl:call-template name="clean-content"><xsl:with-param name="text" select="$name" /></xsl:call-template>&quot;</xsl:template>

	<!-- ================================================================ -->
	<!-- Clean content according to local rules of what "clean" means     -->
	<!-- ================================================================ -->

	<xsl:template name="clean-content">
		<xsl:param name="text" />
		<xsl:variable name="v1" select="normalize-space($text)" />
		<xsl:value-of select="$v1" />
	</xsl:template>

</xsl:stylesheet>

