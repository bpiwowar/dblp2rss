(: Process an XML version of a DBLP page :)

declare namespace copyURL  = "java:CopyURL";

declare variable $feeds external;

declare variable $htmlpath := "http://dblp.uni-trier.de";
declare variable $bibpath := "http://dblp.uni-trier.de/rec/bibtex";

declare variable $cachepath := "/Users/bpiwowar/tmp/dblp2rss/cache";


<rss version="2.0">
<channel>
      <title>{data($feeds/*/@name)}</title>
{

(: Get all the ids :)
let $ids :=
    for $file in $feeds//item
    let $doc := doc(data($file))
    for $id in $doc/*/dblpkey[not(@type)]
    return <pub id="{data($id)}" since="{xs:date(if ($file/@since) then $file/@since else "0001-01-01")}"/>
 
(: Get the files :)
for $id in distinct-values($ids/@id)
let $since := distinct-values($ids[@id eq $id]/@since)
let $url := concat($bibpath,"/", $id , ".xml")
let $file := concat($cachepath, "/", string($id))

return
 if (fn:not(copyURL:get($url, $file))) then fn:error()
 else
 	let $bib := doc($file)
	where not(empty($bib/*/*[@mdate > $since]))
	return  (: <item mdate="{@mdate}" since="{$since}"> :) <item>
       <title> {$bib//title//text(), "", for $author at $i in $bib//author return (if ($i > 1) then "and" else "", string($author)), "" } </title> 
       <link> { concat($htmlpath,"/",$id) } </link> 
       <description> {for $a in $bib/*/*/* return (<b>{concat(name($a),": ")}</b>, $a//text(), <br/>) }<div><b>Link</b>: {concat($bibpath,"/",$id)}</div></description> 
       <pubDate> { string($bib/*/*/@mdate) } </pubDate>
       <guid>{concat($bibpath,"/",$id)}</guid>
 </item>
}

</channel>
</rss>


