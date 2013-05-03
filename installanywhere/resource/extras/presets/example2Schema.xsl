<?xml version='1.0'?>
<!-- From any XML, make a skeleton for an XML Schema. Doesn't record attributes.
In the 'oneTag' template we could add an anonymous <complexType> wrapper, to achieve a real conforming XML Schema, but I wrote it like this to simplify further treatment like generating GUI and making statistics. However, the benefit of being compliant is so great that I will probably use real conforming XML Schemas (or Schemata ? -;) ).

Copyright J.M. Vanel 2001 - under GNU public licence
 -->
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>
 <xsl:output indent='yes' />

 <!-- Here we group siblings by same tag name,  we call the 'oneTag' template on those groups, and we recurse on the rest.  -->
 <xsl:template name='anyTag'>
  <xsl:param name='siblings'/>
  <xsl:if test='$siblings' >
   <xsl:variable name='n' select='name($siblings)'/>

   <xsl:call-template name='oneTag'>
    <xsl:with-param name='homologs' select='$siblings [position()>=1] [name()=$n]'/>
   </xsl:call-template>
   <xsl:variable name='otherTags' select='$siblings [position()>1][name()!=$n]' />
   <xsl:if test='$otherTags' >
    <xsl:call-template name='anyTag'>
     <xsl:with-param name='siblings' select='$otherTags'/>
    </xsl:call-template>
   </xsl:if>
  </xsl:if>
 </xsl:template>

 <!-- Here we have a set of siblings having all the same tag name, we can output an element, and recurse on the children. -->
 <xsl:template name='oneTag'>
  <xsl:param name='homologs'/>
  <xsl:element name='element'>
   <xsl:attribute name='name'>
    <xsl:value-of select='name($homologs)'/></xsl:attribute>
   <xsl:attribute name='occurs'>
    <xsl:value-of select='count($homologs)'/></xsl:attribute>
   <xsl:call-template name='anyTag'>
    <xsl:with-param name='siblings' select='$homologs/*'/>
   </xsl:call-template>
  </xsl:element>
 </xsl:template>

 <xsl:template match='text()'/>

 <xsl:template match='/'>
  <schema>
   <xsl:call-template name='anyTag'>
    <xsl:with-param name='siblings' select='*'/>
   </xsl:call-template>
  </schema>
 </xsl:template>

</xsl:stylesheet>
