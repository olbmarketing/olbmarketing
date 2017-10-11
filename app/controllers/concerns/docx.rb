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
    if gender == "girl"
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

end 