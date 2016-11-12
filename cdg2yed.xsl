<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:y="http://www.yworks.com/xml/graphml"
    xmlns="http://graphml.graphdrawing.org/xmlns"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl"
>

<!-- 
XSL file to import NetBeans CDG files produced by easyUML plugin (http://plugins.netbeans.org/plugin/55435/easyuml) into the yEd graph editor.
Version: 1.0

Use: File -> Open -> XML + XSL (*.*) -> Select CDG file -> Open -> Select this file as "Custom XSL File" -> Ok
Then you will, probably, want to do: Layout -> Orthogonal -> UML Style -> Ok

License: Freeware. If you use it, please give credit to the author.

Author: andrey.lebedenko@gmail.com 
-->

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <graphml xmlns="http://graphml.graphdrawing.org/xmlns" xmlns:java="http://www.yworks.com/xml/yfiles-common/1.0/java" xmlns:sys="http://www.yworks.com/xml/yfiles-common/markup/primitives/2.0" xmlns:x="http://www.yworks.com/xml/yfiles-common/markup/2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:y="http://www.yworks.com/xml/graphml" xmlns:yed="http://www.yworks.com/xml/yed/3" xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns http://www.yworks.com/xml/schema/graphml/1.1/ygraphml.xsd">
            <key attr.name="Description" attr.type="string" for="graph" id="d0"/>
            <key for="port" id="d1" yfiles.type="portgraphics"/>
            <key for="port" id="d2" yfiles.type="portgeometry"/>
            <key for="port" id="d3" yfiles.type="portuserdata"/>
            <key attr.name="url" attr.type="string" for="node" id="d4"/>
            <key attr.name="description" attr.type="string" for="node" id="d5"/>
            <key for="node" id="d6" yfiles.type="nodegraphics"/>
            <key for="graphml" id="d7" yfiles.type="resources"/>
            <key attr.name="url" attr.type="string" for="edge" id="d8"/>
            <key attr.name="description" attr.type="string" for="edge" id="d9"/>
            <key for="edge" id="d10" yfiles.type="edgegraphics"/>
            <key attr.name="uml-id" attr.type="string" for="node" id="d11"/>

            <graph edgedefault="directed" id="G">
                <data key="d0"/>
                <xsl:apply-templates select="(//ClassDiagramComponents/Class|//ClassDiagramComponents/Interface|//ClassDiagramComponents/Enum)" mode="create-nodes"/>
                <xsl:variable name="tempTree">
                    <xsl:apply-templates select="(//ClassDiagramComponents/Class|//ClassDiagramComponents/Interface|//ClassDiagramComponents/Enum)" mode="create-nodes"/>
                </xsl:variable>

                <xsl:value-of select="exsl:node-set($tempTree)" />
                <xsl:for-each select="//ClassDiagramRelations/*">
                    <xsl:variable name="source">
                        <xsl:value-of select="@source" />
                    </xsl:variable>
                    <xsl:variable name="target">
                        <xsl:value-of select="@target" />
                    </xsl:variable>
                    <xsl:element name="edge">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat('e',position())"/>
                        </xsl:attribute>
                        <xsl:attribute name="source">
                            <xsl:value-of select="exsl:node-set($tempTree)/node[@uml-id = $source]/@id"/>
                        </xsl:attribute>
                        <xsl:attribute name="target">
                            <xsl:value-of select="exsl:node-set($tempTree)/node[@uml-id = $target]/@id"/>
                        </xsl:attribute>
                        <data key="d9"/>
                        <data key="d10">
                            <y:PolyLineEdge>
                              <y:Path sx="0.0" sy="0.0" tx="0.0" ty="0.0"/>
                              <xsl:choose>
                                <xsl:when test="name() = 'HasRelation'">
                                        <y:LineStyle color="#000000" type="dashed" width="2.0"/>
                                </xsl:when>
                                <xsl:when test="name() = 'ImplementsRelation'">
                                        <y:LineStyle color="#000000" type="dashed_dotted" width="2.0"/>
                                </xsl:when>
                                <xsl:when test="name() = 'IsRelation'">
                                        <y:LineStyle color="#000000" type="dotted" width="2.0"/>
                                </xsl:when>
                                <xsl:when test="name() = 'UseRelation'">
                                        <y:LineStyle color="#000000" type="line" width="2.0"/>
                                </xsl:when>
                                <xsl:otherwise>
                                        <y:LineStyle color="#FF0000" type="line" width="2.0"/>
                                </xsl:otherwise>
                              </xsl:choose>
                              <y:Arrows source="none" target="standard"/>
                              <y:BendStyle smoothed="false"/>
                            </y:PolyLineEdge>
                        </data>
                    </xsl:element>
                </xsl:for-each>
            </graph>
            <data key="d7">
                <y:Resources/>
            </data>
        </graphml>
    </xsl:template>

    <xsl:template match="//*" mode="create-nodes">
        <xsl:element name="node">
            <xsl:attribute name="id">
                <xsl:value-of select="concat('n',position())"/>
            </xsl:attribute>
            <xsl:attribute name="uml-id">
                <xsl:value-of select="concat(@package,'.',@name)"/>
            </xsl:attribute>
            <data key="d11">
                <xsl:value-of select="concat(@package,'.',@name)"/>
            </data>
            <data key="d4"/>
            <data key="d5"/>
            <data key="d6">
                <y:UMLClassNode>
                    <y:Geometry height="50.0" width="170.0" x="385.0" y="256.0"/>  <!-- MUST be there to keep yEd happy -->
                    <xsl:choose>
                      <xsl:when test="name() = 'Interface'">
                        <y:Fill color="#22FF22" transparent="false"/>
                      </xsl:when>
                      <xsl:when test="name() = 'Enum'">
                        <y:Fill color="#FFFF00" transparent="false"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <y:Fill color="#00CCFF" transparent="false"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    <y:BorderStyle color="#000000" type="line" width="1.0"/>
                    <y:NodeLabel alignment="center" autoSizePolicy="content" fontFamily="Dialog" fontSize="13" fontStyle="bold" hasBackgroundColor="false" hasLineColor="false">
                        <xsl:value-of select="@name"/>
                    </y:NodeLabel>
                    <xsl:variable name="stereotype">
                        <xsl:value-of select ="local-name()"/>
                    </xsl:variable>
                    <y:UML clipContent="true" constraint="" omitDetails="false" stereotype="{$stereotype}" use3DEffect="false">
                        <y:AttributeLabel>
                            <xsl:for-each select="Fields/Field">
                                <xsl:choose>
                                    <xsl:when test='@visibility = "private"'>
                                        <xsl:value-of select="'- '"/>
                                    </xsl:when>
                                    <xsl:when test='@visibility = "protected"'>
                                        <xsl:value-of select="'# '"/>
                                    </xsl:when>
                                    <xsl:when test='@visibility = "package"'>
                                        <xsl:value-of select="'~ '"/>
                                    </xsl:when>
                                    <xsl:when test='@visibility = "public"'>
                                        <xsl:value-of select="'+ '"/>
                                    </xsl:when>
                                </xsl:choose>
                                <xsl:value-of select="@name"/>
                                <xsl:text>&#xa;</xsl:text>
                            </xsl:for-each>
                        </y:AttributeLabel>
                        <y:MethodLabel>
                            <xsl:for-each select="Constructors/Constructor">
                                <xsl:choose>
                                    <xsl:when test='@visibility = "private"'>
                                        <xsl:value-of select="'- '"/>
                                    </xsl:when>
                                    <xsl:when test='@visibility = "protected"'>
                                        <xsl:value-of select="'# '"/>
                                    </xsl:when>
                                    <xsl:when test='@visibility = "package"'>
                                        <xsl:value-of select="'~ '"/>
                                    </xsl:when>
                                    <xsl:when test='@visibility = "public"'>
                                        <xsl:value-of select="'+ '"/>
                                    </xsl:when>
                                </xsl:choose>
                                <xsl:value-of select="'(constructor)'"/>
                                <xsl:text>&#xa;</xsl:text>
                            </xsl:for-each>
                            <xsl:for-each select="Methods/Method">
                                <xsl:choose>
                                    <xsl:when test='@visibility = "private"'>
                                        <xsl:value-of select="'- '"/>
                                    </xsl:when>
                                    <xsl:when test='@visibility = "protected"'>
                                        <xsl:value-of select="'# '"/>
                                    </xsl:when>
                                    <xsl:when test='@visibility = "package"'>
                                        <xsl:value-of select="'~ '"/>
                                    </xsl:when>
                                    <xsl:when test='@visibility = "public"'>
                                        <xsl:value-of select="'+ '"/>
                                    </xsl:when>
                                </xsl:choose>
                                <xsl:value-of select="@name"/>
                                <xsl:text>&#xa;</xsl:text>
                            </xsl:for-each>
                        </y:MethodLabel>
                    </y:UML>
                    <xsl:variable name="dim_h1">
                        <xsl:value-of select="count(Methods/Method)"/>
                    </xsl:variable>
                    <xsl:variable name="dim_h2">
                        <xsl:value-of select="count(Constructors/Constructor)"/>
                    </xsl:variable>
                    <xsl:variable name="dim_h3">
                        <xsl:value-of select="count(Fields/Field)"/>
                    </xsl:variable>
                    <y:Geometry height="{(7 + $dim_h1 + $dim_h2 + $dim_h3)*14}" width="170.0" x="385.0" y="256.0"/>
                </y:UMLClassNode>
            </data>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
