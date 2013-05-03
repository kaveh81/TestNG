<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:Day="http://jmvanel.free.fr/Diary.xsc" 
                xmlns:html="http://www.w3.org/TR/REC-html40" 
                xmlns:jrn="journal" 
                version="1.0" >

<!-- Selects only the given tag at any embedding level, together with all its embedded elements and attributes.
-->

 <xsl:template match="/"> 
   <container>
     <xsl:copy-of select="//IDEAS"/>
   </container>
 </xsl:template>
</xsl:stylesheet> 
