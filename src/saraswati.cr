require "http/client"
require "benchmark"
require "halite"
require "xml"


module Ash
  class Saraswati



    def search(links,input_query)

      if !File.exists?("cache")
        File.touch("cache")
        File.new("cache", mode = "r+")
        p "a new cache was created"
      end
        rank = 0
        searching = [] of String
        t_t_t = Time.utc - Time.utc
        body_path = "//body"
        head_path = "//head"
        title_path = "//title"
        day = "date"
        titled = "Title"
        snippet = "Snippet"
        link_included = false
        # "___________________________ #{regular expressions}______________________________"
        snipex = /(\.|\n|\s)\w+\s.{1,30}\s#{input_query}\s.{1,100}\w*/ #\.$
        regex = /\b(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|(Nov|Dec)(?:ember)?)\s(?:[0-3][0-9]|[0-9]),\s(?:[1,2][0,9][0,1,2,9][0-9])\b/
        alt_regex = /\b(?:[0-3][0-9]|[0-9])\s(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|(Nov|Dec)(?:ember)?)\s(?:[1,2][0,9][0,1,2,9][0-9])\b/
        date_regex = /(?:[1,2][0,9][0,1,2,9][0-9])-(?:0(?:[1-9])?|1(?:[0-2])?)-(?:3(?:[0,1])?|(0|1|2)(?:[0-9])?)T(?:2(?:[0-4])?|(0|1)(?:[0-9])?):(?:[0-5](?:[0-9])?):(?:[0-5](?:[0-9])?)\D(\d{2,4}|)(:\d{2}|Z|)/


        links.each do |link|
              p link
              link_included = false
              snippet = "Snippet"
              titled = "Title"
              day = "date"
              rank = 0

              timer_start = Time.utc
              soup = Halite.follow.get(link, headers: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0"}).body
              bad_soup = soup
              xml_soup = XML.parse_html(soup)

              File.open("cache", mode = "r+") do |file|

                      file.each_line do |line|

                                        linkex = /#{link}/
                                        if line.matches?(linkex)

                                                # "link|||day|||titled"
                                                cached_line = line.partition("|||")[2]
                                                #day|||titled
                                                day = cached_line.partition("|||")[0]
                                                #p line
                                                #p day
                                                #day
                                                titled = cached_line.partition("|||")[2]
                                                #p titled
                                                #titled
                                                link_included = true

                                        end
                      end
                      #if the link has a filled body tag
                      if (!xml_soup.xpath_nodes(body_path).empty?)&&(titled == "Title")&&(day == "date")&&(input_query != "")


                              if bad_soup.matches?(regex)
                                      regex.match(bad_soup)
                                      day = $0
                              elsif bad_soup.matches?(alt_regex)
                                      alt_regex.match(bad_soup)
                                      day = $0
                              end




                              # "___________________________ #{titled}______________________________"

                              xml_soup.xpath_nodes(title_path)[0].children.each do |child|
                                      titled = child.text
                              end



                              xml_soup.xpath_nodes(body_path)[0].children.each do |child|

                                      word = child.text
                                      if snippet == "Snippet"
                                              if word.matches?(snipex)
                                                      snipex.match(word)
                                                      snippet = $0

                                                      #if snippet.matches?(/\s\W\s|.?\\.?|\sJavascript\s|\Wjs/)
                                                      #        snippet = "Snippet"
                                                      #end

                                              end
                                      end

                              end#body_path children
                      elsif (!xml_soup.xpath_nodes(body_path).empty?)&&(input_query != "")

                              xml_soup.xpath_nodes(body_path)[0].children.each do |child|

                                      word = child.text
                                      if snippet == "Snippet"
                                              if word.matches?(snipex)
                                                      snipex.match(word)
                                                      snippet = $0

                                                      #if snippet.matches?(/\s\W\s|.?\\.?|\sJavascript\s|\Wjs/)
                                                      #        snippet = "Snippet"
                                                      #end

                                              end
                                      end


                              end#body_path children
                      elsif (input_query == "")&&(titled == "Title")&&(day == "date")

                              if bad_soup.matches?(regex)
                                      regex.match(bad_soup)
                                      day = $0
                              elsif bad_soup.matches?(alt_regex)
                                      alt_regex.match(bad_soup)
                                      day = $0
                              end

                              xml_soup.xpath_nodes(title_path)[0].children.each do |child|
                                      titled = child.text
                              end
                      end


                      bad_soup.lines.each do |line|
                          if line.matches?(date_regex)
                              rank = rank + 1
                          end
                          if line.matches?(/type\=\"application/)
                              rank = rank + 1
                          end
                          if line.matches?(/\<link/)
                            rank = rank + 1
                          end
                          if line.matches?(/\<meta/)
                            rank = rank + 1
                          end
                          if line.matches?(/\<p/)
                            rank = rank + 1
                          end
                          if line.matches?(/\<script/)
                            rank = rank + 1
                          end
                          if line.matches?(/application\/ld+json/)
                            rank = rank + 5
                          end
                          if line.matches?(/#{input_query}/)
                            rank = rank + 10
                          end

                      end
                      rank = rank + link.size
                      # "rank ====> #{rank}"
                      if snippet == "Snippet"
                        snippet = input_query
                      end
                      timer_stop = Time.utc
                      time_taken = timer_stop-timer_start

                      # "#{time_taken.milliseconds}ms"
                      if links[0] == link
                         t_t_t = time_taken
                      else
                        t_t_t = time_taken + t_t_t
                      end

                      if(!link_included)&&(File.read_lines("cache").size <= 10000)

                              file << "#{link}|||#{day}|||#{titled}"
                              file << "\n"
                              p "file size :::> #{File.read_lines("cache").size}"
                      end

                      if input_query == ""
                              searching << "#{link}|#{day}|#{time_taken.milliseconds}ms"
                      else
                              searching << "#{link}|||#{day}|||#{titled}|||#{snippet}|||#{rank}"
                            #searching << "#{link}|||#{day}|||#{titled}|||#{snippet}|||#{rank}"
                      end

                      if links[links.size-1] == link
                        searching << "Total Time of Execution: #{t_t_t.seconds}s#{t_t_t.milliseconds}ms"
                      end
              end#file
        end#links.each


        searching.to_json

    end
  end
end
