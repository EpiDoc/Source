<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.1">

<xsl:output method="xml" indent="yes" encoding="UTF-8" />

<xsl:key name="index" match="head" use="." />

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!--  MODULE:           Cocoon: Epidoc demo                        -->
<!--  VERSION DATE:     1.0                                        -->
<!--  VERSION:          2006-03-10                       					 -->
<!--  VERSION CONTROL:                                             -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- ORIGINAL CREATION DATE:    2006-03-10                    		 -->
<!-- PURPOSE:   Step 2/3 Creates index of personal names 					 -->
<!-- CREATED FOR:  Epidoc demo                           					 -->
<!-- CREATED BY:   ZA GB         										               -->
<!-- COPYRIGHT:   CCH/epidoc, GPL                                  -->
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<xsl:variable name="lowercase">
abcdefghijklmnopqrstuvwxyz&#x1f00;&#x1f01;&#x1f02;&#x1f03;&#x1f04;&#x1f05;&#x1f06;&#x1f07;&#x1f08;&#x1f09;&#x1f0a;&#x1f0b;&#x1f0c;&#x1f0d;&#x1f0e;&#x1f0f;&#x0391;&#x1f70;&#x1f71;&#x1f80;&#x1f81;&#x1f82;&#x1f83;&#x1f84;&#x1f85;&#x1f86;&#x1f87;&#x1f88;&#x1f89;&#x1f8a;&#x1f8b;&#x1f8c;&#x1f8d;&#x1f8e;&#x1f8f;&#x1fb2;&#x1fb3;&#x1fb4;&#x1fb6;&#x1fb7;&#x03ac;&#x03ad;&#x0395;&#x1f10;&#x1f11;&#x1f12;&#x1f13;&#x1f14;&#x1f15;&#x1f18;&#x1f19;&#x1f1a;&#x1f1b;&#x1f1c;&#x1f1d;&#x1f72;&#x1f73;&#x0397;&#x03ae;&#x1f20;&#x1f21;&#x1f22;&#x1f23;&#x1f24;&#x1f25;&#x1f26;&#x1f27;&#x1f28;&#x1f29;&#x1f2a;&#x1f2b;&#x1f2c;&#x1f2d;&#x1f2e;&#x1f2f;&#x1f90;&#x1f91;&#x1f92;&#x1f93;&#x1f94;&#x1f95;&#x1f96;&#x1f97;&#x1f98;&#x1f99;&#x1f9a;&#x1f9b;&#x1f9c;&#x1f9d;&#x1f9e;&#x1f9f;&#x1fc2;&#x1fc3;&#x1fc4;&#x1fc6;&#x1fc7;&#x1f74;&#x1f75;&#x0399;&#x03af;&#x03ca;&#x1f30;&#x1f31;&#x1f32;&#x1f33;&#x1f34;&#x1f35;&#x1f36;&#x1f37;&#x1f38;&#x1f39;&#x1f3a;&#x1f3b;&#x1f3c;&#x1f3d;&#x1f3e;&#x1f3f;&#x1f76;&#x1f77;&#x1fd2;&#x1fd3;&#x1fd6;&#x1fd7;&#x039f;&#x03cc;&#x1f40;&#x1f41;&#x1f42;&#x1f43;&#x1f44;&#x1f45;&#x1f48;&#x1f49;&#x1f4a;&#x1f4b;&#x1f4c;&#x1f4d;&#x1f78;&#x1f79;&#x0385;&#x03cd;&#x1f50;&#x1f51;&#x1f52;&#x1f53;&#x1f54;&#x1f55;&#x1f56;&#x1f57;&#x1f59;&#x1f5b;&#x1f5d;&#x1f5f;&#x1f7a;&#x1f7b;&#x1fe2;&#x1fe3;&#x1fe6;&#x1fe7;&#x03cb;&#x03a9;&#x03ce;&#x1f60;&#x1f61;&#x1f62;&#x1f63;&#x1f64;&#x1f65;&#x1f66;&#x1f67;&#x1f68;&#x1f69;&#x1f6a;&#x1f6b;&#x1f6c;&#x1f6d;&#x1f6e;&#x1f6f;&#x1f7c;&#x1f7d;&#x1fa0;&#x1fa1;&#x1fa2;&#x1fa3;&#x1fa4;&#x1fa5;&#x1fa6;&#x1fa7;&#x1fa8;&#x1fa9;&#x1faa;&#x1fab;&#x1fac;&#x1fad;&#x1fae;&#x1faf;&#x1ff2;&#x1ff3;&#x1ff4;&#x1ff6;&#x1ff7;&#x03c2;&#x1fe4;&#x1fe5;&#x0391;&#x0392;&#x0393;&#x0394;&#x0395;&#x0396;&#x0397;&#x0398;&#x0399;&#x039a;&#x039b;&#x039c;&#x039d;&#x039e;&#x039f;&#x03a0;&#x03a1;&#x03a3;&#x03a4;&#x03a5;&#x03a6;&#x03a7;&#x03a8;&#x03a9;&#x1fec;
</xsl:variable>

<xsl:variable name="uppercase">
ABCDEFGHIJKLMNOPQRSTUVWXYZ&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c3;&#x03c1;&#x03c1;&#x03B1;&#x03B2;&#x03B3;&#x03B4;&#x03B5;&#x03B6;&#x03B7;&#x03B8;&#x03B9;&#x03BA;&#x03BB;&#x03BC;&#x03BD;&#x03BE;&#x03BF;&#x03C0;&#x03C1;&#x03C3;&#x03C4;&#x03C5;&#x03C6;&#x03C7;&#x03C8;&#x03C9;&#x03c1;
</xsl:variable>

<xsl:variable name="grkb4">
&#x1f00;&#x1f01;&#x1f02;&#x1f03;&#x1f04;&#x1f05;&#x1f06;&#x1f07;&#x1f08;&#x1f09;&#x1f0a;&#x1f0b;&#x1f0c;&#x1f0d;&#x1f0e;&#x1f0f;&#x0391;&#x1f70;&#x1f71;&#x1f80;&#x1f81;&#x1f82;&#x1f83;&#x1f84;&#x1f85;&#x1f86;&#x1f87;&#x1f88;&#x1f89;&#x1f8a;&#x1f8b;&#x1f8c;&#x1f8d;&#x1f8e;&#x1f8f;&#x1fb2;&#x1fb3;&#x1fb4;&#x1fb6;&#x1fb7;&#x03ac;&#x03ad;&#x0395;&#x1f10;&#x1f11;&#x1f12;&#x1f13;&#x1f14;&#x1f15;&#x1f18;&#x1f19;&#x1f1a;&#x1f1b;&#x1f1c;&#x1f1d;&#x1f72;&#x1f73;&#x0397;&#x03ae;&#x1f20;&#x1f21;&#x1f22;&#x1f23;&#x1f24;&#x1f25;&#x1f26;&#x1f27;&#x1f28;&#x1f29;&#x1f2a;&#x1f2b;&#x1f2c;&#x1f2d;&#x1f2e;&#x1f2f;&#x1f90;&#x1f91;&#x1f92;&#x1f93;&#x1f94;&#x1f95;&#x1f96;&#x1f97;&#x1f98;&#x1f99;&#x1f9a;&#x1f9b;&#x1f9c;&#x1f9d;&#x1f9e;&#x1f9f;&#x1fc2;&#x1fc3;&#x1fc4;&#x1fc6;&#x1fc7;&#x1f74;&#x1f75;&#x0399;&#x03af;&#x03ca;&#x1f30;&#x1f31;&#x1f32;&#x1f33;&#x1f34;&#x1f35;&#x1f36;&#x1f37;&#x1f38;&#x1f39;&#x1f3a;&#x1f3b;&#x1f3c;&#x1f3d;&#x1f3e;&#x1f3f;&#x1f76;&#x1f77;&#x1fd2;&#x1fd3;&#x1fd6;&#x1fd7;&#x039f;&#x03cc;&#x1f40;&#x1f41;&#x1f42;&#x1f43;&#x1f44;&#x1f45;&#x1f48;&#x1f49;&#x1f4a;&#x1f4b;&#x1f4c;&#x1f4d;&#x1f78;&#x1f79;&#x0385;&#x03cd;&#x1f50;&#x1f51;&#x1f52;&#x1f53;&#x1f54;&#x1f55;&#x1f56;&#x1f57;&#x1f59;&#x1f5b;&#x1f5d;&#x1f5f;&#x1f7a;&#x1f7b;&#x1fe2;&#x1fe3;&#x1fe6;&#x1fe7;&#x03cb;&#x03a9;&#x03ce;&#x1f60;&#x1f61;&#x1f62;&#x1f63;&#x1f64;&#x1f65;&#x1f66;&#x1f67;&#x1f68;&#x1f69;&#x1f6a;&#x1f6b;&#x1f6c;&#x1f6d;&#x1f6e;&#x1f6f;&#x1f7c;&#x1f7d;&#x1fa0;&#x1fa1;&#x1fa2;&#x1fa3;&#x1fa4;&#x1fa5;&#x1fa6;&#x1fa7;&#x1fa8;&#x1fa9;&#x1faa;&#x1fab;&#x1fac;&#x1fad;&#x1fae;&#x1faf;&#x1ff2;&#x1ff3;&#x1ff4;&#x1ff6;&#x1ff7;&#x03c2;&#x1fe4;&#x1fe5;&#x0391;&#x0392;&#x0393;&#x0394;&#x0395;&#x0396;&#x0397;&#x0398;&#x0399;&#x039a;&#x039b;&#x039c;&#x039d;&#x039e;&#x039f;&#x03a0;&#x03a1;&#x03a3;&#x03a4;&#x03a5;&#x03a6;&#x03a7;&#x03a8;&#x03a9;&#x1fec;
</xsl:variable>

<xsl:variable name="grkafter">
&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b1;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b5;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b7;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03b9;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03bf;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c5;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c9;&#x03c3;&#x03c1;&#x03c1;&#x03B1;&#x03B2;&#x03B3;&#x03B4;&#x03B5;&#x03B6;&#x03B7;&#x03B8;&#x03B9;&#x03BA;&#x03BB;&#x03BC;&#x03BD;&#x03BE;&#x03BF;&#x03C0;&#x03C1;&#x03C3;&#x03C4;&#x03C5;&#x03C6;&#x03C7;&#x03C8;&#x03C9;&#x03c1;
</xsl:variable>

<xsl:template match="/">

	<body>
		<xsl:for-each select="//head[generate-id(.)=generate-id(key('index', .)[1])]">
			<xsl:sort select="normalize-space(translate(., $grkb4, $grkafter))" lang="grc" order="ascending" />
				<div>
					<head>
						<xsl:attribute name="reg">
							<xsl:value-of select="@reg" />
						</xsl:attribute>
						<xsl:attribute name="letter">
							<xsl:value-of select="substring(translate(translate(., '[].? -', ''), $lowercase, $uppercase), 1, 1)" />
						</xsl:attribute>
						<xsl:attribute name="id">
							<xsl:value-of select="normalize-space(translate(translate(., '[]-', ''), $grkb4, $grkafter))" />
           	</xsl:attribute>
						<xsl:value-of select="." />
					</head>
					<xsl:for-each select="key('index', normalize-space(.))">
						<word>
							<xsl:attribute name="lang">
								<xsl:if test="not(current()='omega' or current()='alpha')">
									<xsl:text>grc</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<epidoc>
								<xsl:if test="../@cert">
									<xsl:attribute name="cert">
		             	</xsl:attribute>
								</xsl:if>
								<xsl:if test="../@sup">
									<xsl:attribute name="sup">
		             	</xsl:attribute>
								</xsl:if>
								<xsl:apply-templates select="../epidoc" />
							</epidoc>
							<xsl:if test="../line">
  							<line>
  								<xsl:apply-templates select="../line" />
  							</line>
							</xsl:if>
							<type>
								<xsl:value-of select="../type"/>
							</type>
						</word>
					</xsl:for-each>
				</div>
		</xsl:for-each>
	</body>
</xsl:template>


</xsl:stylesheet>