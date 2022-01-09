require "http/client"
require "benchmark"
require "halite"
require "xml"


module Ash
  class Saraswati



    def search(links,term)

        searching = [] of String
        t_t_t = Time.utc - Time.utc
        ex_path = "//body"
        title_path = "//title"
        day = "date"
        titled = "Title"
        snippet = "Snippet"
        # "___________________________ #{regular expressions}______________________________"
        snipex = /(\.|\n|\s)\w+\s.{1,100}\s#{term}\s.{1,100}\w+\./
        regex = /\b(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|(Nov|Dec)(?:ember)?)\s(?:[0-3][0-9]|[0-9]),\s(?:[1,2][0,9][0,1,2,9][0-9])\b/
        alt_regex = /\b(?:[0-3][0-9]|[0-9])\s(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|(Nov|Dec)(?:ember)?)\s(?:[1,2][0,9][0,1,2,9][0-9])\b/
        date_regex = /(?:[1,2][0,9][0,1,2,9][0-9])-(?:0(?:[1-9])?|1(?:[0-2])?)-(?:3(?:[0,1])?|(0|1|2)(?:[0-9])?)T(?:2(?:[0-4])?|(0|1)(?:[0-9])?):(?:[0-5](?:[0-9])?):(?:[0-5](?:[0-9])?)\D(\d{2,4}|)(:\d{2}|Z|)/


    #Add caching, storing content and extracted date for processed URLs. The cache should be
    #capable of storing up to 10,000 URLs and should be used if the URL is requested again
    #check if the link exists in cache , make the cache in json format
    #if not in cache , then add to cache after finding result
    #Crawl the links

        links.each do |link|

              snippet = "Snippet"
              titled = "Title"
              
              timer_start = Time.utc

              soup = Halite.follow.get(link, headers: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0"}).body
              bad_soup = soup
              xml_soup = XML.parse_html(soup)

              if (!xml_soup.xpath_nodes(ex_path).empty?)

                  # "___________________________ #{titled}______________________________"
                  if (!xml_soup.xpath_nodes(title_path).empty?)
                      xml_soup.xpath_nodes(title_path)[0].children.each do |child|
                        titled = child.text
                      end
                  end

                  xml_soup.xpath_nodes(ex_path)[0].children.each do |child|

                    word = child.text

                    # "___________________________ #{snippet}______________________________"
                    if snippet == "Snippet"
                        if word.matches?(snipex)
                          snipex.match(word)
                          snippet = $0

                          if snippet.matches?(/\s\W\s|.?\\.?|\sJavascript\s|\Wjs/)
                              snippet = "Snippet"
                          end

                        end

                    end
                    # "___________________________ #{day}______________________________"
                    if word.matches?(regex)
                      regex.match(word)
                      day = $0


                    elsif word.matches?(alt_regex)
                      alt_regex.match(word)
                      day = $0

                    elsif word.matches?(date_regex)
                      date_regex.match(word)
                      day = $0
                    end

                  end
              end

              timer_stop = Time.utc
              time_taken = timer_stop-timer_start
              if snippet == "Snippet"
                snippet = term
              end

              searching << "#{link}|||#{day}|||#{titled}|||#{snippet}"


              # "#{time_taken.milliseconds}ms"
              if links[0] == link
                 t_t_t = time_taken
              else
                t_t_t = time_taken + t_t_t
              end

              if links[links.size-1] == link

                searching << "Total Time of Execution: #{t_t_t.seconds}s#{t_t_t.milliseconds}ms"

              end
        end


        searching.to_json

    end
  end
end
#Show up to 10 results in a format similar to Google (title, url, snippet)
#On the top of search results show total server time to generate responsev
