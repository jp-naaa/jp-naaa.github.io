function extract_triples(triples) {
  const RDF_TYPE = "http://www.w3.org/1999/02/22-rdf-syntax-ns#type";
  const out = {};
  for (const q of triples) {
    const s = q.subject.value;
    const p = q.predicate.value;
    out[s] ??= {};
    // rdf:type は @type に入れる（object は NamedNode のはず）
    if (p === RDF_TYPE && q.object.termType === "NamedNode") {
      out[s]["@type"] ??= [];
      out[s]["@type"].push(q.object.value);
      continue;
    }
    if (q.object.termType !== "Literal") continue;
    const entry = {
      value: q.object.value,
      lang: q.object.language || null,               // 言語なしは null
      datatype: q.object.datatype?.value || null
    };
    out[s] ??= {};
    out[s][p] ??= [];
    out[s][p].push(entry);
  }
  return out;
}

let fetcher = new window.ldfetch();
function fetch_jp_cos(url, elem) {
  let main = async function () {
    const objects = await fetcher.get(url).then(response =>
      extract_triples(response.triples)
    );
    const uri = decodeURI(url);
    console.log(uri);
    console.log(objects);
    if (objects[uri]) {
      e = objects[uri];
      const parent = elem.parentNode;
      if (e["@type"] == "https://w3id.org/jp-cos/Item") {
        parent.innerHTML += ` <span class="sectionNumberHierarchy">${e["https://w3id.org/jp-cos/sectionNumberHierarchy"][0].value}</span>`;
        parent.innerHTML += `<br><span class="sectionText">${e["https://w3id.org/jp-cos/sectionText"][0].value}</span>`;
      } else {
        for (const literal of e["http://schema.org/name"]) {
          if (literal.lang == "ja") {
            parent.innerHTML += ` <span class="jp-cos name">${literal.value}</span>`;
          }
        };
      }
    };
  };
    try {
    main();
  } catch (e) {
    console.error(e);
  }
};
$("dl.row dd a").each(function(link){
  //let url = "https://w3id.org/jp-cos/8220233111000000";
  let url = this.href.toString();
  if (url.startsWith("https://w3id.org/jp-cos/")) {
    fetch_jp_cos(url, this);
  }
});
