require "http/client"
require "benchmark"
require "halite"
require "xml"

module Ash
  class Parvati

    def extract_date(links) #: Array(String)


        resulting = [] of String

        t_t_t = Time.utc - Time.utc
        ex_path = "//body"

        # "___________________________ #{regular expressions}______________________________"

        regex = /\b(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|(Nov|Dec)(?:ember)?)\s(?:[0-3][0-9]|[0-9]),\s(?:[1,2][0,9][0,1,2,9][0-9])\b/
        alt_regex = /\b(?:[0-3][0-9]|[0-9])\s(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|(Nov|Dec)(?:ember)?)\s(?:[1,2][0,9][0,1,2,9][0-9])\b/
        date_regex = /(?:[1,2][0,9][0,1,2,9][0-9])-(?:0(?:[1-9])?|1(?:[0-2])?)-(?:3(?:[0,1])?|(0|1|2)(?:[0-9])?)T(?:2(?:[0-4])?|(0|1)(?:[0-9])?):(?:[0-5](?:[0-9])?):(?:[0-5](?:[0-9])?)\D(\d{2,4}|)(:\d{2}|Z|)/


          links.each do |link|
            p Benchmark.realtime {
              timer_start = Time.utc
              day = "date"
              #word = client.get(link, headers: HTTP::Headers{"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0", "Content-Type" => "application/ld+json"}).body
              soup = Halite.follow.get(link, headers: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0"}).body
              bad_soup = soup
              xml_soup = XML.parse_html(soup)

              if (!xml_soup.xpath_nodes(ex_path).empty?)
                xml_soup.xpath_nodes(ex_path)[0].children.each do |child|

                  word = child.text

                  if word.matches?(regex)
                    regex.match(word)
                    day = $0
                    #p "___________________________day => #{day}______________________________"

                  elsif word.matches?(alt_regex)
                    alt_regex.match(word)
                    day = $0
                    #p "___________________________day => #{day}______________________________"

                  elsif word.matches?(date_regex)
                    date_regex.match(word)
                    day = $0
                    #p "___________________________day => #{day}______________________________"
                  end


                end
              end

              if day == "date" || day.matches?(date_regex)
                #bad_soup = Halite.follow.get(link, headers: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0"}).body
                if bad_soup.matches?(regex)
                  regex.match(bad_soup)
                  day = $0
                  #p "___________________________day => #{day}______________________________"

                elsif bad_soup.matches?(alt_regex)
                  alt_regex.match(bad_soup)
                  day = $0
                  #p "___________________________day => #{day}______________________________"
                end
              end

              timer_stop = Time.utc
              time_taken = timer_stop-timer_start
              p "#{link}|#{day}|#{time_taken.milliseconds}ms"
              resulting << "#{link}|#{day}|#{time_taken.milliseconds}ms"


              if links[0] == link
                 t_t_t = time_taken

              else
                t_t_t = time_taken + t_t_t

              end


            }
            if links[links.size-1] == link
              p "Total Time of Execution: #{t_t_t.seconds}s#{t_t_t.milliseconds}ms"
              resulting << "Total Time of Execution: #{t_t_t.seconds}s#{t_t_t.milliseconds}ms"

            end
          end
          #p "___________RESULTING_______________"
          #p resulting
          #p "____________________________________"


          resulting.to_json

      end

  end
end
