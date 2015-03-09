<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ce="http://www.elsevier.com/xml/common/dtd"
    xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all">

    <xsl:output encoding="UTF-8" method="xml"/>

    <!-- KEYWORDS -->

    <!-- BMJ: classinfo, keyword -->
    <!-- NLM 2.2 article: kwd-group, kwd -->
    <!-- Springer: KeywordGroup, Keyword -->
    <!-- Sage: keywords, keyword -->
    <!-- Elsevier: ce:keyword -->
    
    <!-- IOP: classifications/ puis comme Sage keywords/keyword
              pour l'instant directement traité dans IOP.xsl    -->

    <xsl:template
        match="kwd-group | classinfo | KeywordGroup | keywords | ce:keywords | BookSubjectGroup">
        <textClass>
            <keywords>
                <list>
                    <xsl:apply-templates/>
                </list>
            </keywords>
        </textClass>
    </xsl:template>

    <xsl:template match="keyword | Keyword | ce:keyword | kwd">
        <item>
            <term>
                <xsl:apply-templates/>
            </term>
        </item>
    </xsl:template>

    <xsl:template match="BookSubject">
        <label>
            <xsl:value-of select="@Code"/>
        </label>
        <item>
            <term>
                <xsl:apply-templates/>
            </term>
        </item>
    </xsl:template>

    <!-- For NLM - EDPS -->

    <xsl:template match="compound-kwd">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="compound-kwd-part[@content-type='code']">
        <label>
            <xsl:apply-templates/>
        </label>
    </xsl:template>

    <xsl:template match="compound-kwd-part[@content-type='keyword']">
        <item>
            <term>
                <xsl:apply-templates/>
            </term>
        </item>
    </xsl:template>

    <xsl:template match="kwd-group/title">
        <head>
            <xsl:apply-templates/>
        </head>
    </xsl:template>

    <!-- ABSTRACTS -->

    <!-- BMJ: abstract -->
    <!-- ScholarOne: abstract -->
    <!-- NLM 2.0: Abstract -->
    <!-- NLM 2.3: abstract -->
    <!--  Elsevier:  -->
    <!-- Springer: Abstract, Heading, Para -->


    <xsl:template match="abstract | Abstract | ce:abstract">
        <xsl:if test=".!=''">
            <div type="abstract">
                <xsl:variable name="theLanguage">
                    <xsl:choose>
                        <xsl:when test="@Language">
                            <xsl:value-of select="@Language"/>
                        </xsl:when>
                        <xsl:when test="@xml:lang">
							<xsl:if test="@xml:lang">
								<xsl:if test="@xml:lang != ''">
									<xsl:value-of select="@xml:lang"/>
								</xsl:if>
							</xsl:if>	
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable> 
                <xsl:if test="$theLanguage">
					<xsl:if test="$theLanguage != ''">
	                    <xsl:attribute name="xml:lang">
	                        <xsl:call-template name="Varia2ISO639">
	                            <xsl:with-param name="code" select="$theLanguage"/>
	                        </xsl:call-template>
	                    </xsl:attribute>
					</xsl:if>
                </xsl:if>
                <xsl:if test="not(ce:section-title) and not(Heading)">
                    <head>Abstract</head>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="p | Para | ce:abstract-sec | AbstractSection">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <p>
                            <xsl:apply-templates/>
                        </p>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- Specific to SPringer: AbstractSection -->
    <xsl:template match="AbstractSection">
        <div>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

</xsl:stylesheet>
