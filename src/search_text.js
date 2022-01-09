
                      var links = []
                      var a_jax = new XMLHttpRequest();

                      document
                              .getElementById("search-form")
                              .addEventListener("submit", function(evt) {
                                  evt.preventDefault();
                                  var area = document.getElementById("input-links");

                                  var lines = area.value.replace(/\r\n/g,"\n").split("\n");

                                  links = lines
                                  var search_area = document.getElementById("enter-links");

                                  console.log(links);
                                  document.getElementById("search-results").innerHTML = "searching";
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


                                              Html += "<small>"+line+"</small><br>"

                                            }
                                            else {
                                              line = json_results[i]
                                              var slice = line.split("|||")
                                              console.log(slice)

                                              for (j = 0; j < 4 ; j++){

                                                if (j == 0 ) { Html += "<small>" +slice[j]+ "</small>" }
                                                else if (j == 2 ) {  Html += "<h3 align=left>" +slice[j]+ "</h3>" }
                                                else if (j == 3 ) {
                                                  Html += "<p align=left>" +slice[j-2]

                                                  Html += slice[j]+ "</p>"

                                                }

                                              }
                                            }
                                        Html += "<br>";
                                      }
                                      Html += "</div>";

                                      document.getElementById("search-results").innerHTML = Html;

                                    }
                                  }
                                })
