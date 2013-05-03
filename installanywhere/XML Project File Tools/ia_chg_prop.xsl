<?xml version="1.0" encoding="UTF-8"?>

<!--
	
	ia_chg_prop.xsl
	Version 1.0 - tam - 5/22/2002

	Version 1.1 - akm - 9/24/2004
	Updated to work with InstallAnywhere 6 projects and higher.
	
	*******************************************************
	Copyright (c) 2005 Zero G Software, Inc.
	InstallAnywhere is a registered trademark of Zero G
	Software, Inc., all rights reserved.
	514 Bryant St., California, 94107, U.S.A.
	
	The DevNet license agreement gives you specific rights
	with regard to using this code in your own projects and
	in derivative works.  See the DevNet license agreement
	for more information.
	*******************************************************
	
	Change InstallAnywhere Installer Property:
	
	This XSLT transform changes a parameter of an InstallAnywhere
	Installer.  There are two XSLT parameters, the name of the
	property to change and the value.
	
	Use the ia_project_info.xsl transform against the project file first
	to determine which attributes of the installer may be changed with
	this transformation (see README).
	
	Example usage with Microsoft XML 4.0:
	c:\>msxsl ia_prod.xml ia_chg_prop.xsl -o ia_prod_new.xml propName=productName propValue="New Product Name"
	
	Example usage with SAXON:
	c:\>saxon -o ia_prod_new.xml ia_prod.xml ia_chg_prop.xsl propName=productName propValue="New Product Name"
	
	This will change the "productName" property in the file ia_prod.xml to equal
	"New Product Name" and store the results in ia_prod_new.xml which will otherwise
	be identical to the input file.
	
-->

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
	
	<!-- space control -->
	<xsl:output
		method="xml"
		encoding="UTF-8"
		cdata-section-elements="string"/>
	<!-- <xsl:strip-space elements="string"/> -->
	
	
	<!-- input parameters -->
	<xsl:param name="propName" select="'default_property_name'"/>
	<xsl:param name="propValue" select="'default_value'"/>
	
	
	<!-- copy everything -->
	<xsl:template match="*|@*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>

	
	<!-- change the property -->
	<xsl:template match="object[@class='com.zerog.ia.installer.util.InstallerInfoData']/property">
		<xsl:choose>
			<xsl:when test="@name=$propName">							<!-- find the specified property by name -->
				<xsl:copy>												<!-- copy the property element -->
					<xsl:copy-of select="@*"/>						<!-- copy the property name attribute -->
					<xsl:element name="{name(./*[position()=1])}">	<!-- create an element of the correct type -->
						<xsl:value-of select="$propValue"/>			<!-- insert the new value -->
					</xsl:element>
				</xsl:copy>
			</xsl:when>
			<xsl:when test="@name!=$propName">						<!-- copy all other properties -->
				<xsl:copy-of select="."/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
