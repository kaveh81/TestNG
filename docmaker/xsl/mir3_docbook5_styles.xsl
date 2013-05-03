<?xml version="1.0"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:d="http://docbook.org/ns/docbook" 
	exclude-result-prefixes="d" 
	version="1.0"
>
	<xsl:import href="../../docbook/docbook-xsl-1.75.2/fo/docbook.xsl" />  
	<!-- xsl:import href="../buildtools/docbook/docbook-xsl-1.75.2/html/docbook.xsl "/ -->
	
	<!-- ================================================================ -->
	<!-- generic global settings -->
	<!-- ================================================================ -->
	
	<xsl:param name="header.image.filename">logo_mir3_header.jpg</xsl:param>
	<xsl:param name="statement.confidential">MIR3 Confidential</xsl:param>
	
	<xsl:param name="use.extensions" select="0" />

	<xsl:param name="paper.type" select="'USletter'" />
	<xsl:param name="page.orientation">portrait</xsl:param>
	<!-- xsl:param name="page.orientation">landscape</xsl:param -->
	
	<xsl:param name="page.height.portrait">11in</xsl:param> 
	<xsl:param name="page.width.portrait">8.5in</xsl:param>
	<xsl:param name="page.margin.inner">0.75in</xsl:param>
	<xsl:param name="page.margin.outer">0.50in</xsl:param>
	<xsl:param name="page.margin.top">0.17in</xsl:param>   
	<xsl:param name="region.before.extent">0.17in</xsl:param>  
	<xsl:param name="body.margin.top">0.33in</xsl:param>  
	<xsl:param name="region.after.extent">0.35in</xsl:param>
	<xsl:param name="page.margin.bottom">0.50in</xsl:param>
	<xsl:param name="body.margin.bottom">0.65in</xsl:param>
	<xsl:param name="double.sided">1</xsl:param>
		
	<xsl:param name="hyphenate" select="true" />
	<xsl:param name="header.rule" select="1" />
	<xsl:param name="footer.rule" select="1" />
	
	<xsl:param name="chapter.autolabel" select="0" />	<!-- do not number chapters -->

	<!-- ================================================================ -->
	<!-- settings used for chapters, originally copied from DocBook param.xsl -->
	<!-- ================================================================ -->
	
	<xsl:attribute-set name="component.title.properties">
		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
		<xsl:attribute name="space-before.optimum"><xsl:value-of select="concat($body.font.master, 'pt')"/></xsl:attribute>
		<xsl:attribute name="space-before.minimum"><xsl:value-of select="concat($body.font.master, 'pt * 0.8')"/></xsl:attribute>
		<xsl:attribute name="space-before.maximum"><xsl:value-of select="concat($body.font.master, 'pt * 1.2')"/></xsl:attribute>
		<xsl:attribute name="hyphenate">false</xsl:attribute>
		<xsl:attribute name="text-align">
			<xsl:choose>
				<xsl:when test="((parent::article | parent::articleinfo | parent::info/parent::article) and not(ancestor::book) and not(self::bibliography))         or (parent::slides | parent::slidesinfo)">center</xsl:when>
				<xsl:otherwise>start</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="start-indent"><xsl:value-of select="$title.margin.left"/></xsl:attribute>
		<!-- CLM modifications -->
		<xsl:attribute name="color">#005387</xsl:attribute>	<!-- MIR3 dark blue -->
	</xsl:attribute-set>
	
	<!-- ================================================================ -->
	<!-- settings for sections, originally copied from DocBook param.xsl -->
	<!-- ================================================================ -->
	
	<xsl:attribute-set name="section.title.properties">
		<xsl:attribute name="font-family">
			<xsl:value-of select="$title.font.family"/>
		</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<!-- font size is calculated dynamically by section.heading template -->
		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
		<xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
		<xsl:attribute name="space-before.optimum">1.0em</xsl:attribute>
		<xsl:attribute name="space-before.maximum">1.2em</xsl:attribute>
		<xsl:attribute name="text-align">start</xsl:attribute>
		<xsl:attribute name="start-indent"><xsl:value-of select="$title.margin.left"/></xsl:attribute>
		<!-- CLM modifications -->
		<xsl:attribute name="color">#005387</xsl:attribute>	<!-- MIR3 dark blue -->
	</xsl:attribute-set>
	
	<xsl:attribute-set name="section.title.level1.properties">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1.8"/>
			<xsl:text>pt</xsl:text>
		</xsl:attribute>
	</xsl:attribute-set>

	<!-- ================================================================ -->
	<!-- admonitions -->
	<!-- ================================================================ -->
	
	<xsl:param name="admon.graphics" select="1"/>
	
	<!-- ================================================================ -->
	<!-- tables -->
	<!-- ================================================================ -->
	
	<xsl:param name="default.table.frame">all</xsl:param>
	<xsl:param name="default.table.rules">all</xsl:param>

	<xsl:attribute-set name="pgwide.properties">
		<xsl:attribute name="start-indent">0pt</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- settings for tables, originally copied from DocBook param.xsl -->
	
	<xsl:attribute-set name="table.table.properties">
		<xsl:attribute name="border-before-width.conditionality">retain</xsl:attribute>
		<xsl:attribute name="border-collapse">collapse</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table.properties" use-attribute-sets="formal.object.properties">
		<xsl:attribute name="keep-together.within-column">auto</xsl:attribute>
		<!-- CLM modifications -->
		<xsl:attribute name="start-indent">
			<xsl:choose>
				<xsl:when test="@tabstyle = 'smallfont-wide'">0pt</xsl:when>
				<xsl:otherwise>inherit</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="font-size">
			<xsl:choose>
				<xsl:when test="@tabstyle = 'smallfont-wide'">6pt</xsl:when>
				<xsl:otherwise>inherit</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- ================================================================ -->
	<!-- headers and footers -->
	<!-- ================================================================ -->
	
	<!-- settings for headers, originally copied from DocBook pagesetup.xsl -->
	
	<xsl:template name="header.content">
		<xsl:param name="pageclass" select="''"/>
		<xsl:param name="sequence" select="''"/>
		<xsl:param name="position" select="''"/>
		<xsl:param name="gentext-key" select="''"/>
		
		<!--
			<fo:block>
			<xsl:value-of select="$pageclass"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="$sequence"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="$position"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="$gentext-key"/>
			</fo:block>
		-->
		
		<fo:block>
			
			<!-- sequence can be odd, even, first, blank -->
			<!-- position can be left, center, right -->
			<xsl:choose>
				<xsl:when test="$sequence = 'blank'">
					<!-- nothing -->
				</xsl:when>
				
				<xsl:when test="$position='left'">
					<!-- Same for odd, even, empty, and blank sequences -->
					<xsl:call-template name="draft.text"/>
				</xsl:when>
				
				<xsl:when test="($sequence='odd' or $sequence='even') and $position='center'">
					<xsl:if test="$pageclass != 'titlepage'">
						<xsl:choose>
							<xsl:when test="ancestor::book and ($double.sided != 0)">
								<fo:retrieve-marker retrieve-class-name="section.head.marker"
									retrieve-position="first-including-carryover"
									retrieve-boundary="page-sequence"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="." mode="titleabbrev.markup"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:when>
				
				<xsl:when test="$position='center'">
					<!-- nothing for empty and blank sequences -->
				</xsl:when>
				
				<xsl:when test="$position='right'">
					<!-- Same for odd, even, empty, and blank sequences -->
					<xsl:call-template name="draft.text"/>
				</xsl:when>
				
				<xsl:when test="$sequence = 'first'">
					<!-- nothing for first pages -->
				</xsl:when>
				
				<xsl:when test="$sequence = 'blank'">
					<!-- nothing for blank pages -->
				</xsl:when>
			</xsl:choose>
		</fo:block>
	</xsl:template>

	<!-- settings for footers, originally copied from DocBook pagesetup.xsl -->
	
	<xsl:template name="footer.content">
		<xsl:param name="pageclass" select="''"/>
		<xsl:param name="sequence" select="''"/>
		<xsl:param name="position" select="''"/>
		<xsl:param name="gentext-key" select="''"/>
		
		<!--
			<fo:block>
			<xsl:value-of select="$pageclass"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="$sequence"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="$position"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="$gentext-key"/>
			</fo:block>
		-->
		
		<fo:block>
			<!-- pageclass can be front, body, back -->
			<!-- sequence can be odd, even, first, blank -->
			<!-- position can be left, center, right -->
			<xsl:choose>
				<xsl:when test="$pageclass = 'titlepage'">
					<!-- nop; no footer on title pages -->
				</xsl:when>
				
				<xsl:when test="$double.sided != 0 and $sequence = 'even'">
					<xsl:choose>
						<xsl:when test="$position='left'">
							<fo:page-number/>
						</xsl:when>

						<xsl:when test="$position='center'">
							<fo:external-graphic content-height="1.2cm">
								<xsl:attribute name="src">
									<xsl:call-template name="fo-external-image">
										<xsl:with-param name="filename" select="$header.image.filename"/>
									</xsl:call-template>
								</xsl:attribute>
							</fo:external-graphic>
						</xsl:when>

						<xsl:when test="$position='right'">
							<xsl:value-of select="$statement.confidential"/>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				
				<xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first')">
					<xsl:choose>
						<xsl:when test="$position='left'">
							<xsl:value-of select="$statement.confidential"/>
						</xsl:when>

						<xsl:when test="$position='center'">
							<fo:external-graphic content-height="1.2cm">
								<xsl:attribute name="src">
									<xsl:call-template name="fo-external-image">
										<xsl:with-param name="filename" select="$header.image.filename"/>
									</xsl:call-template>
								</xsl:attribute>
							</fo:external-graphic>
						</xsl:when>
						
						<xsl:when test="$position='right'">
							<fo:page-number/>
						</xsl:when>
					</xsl:choose>
				</xsl:when>

				<xsl:when test="$double.sided = 0 and $position='center'">
					<fo:page-number/>
				</xsl:when>
				
				<xsl:when test="$sequence='blank'">
					<xsl:choose>
						<xsl:when test="$double.sided != 0 and $position = 'left'">
							<fo:page-number/>
						</xsl:when>
						<xsl:when test="$double.sided = 0 and $position = 'center'">
							<fo:page-number/>
						</xsl:when>
						<xsl:otherwise>
							<!-- nop -->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				
				
				<xsl:otherwise>
					<!-- nop -->
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template>
	
	<!-- ================================================================ -->
	<!-- processor specific: HTML settings -->
	<!-- ================================================================ -->
	
	
	<!-- ================================================================ -->
	<!-- processor specific: FOP settings -->
	<!-- ================================================================ -->
	
	<xsl:param name="fop1.extensions" select="1" />
	
	<xsl:param name="body.start.indent">
		<xsl:choose>
			<xsl:when test="$fop.extensions != 0">0pt</xsl:when>
			<xsl:when test="$fop1.extensions != 0">0pt</xsl:when>
			<xsl:when test="$passivetex.extensions != 0">0pt</xsl:when>
			<xsl:otherwise>4pc</xsl:otherwise>
		</xsl:choose>
	</xsl:param>
	
</xsl:stylesheet>
