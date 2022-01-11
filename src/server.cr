require "kemal"
require "water"
# mentioning ``text <<-HTML ``  is very important while adding tags that water is not aware of
#require "./sample"
#require "./parvati"
require "./saraswati"

#resulted = [] of JSON::Any
#links = [] of String
class Water

  def_custom_tag search

end

page = Water.new do
doctype
html {
  head {

                meta %| charset="UTF-8" |
                meta %| http-equiv="X-UA-Compatible" content="IE=edge" |
                meta %|name="viewport" content="width=device-width,initial-scale=1.0"|
                title "APP TO EXTRACT DATE FROM SITES"
                link %|rel="stylesheet" media="screen"|
style %q{

.centering{
      text-align:center;
}
.titled{
      font-family: arial,sans-serif;
      padding-top: 5px;
      font-size: 20px;
      margin-bottom: 3px;
}
.g{
      width: 800px;
      margin-top: 0;
      margin-bottom: 30px;
      line-height: 1.58;
      text-align: left;
}
table{ width: 100%; }
td {
    width: 30%;
    height: 50px;
}
}
script %q{
console.log("This script is being generated with crystal lang")
}

  }
  body {




                h2  Time.local
br
                h1 "Extract dates from site"

br
                form  %|  id="links-form" method="POST"|  {

                        div %|  class="centering" | {

                                fieldset {
                        #a text area where a number of URLs can be input (1<n<1000)
                        #var values = obj.value.replace(/\r\n/g,"\n").split("\n")


                                        textarea %|id="input-links" rows="10" cols="100" onkeydown="limitLines(this, 1000)"| {}
br

script %q{

function limitLines(obj, limit) {

        var values = obj.value.replace(/\r\n/g,"\n").split("\n")

        if (values.length > limit) {

                obj.value = values.slice(0, limit).join("\n")}
        }
}
                                        input %|type="submit" value="Extract Dates"|
script %q{

var links = [];
var a_jax = new XMLHttpRequest();

document.getElementById("links-form").addEventListener("submit", function(evt) {

        evt.preventDefault();

        var area = document.getElementById("input-links");
        var lines = area.value.replace(/\r\n/g,"\n").split("\n");

        links = lines
        console.log(links);

        var jpack = {
              "links": links
        }

        a_jax.open("POST","", true);
        a_jax.setRequestHeader("Content-Type", "application/json");
        links = JSON.stringify(jpack);
        a_jax.send(links);

        a_jax.onreadystatechange = function() {

                if (this.readyState == 4){

                        var results = this.responseText;
                        var extract = JSON.parse(results)

                                      console.log(" results " +results)
                                      console.log(" extract " +extract)
                                      console.log("length of json " +extract.length )

                        var HTML = "<table> <thead> <tr> <th> Links </th> <th> Days </th>  <th> Speed </th> </tr></thead>"

                        for (i = 0 ; i < extract.length ; i++){

                                HTML += "<tr>"

                                if(i == (extract.length - 1)) {

                                        line = extract[i]
                                        slice = line.split(":")
                                        HTML += "<td align=center> <h2>___</h2></td>"
                                        HTML += "<td align=center> <h2>"+slice[0]+ "</h2></td>"
                                        HTML += "<td align=center><h2>"+slice[1]+ "</h2></td>"
                                }
                                else {
                                        line = extract[i]
                                        var slice = line.split("|")

                                        for (j = 0; j < 3 ; j++){ HTML += "<td align=center>" +slice[j]+ "</td>"}
                                }
                                        HTML += "</tr>";
                        }
                                      HTML += "</table>";
                                      document.getElementById("extract").innerHTML = HTML;
                }
        }
})

}
                                        div %|  class="centering" | {
br
                                                h1 "Your Result"
                                                div %|id="extract"| {}

                                        }

                                }
                        }

                }

hr
                form  %|  id="search-form"  method="POST"|  {

                        div %|  class="centering" | {

                                fieldset {


                                        textarea %|id="enter-links" rows="2" cols="100" onkeydown="limitLines(this, 13)"| {}
br
                                        input %|type="submit" value="Search" id="search-button"|

script %q{

var links = [];
var ranks = [];
var ranked_results = [];
var a_jax = new XMLHttpRequest();

document.getElementById("search-form").addEventListener("submit", function(evt) {

        evt.preventDefault();
        var area = document.getElementById("input-links");
        var lines = area.value.replace(/\r\n/g,"\n").split("\n");
        links = lines
        var search_area = document.getElementById("enter-links");
        var term = search_area.value
        console.log(links);
        document.getElementById("search-button").innerHTML = "searching";

        var jpack = {

            "links": links,
            "search-term": search_area.value
        }

        a_jax.open("POST","", true);
        a_jax.setRequestHeader("Content-Type", "application/json");
        a_jax.send(JSON.stringify(jpack));
        a_jax.onreadystatechange = function() {

                if (this.readyState == 4){


                        var searched_results = this.responseText;
                        var json_results = JSON.parse(searched_results)

                        var ranklen = json_results.length - 2
                        for (i = 0 ; i <= ranklen ; i++){
                          ranks[i] = json_results[i].split("|||")[4]
                        }
                        console.log("FOUND RANKS")
                        console.log(ranks)

                        var sorted_ranks = ranks.sort(function(a,b) { return a - b; })
                        console.log("SORTED RANKS")
                        console.log(sorted_ranks)

                        for (j = ranklen ; j >= 0 ; j--){

                                for(k = 0 ; k <= ranklen ; k++){
                                        if (sorted_ranks[j] == json_results[k].split("|||")[4]){

                                            ranked_results[ranklen - j] = json_results[k]

                                        }
                                }

                        }

                        ranked_results[ranklen+1] = json_results[ranklen+1]
                        console.log(ranked_results)
                        json_results = ranked_results

                        var Html = "<div>"
                        var results_on_page = 10

                        for (i = 0 ; (i < results_on_page) && (i < json_results.length)  ; i++){

                                if(i == 0) {

                                        line = json_results[json_results.length-1]
                                        Html += "<h3>"+line+"</h3><br>"


                                        Html += "<div class=\"g\">"
                                        Html += "<cite><span><small>" +json_results[i].split("|||")[0]+ "</small></span></cite>"

                                        if(json_results[i].split("|||")[2].length <= 80){
                                              Html += "<div class=\"titled\" > <a href=\""+json_results[i].split("|||")[0] +"\">"+json_results[i].split("|||")[2]+ "</a></div>"
                                        }
                                        else{
                                              var CUT = json_results[i].split("|||")[2].length - 80
                                              var Finecut = new RegExp('.{'+ Cut +'}$')
                                              Html += "<div class=\"titled\" > <a href=\""+json_results[i].split("|||")[0] +"\">"+json_results[i].split("|||")[2].replace(finecut,"...")+ "</a></div>"
                                        }
                                        Html += "<div><span><span>" +json_results[i].split("|||")[1] + "</span> — </span>"
                                        Html += json_results[i].split("|||")[3].replace(term,"<b>"+term+"</b>")+ "</div>"


                                }
                                else {

                                        if(i != (json_results.length - 1 )){

                                                line = json_results[i]
                                                var slice = line.split("|||")



                                                for (j = 0; j < 4 ; j++){
                                                        if (j == 0 ) {

                                                                Html += "<div class=\"g\">"
                                                                Html += "<cite><span><small>" +slice[j]+ "</small></span></cite>"
                                                        }
                                                        else if (j == 2 ) {
                                                                  console.log(slice[j]);

                                                                  if(slice[j].length <= 80){

                                                                          Html += "<div class=\"titled\" > <a href=\""+slice[0] +"\">"+slice[j]+ "</a></div>"

                                                                  }
                                                                  else{
                                                                          var cut = slice[j].length - 80
                                                                          var finecut = new RegExp('.{'+ cut +'}$')

                                                                          Html += "<div class=\"titled\" > <a href=\""+slice[0] +"\">"+slice[j].replace(finecut,"...")+ "</a></div>"


                                                                  }



                                                        }
                                                        else if (j == 3 ) {

                                                                Html += "<div><span><span>" +slice[j-2] + "</span> — </span>"
                                                                Html += slice[j].replace(term,"<b>"+term+"</b>")+ "</div>"

                                                        }
                                                }
                                        }
                                }
                                Html += "</div>";
                                Html += "<br>";
                        }
                        Html += "</div><h3>Only 10 results on the page at a time</h3>";

                        document.getElementById("search-results").innerHTML = Html;

                }
        }
})
}
                                        div {
                                            br
                                            h3 "Search Results"
                                            div %|id="search-results"| {}

                                        }

                                }
                        }

                }
  }
}
end

get "/" do |env|
  p page
end

post "/" do |env|

#  parvati = Ash::Parvati.new
  saraswati = Ash::Saraswati.new
  alt_links = [] of String
  if env.params.json.size == 1

        ################################
        links = env.params.json["links"].as(Array)
        input_query = ""

        links.each do |link|
          link = link.to_s
          alt_links << link
        end

        links = alt_links
        resulted = saraswati.search(links, input_query)
        ################################

        #resulted = parvati.extract_date(links)

        p resulted

  elsif env.params.json.size == 2
        links = env.params.json["links"].as(Array)
        input_query  = env.params.json["search-term"].as(String)

        links.each do |link|
          link = link.to_s
          alt_links << link
        end
        links = alt_links

        searched = saraswati.search(links, input_query)
        p searched

  else
        p "we recieved no JSON baby"
  end

end



Kemal.run
