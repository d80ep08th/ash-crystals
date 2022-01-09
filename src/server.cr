require "kemal"
require "water"
# mentioning ``text <<-HTML ``  is very important while adding tags that water is not aware of
#require "./sample"
require "./parvati"
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
            style %q{

              .centering{ text-align:center;}
              .titled{
                font-family: arial,sans-serif;
                padding-top: 5px;
                font-size: 20px;
                margin-bottom: 3px;
              }
              .g{
                width: 600px;
                margin-top: 0;
                margin-bottom: 30px;
                line-height: 1.58;
                text-align: left;
              }
            }
            script %q{

              console.log("This script is being generated with crystal lang")
            }
            link %|rel="stylesheet" media="screen"|
      }
      body {
            #Web page with a form containing
            div %|  class="centering" | {

                  h2  Time.local
                  br
                  h1 "Extract dates from site"
            }
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

                  }
                }

              }
              div %|  class="centering" | {
                  br
                  h1 "Your Result"
                  div %|id="extract"| {}

              }

            br
            hr
            form  %|  id="search-form"  method="POST"|  {

              div %|  class="centering" | {
                  fieldset {

                    script %q{}
                    textarea %|id="enter-links" rows="2" cols="100" onkeydown="limitLines(this, 13)"| {}
                    br
                    input %|type="submit" value="Search" id="search-button"|

script %q{

var links = [];
var a_jax = new XMLHttpRequest();

document.getElementById("search-form").addEventListener("submit", function(evt) {

        evt.preventDefault();
        var area = document.getElementById("input-links");
        var lines = area.value.replace(/\r\n/g,"\n").split("\n");
        links = lines
        var search_area = document.getElementById("enter-links");

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

                        var Html = "<div>"

                        for (i = 0 ; i < json_results.length ; i++){

                                if(i == 0) {

                                        line = json_results[json_results.length-1]
                                        Html += "<h3>"+line+"</h3><br>"

                                }
                                else {

                                        if(i != (json_results.length - 1 )){

                                                line = json_results[i]
                                                var slice = line.split("|||")

                                                console.log(slice)

                                                for (j = 0; j < 4 ; j++){
                                                        if (j == 0 ) {

                                                                Html += "<div class=\"g\">"
                                                                Html += "<cite><span><small>" +slice[j]+ "</small></span></cite>"
                                                        }
                                                        else if (j == 2 ) {  Html += "<div class=\"titled\" > <a href=\""+slice[0] +"\">"+slice[j]+ "</a></div>" }
                                                        else if (j == 3 ) {

                                                                Html += "<div><span><span>" +slice[j-2]+ "</span> — </span>"
                                                                Html += slice[j]+ "</div>"

                                                        }
                                                }
                                        }
                                }
                                Html += "</div>";
                                Html += "<br>";
                        }
                        Html += "</div>";

                        document.getElementById("search-results").innerHTML = Html;

                }
        }
})
}
                  }
                }

              }
              div {
                  br
                  h3 "Search Results"
                  div %|id="search-results"| {}

              }


      }
    }
end

get "/" do |env|
  p page
end

post "/" do |env|

  parvati = Ash::Parvati.new
  saraswati = Ash::Saraswati.new
  alt_links = [] of String
  if env.params.json.size == 1
        links = env.params.json["links"].as(Array)

        links.each do |link|
          link = link.to_s
          alt_links << link
        end
        links = alt_links
        resulted = parvati.extract_date(links)

        p resulted

  elsif env.params.json.size == 2
        links = env.params.json["links"].as(Array)
        term  = env.params.json["search-term"].as(String)

        links.each do |link|
          link = link.to_s
          alt_links << link
        end
        links = alt_links

        searched = saraswati.search(links, term)
        p searched

  else
        p "we recieved no JSON baby"
  end

end



Kemal.run
