<?xml version="1.0" ?> 
<!-- Substitute occurences of element <e1> in namespace N1 into element <e2> in namespace N2 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" >
 <!-- 2000-04-13 : namespace axis not implemented yet! in Xalan and XT 
<xsl:template match="e1[namespace::namespaceN1]">
 -->
<xsl:template match="e1" xmlns:N1="namespaceN1" >
  <e2>
   <xsl:apply-templates/> 
  </e2>
 </xsl:template>

<!-- This the simplest identity function --> 
 <xsl:template match="@*|*">
  <xsl:copy>
   <xsl:apply-templates /> 
  </xsl:copy>
 </xsl:template>
  
</xsl:stylesheet>

