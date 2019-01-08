module Docx
  extend ActiveSupport::Concern
  
  def fix_order_tag(chart_doc)
    # order tag not in correct order cause word to crash. Hence need to fix order tag
    chart_doc.xpath('//c:order').count.times do |i|
      chart_doc.xpath('//c:order')[i]["val"] = i.to_s
    end 
  end 

  # combine splitted w:t node to single node (word will automatically split w:t node)
  def combine_splitted_wt(main_doc)
    remove_bookmarks main_doc
    # use highlight tag to get the whole variable string
    # since most variable strings have highlight tag
    main_doc.xpath('//w:highlight').each do |highlight_node|
      # jump to next node if cannot find text node 
      next if !highlight_node.parent.next_element
      highlight_text = highlight_node.parent.next_element.content
      if highlight_node.parent.parent.next_element 
        if highlight_node.parent.parent.next_element.name == 'r' 
          next_highlight_node = highlight_node.parent.parent.next_element.xpath('.//w:highlight').first
        # go around the proofErr node
        elsif highlight_node.parent.parent.next_element.next_element && highlight_node.parent.parent.next_element.next_element.name = 'r'
          next_highlight_node = highlight_node.parent.parent.next_element.next_element.xpath('.//w:highlight').first
        end 
      end  
      while next_highlight_node
        highlight_text += next_highlight_node.parent.next_element.content
        next_highlight_node.parent.next_element.content = ""
        if next_highlight_node.parent.parent.next_element 
          next_highlight_node = next_highlight_node.parent.parent.next_element.xpath('.//w:highlight').first
        else 
          next_highlight_node = nil 
        end 
      end 
      highlight_node.parent.next_element.content = highlight_text
    end 
  end 

  def change_docx_text(main_doc, before_text, after_text, node_type = nil)
    default_node_type = node_type ? node_type : "w:t"
    node_set = main_doc.xpath("//#{default_node_type}[contains(text(), '#{before_text}')]")
    node_set.each do |n|
      text = after_text.to_s
      n.content = n.content.sub before_text, text
    end 
  end 

  def replace_superscript(main_doc, after_text)
    vert_align_node = main_doc.at_xpath('//w:vertAlign[@w:val="superscript"]')
    superscript_text_node = vert_align_node.parent.next_element
    superscript_text_node.content = after_text
  end 

  def write_report_file(zip_file, chart_doc_list, main_doc, destination)
    # create buffer 
    document_file_path = 'word/document.xml'
    chart_file_path_list = []
    chart_doc_list.count.times do |i|
      chart_file_path = "word/charts/chart#{i+1}.xml"
      chart_file_path_list << chart_file_path
    end 
    buffer = Zip::OutputStream.write_buffer do |out|
      zip_file.entries.each do |e|
        unless ([document_file_path] + chart_file_path_list).include?(e.name)
          out.put_next_entry(e.name)
          out.write e.get_input_stream.read
        end
      end

      out.put_next_entry(document_file_path)
      out.write main_doc.to_xml(:indent => 0).gsub("\n","")

      chart_file_path_list.each_index do |index|
        out.put_next_entry(chart_file_path_list[index])
        out.write chart_doc_list[index].to_xml(:indent => 0).gsub("\n","")
      end 

    end
    # write to file 
    File.open(destination, "wb") {|f| f.write(buffer.string) }
  end 

  def remove_bookmarks(main_doc)
    
    main_doc.at_xpath('//w:bookmarkStart').remove
    main_doc.at_xpath('//w:bookmarkEnd').remove
    
  end 

  def change_gender(gender, main_doc)
    if gender == "girl" || gender == 'F'
      change_docx_text(main_doc, 'he_she', 'she')
      change_docx_text(main_doc, 'He_She', 'She')
      change_docx_text(main_doc, 'his_her', 'her')
      change_docx_text(main_doc, 'His_Her', 'Her')
      change_docx_text(main_doc, 'him_her', 'her')
      change_docx_text(main_doc, 'Him_Her', 'Her')
    else
      change_docx_text(main_doc, 'he_she', 'he')
      change_docx_text(main_doc, 'He_She', 'He')
      change_docx_text(main_doc, 'his_her', 'his')
      change_docx_text(main_doc, 'His_Her', 'His')
      change_docx_text(main_doc, 'him_her', 'him')
      change_docx_text(main_doc, 'Him_Her', 'Him')
    end 
  end 

  def remove_highlight(main_doc)
    main_doc.xpath('//w:highlight').each do |highlight_node|
      highlight_node.replace(highlight_node.children)
    end 
  end 

  def write_STAR_main_doc_texts(main_doc, gender, test_count, latest_score, old_score, first_name, last_name)
    change_docx_text(main_doc, 'Child_name_full', "#{first_name} #{last_name}")
    change_docx_text(main_doc, 'Child_name', "#{first_name}")
    # update all latest_scaled_score
    change_docx_text(main_doc, 'latest_ss', "#{latest_score}")
    # update number of tests
    words_hash = {0=>"zero",1=>"one",2=>"two",3=>"three",4=>"four",5=>"five",6=>"six"}
    text = words_hash[test_count]
    change_docx_text(main_doc, 'n_tests', text)
    # update scaled score change text 
    new_text = text = latest_score > old_score ? "an increase" : "a decrease"
    change_docx_text(main_doc, 'ss_cg', new_text )
    # update scaled score difference 
    change_docx_text(main_doc, 'ss_diff', (latest_score - old_score).abs.to_s)
    # update old score 
    change_docx_text(main_doc, 'old_ss', old_score)
    change_gender gender, main_doc
  end 

  def write_STAR_chart_doc(chart_doc, tests)
    first_name = tests.first.student.get_first_name
    last_name = tests.first.student.last_name
    # update Child name in chart 
    change_docx_text(chart_doc, "Child name", "#{first_name} #{last_name}", "a:t")
    test_count = chart_doc.xpath('//c:ser[descendant::c:cat]').count  
    for i in 0...tests.count 
      test = tests[i]
      # only update test score for available test date count 
      if i < test_count
        # set test date label 
        chart_doc.at_xpath("//c:ser[descendant::c:cat][#{i+1}]/c:tx/c:strRef/c:strCache/c:pt/c:v").content = test.test_date.strftime('%m/%d/%Y')
        # get test categorys 
        test_category_array = []
        chart_doc.xpath("//c:ser[#{i+1}]/c:cat/c:strRef/c:strCache/c:pt/c:v").each do |node|
          ser_node = node.parent.parent.parent.parent.parent
          
          test_category = node.content
          test_category_array << test_category
          test_category_index = test_category_array.count
          
          test_category_value_node = ser_node.at_xpath("(./c:val/c:numRef/c:numCache/c:pt/c:v)[#{test_category_index}]")
          test_category_value_node.content = test[test_category.downcase.gsub(" ", "_").gsub(":", "")]
        end  
      end 
    end 
  
    # remove extra test dates (columns)
    if tests.count < test_count
      (test_count - tests.count).times do 
        chart_doc.xpath('//c:ser[descendant::c:cat]').last.remove
      end 
    end 
  
    # fix order tag 
    fix_order_tag chart_doc
  end

end 