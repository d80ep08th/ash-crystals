var links = []
var a_jax = new XMLHttpRequest();

document
        .getElementById("links-form")
        .addEventListener("submit", function(evt) {
            evt.preventDefault();
            var area = document.getElementById("input-links");

            var lines = area.value.replace(/\r\n/g,"\n").split("\n");

            links = lines
            console.log(links);
            var  jpack = {
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
