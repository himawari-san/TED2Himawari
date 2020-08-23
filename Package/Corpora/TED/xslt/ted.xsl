<?xml version="1.0" encoding="utf-8"?>
<!--
  ted.xsl
  Written by Masaya YAMAGUCHI
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- 表示用 -->

  <xsl:template match="ted">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="talk">
    <html xmlns:xhtml="http://www.w3.org/1999/xhtml" lang="ja">
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <meta http-equiv="Content-Style-Type" content="text/css" />
        <link rel="stylesheet" href="ted.css" type="text/css" />
	<title>
	  <xsl:value-of select="@title"/>
	</title>
      </head>

      <body>
	<h1>
	  <a target="_blank">
	    <xsl:attribute name="href">
	      <xsl:value-of select="@url" />
	    </xsl:attribute>
	    <xsl:value-of select="@title" />
	  </a>
	</h1>
	<p>
          <xsl:apply-templates select="description" />
	</p>
	<div style="max-width:854px; margin:3ex">
	  <div style="position:relative;height:0;padding-bottom:56.25%">
	    <iframe src="https://embed.ted.com/talks/lucy_hone_3_secrets_of_resilient_people" width="854" height="480" style="position:absolute;left:0;top:0;width:100%;height:100%;" frameborder="0" scrolling="no">
	      <xsl:attribute name="src">
		<xsl:apply-templates select="@embed_url" />
	      </xsl:attribute>
	    </iframe>
	  </div>
	</div>
	
        <xsl:apply-templates select="transcription" />

	<hr />
	<p>
	  This document was generated based on <a href="https://wit3.fbk.eu/mono.php?release=XML_releases&amp;tinfo=cleanedhtml_ted">WIT3's "Latest version of XML files of the TED Talks (April 2016)"</a>.
	</p>

	<!-- reffer to http://www.feedthebot.com/pagespeed/defer-loading-javascript.html -->
	<script type="text/javascript">
	  function downloadJSAtOnload() {location.href="#himawari";}
	  if (window.addEventListener)
	  window.addEventListener("load", downloadJSAtOnload, false);
	  else if (window.attachEvent)
	  window.attachEvent("onload", downloadJSAtOnload);
	  else window.onload = downloadJSAtOnload;
	</script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="transcription">
    <table>
      <thead>
	<tr>
	  <th>Time</th>
	  <th>Language1</th>
	  <th>Language2</th>
	</tr>
      </thead>
      <tbody>
        <xsl:apply-templates />
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="line">
    <tr class="line">
      <td style="vertical-align: top">
	<xsl:value-of select="@formatted_time" />
      </td>
      <td style="width: 45%; vertical-align: top">
	<xsl:apply-templates/>
      </td>
      <td style="width: 45%; vertical-align: top">
	<xsl:value-of select="@eq_lang" />
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="hidden_line">
    <tr class="line">
      <td style="vertical-align: top;">
      </td>
      <td style="width: 45%; vertical-align: top;">
      </td>
      <td style="width: 45%; vertical-align: top">
	<xsl:value-of select="@text" />
      </td>
    </tr>
  </xsl:template>

  
  <xsl:template match="s[@p!='']">
    <span class="su">
      <xsl:attribute name="title">
	<xsl:if test="@p">
	  <xsl:text>品詞: </xsl:text>
  	  <xsl:value-of select="@p"/>
	  <xsl:text>&#10;</xsl:text>
	</xsl:if>
	<xsl:if test="@c != ''">
	  <xsl:text>活用型: </xsl:text>
  	  <xsl:value-of select="@c"/>
	  <xsl:text>&#10;</xsl:text>
	</xsl:if>
	<xsl:if test="@f != ''">
	  <xsl:text>活用形: </xsl:text>
  	  <xsl:value-of select="@f"/>
	  <xsl:text>&#10;</xsl:text>
	</xsl:if>
	<xsl:if test="@l != ''">
	  <xsl:text>語彙素: </xsl:text>
  	  <xsl:value-of select="@l"/>
	  <xsl:text>&#10;</xsl:text>
	</xsl:if>
	<xsl:if test="@h != ''">
	  <xsl:text>発音: </xsl:text>
  	  <xsl:value-of select="@h"/>
	</xsl:if>
      </xsl:attribute>
      <xsl:choose>
	<xsl:when test="count(tg)!=0 and count(iu)!=0">
	  <span class="target_char">
	    <xsl:attribute name="id">
              <xsl:value-of select="tg/@id"/>
	    </xsl:attribute>
	    <xsl:apply-templates />
	  </span>
	</xsl:when>
	<xsl:when test="count(tg)!=0">
	  <span class="target_char">
	    <xsl:attribute name="id">
              <xsl:value-of select="tg/@id"/>
	    </xsl:attribute>
	    <xsl:value-of select="@s"/>
	  </span>
	</xsl:when>
	<xsl:when test="count(iu)!=0">
	  <xsl:apply-templates />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="@s"/>
	</xsl:otherwise>
      </xsl:choose>
    </span>
    <xsl:text>/</xsl:text>
  </xsl:template>


  <xsl:template match="tg">
    <span class="target_char">
      <xsl:attribute name="id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

</xsl:stylesheet>
